#!/usr/bin/env bash
# Builds the Project 68 research compendium zip for Canvas.
#
# Usage (from the compendium repository's root folder):
#   bash build-compendium.sh <upiA> <upiB>
#
# Expected layout (this script sits in the repository root):
#   README.md, 01_project-records/ ... 07_future-work/   The compendium documents
#   04_code/README.md          Explains the code snapshot
#   04_code/P4P-Besu/          A git clone of https://github.com/Patrick-Sheng/P4P-Besu
#                              (not committed to the compendium repo; see .gitignore)
#   04_code/P4P-Besu-docs/     Optional: updated READMEs copied over the snapshot
#
# What it does:
#   1. Copies the compendium documents into a staging folder, leaving out the P4P-Besu clone,
#      P4P-Besu-docs/, this script, .git, .gitignore, any _TODO.md files and any built zips.
#   2. Exports the clone's committed files (git archive HEAD) into 04_code/P4P-Besu/, then
#      copies P4P-Besu-docs/ over it. Only committed files are included, so the .git history,
#      gitignored keys, .env files and chain data stay out.
#   3. Fills <UPI-A>, <UPI-B> and <COMMIT> in the README.
#   4. Checks for leftover TODOs, empty folders, placeholders, private keys and the 2 GB limit.
#   5. Writes 68_<upiA>_<upiB>-compendium.zip in the repository root.
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: bash build-compendium.sh <upiA> <upiB>" >&2
  exit 1
fi
UPI_A=$1
UPI_B=$2

COMP=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)   # the compendium repository root
OUTDIR=$COMP
CODE="$COMP/04_code/P4P-Besu"
DOCS="$COMP/04_code/P4P-Besu-docs"
NAME="68_${UPI_A}_${UPI_B}-compendium"
OUT_ZIP="$OUTDIR/$NAME.zip"
STAGE=$(mktemp -d)
ROOT="$STAGE/$NAME"
trap 'rm -rf "$STAGE"' EXIT

command -v zip >/dev/null || { echo "zip is not installed (sudo apt install zip)" >&2; exit 1; }

if ! git -C "$CODE" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "No git clone found at 04_code/P4P-Besu." >&2
  echo "Clone it first: git clone https://github.com/Patrick-Sheng/P4P-Besu.git 04_code/P4P-Besu" >&2
  exit 1
fi
if [ -n "$(git -C "$CODE" status --porcelain)" ]; then
  echo "WARNING: uncommitted changes in 04_code/P4P-Besu. Only committed files go into the zip." >&2
  git -C "$CODE" status --short | head -20 >&2
fi
BRANCH=$(git -C "$CODE" rev-parse --abbrev-ref HEAD)
COMMIT=$(git -C "$CODE" rev-parse --short HEAD)
echo "Code snapshot: P4P-Besu branch $BRANCH, commit $COMMIT"

# 1. compendium documents and the files you added (without the clone)
mkdir -p "$ROOT"
tar -C "$COMP" \
    --exclude='./04_code/P4P-Besu' \
    --exclude='./04_code/P4P-Besu-docs' \
    --exclude='./build-compendium.sh' \
    --exclude='./.git' \
    --exclude='./.gitignore' \
    --exclude='./.gitattributes' \
    --exclude='*.zip' \
    -cf - . | tar -x -C "$ROOT"
find "$ROOT" -name '_TODO.md' -delete

# 2. code and data snapshot from the clone's committed files
mkdir -p "$ROOT/04_code/P4P-Besu"
git -C "$CODE" archive --format=tar HEAD | tar -x -C "$ROOT/04_code/P4P-Besu"
# updated READMEs not yet committed to the source repository
if [ -d "$DOCS" ]; then
  cp -a "$DOCS/." "$ROOT/04_code/P4P-Besu/"
  echo "Copied updated READMEs from 04_code/P4P-Besu-docs over the snapshot"
fi
# forge-std is a submodule and is not in git archive; note how to fetch it
mkdir -p "$ROOT/04_code/P4P-Besu/voting-contract/lib"
echo "voting-contract/lib/forge-std is a git submodule: run 'forge install foundry-rs/forge-std' in voting-contract/." \
  > "$ROOT/04_code/P4P-Besu/voting-contract/lib/README.txt"

# 3. placeholders
sed -i -e "s/<UPI-A>/$UPI_A/g" -e "s/<UPI-B>/$UPI_B/g" -e "s/<COMMIT>/$COMMIT/g" "$ROOT/README.md"

# 4. checks
problems=0
while IFS= read -r f; do
  echo "TODO still open: ${f#$COMP/}" >&2; problems=1
done < <(find "$COMP" \( -path "$CODE" -o -path "$COMP/.git" \) -prune -o -name '_TODO.md' -print)
for d in 01_project-records 02_submissions/patrick-sheng 02_submissions/eason-chang 03_design 05_data-and-analysis/plots; do
  if [ -z "$(ls -A "$ROOT/$d" 2>/dev/null)" ]; then
    echo "EMPTY: $d" >&2; problems=1
  fi
done
if grep -q '<plot file>\|<raw JSON-RPC output' "$ROOT/05_data-and-analysis/FIGURE-DATA-MAP.md"; then
  echo "FIGURE-DATA-MAP.md still has <plot file> or <raw JSON-RPC output> placeholders" >&2; problems=1
fi
if [ -d "$ROOT/04_code/P4P-Besu/.git" ]; then
  echo "ERROR: .git folder found in the code snapshot" >&2; problems=1
fi
# private keys: .env files, Besu key files, JSON with a privateKey field
leaks=$(find "$ROOT" \( -name '.env' -o -name '.env.*' -o -name 'key' -o -name 'key.priv' \) ! -name '*.example' -type f; \
        grep -rlE '"?private[_]?[kK]ey"?[[:space:]]*[:=][[:space:]]*"?0x[0-9a-fA-F]{64}' "$ROOT" 2>/dev/null || true)
if [ -n "$leaks" ]; then
  echo "POSSIBLE PRIVATE KEYS, check before submitting:" >&2
  echo "$leaks" | sed "s|$ROOT/||" >&2
  problems=1
fi

# 5. zip
rm -f "$OUT_ZIP"
(cd "$STAGE" && zip -qr "$OUT_ZIP" "$NAME")
SIZE=$(stat -c %s "$OUT_ZIP")
echo "Wrote $OUT_ZIP ($(numfmt --to=iec "$SIZE"), P4P-Besu commit $COMMIT)"
if [ "$SIZE" -ge 2000000000 ]; then
  echo "ERROR: zip is over the 2 GB Canvas limit" >&2; exit 1
fi
if [ "$problems" -ne 0 ]; then
  echo "Built, but see the warnings above before submitting." >&2
  exit 2
fi
echo "All checks passed."
