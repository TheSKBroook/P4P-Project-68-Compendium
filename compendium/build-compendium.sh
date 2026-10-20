#!/usr/bin/env bash
# Builds the Project 68 research compendium zip for Canvas.
#
# Usage (from anywhere inside the repo):
#   bash compendium/build-compendium.sh <upiA> <upiB>
#
# What it does:
#   1. Copies compendium/ (minus this script and any _TODO.md files) into a staging folder.
#   2. Exports the committed repo (git archive HEAD, without compendium/) into 04_code/P4P-Besu/.
#      Only committed files are included, so gitignored keys, .env files and chain data stay out.
#   3. Fills <UPI-A>, <UPI-B> and <COMMIT> in the compendium README.
#   4. Checks for leftover TODOs, empty folders, private keys and the 2 GB limit.
#   5. Writes 68_<upiA>_<upiB>-compendium.zip in the repo root.
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: bash compendium/build-compendium.sh <upiA> <upiB>" >&2
  exit 1
fi
UPI_A=$1
UPI_B=$2

REPO=$(git rev-parse --show-toplevel)
cd "$REPO"
NAME="68_${UPI_A}_${UPI_B}-compendium"
OUT_ZIP="$REPO/$NAME.zip"
STAGE=$(mktemp -d)
ROOT="$STAGE/$NAME"
trap 'rm -rf "$STAGE"' EXIT

command -v zip >/dev/null || { echo "zip is not installed (sudo apt install zip)" >&2; exit 1; }

if [ -n "$(git status --porcelain -- . ':!compendium' ':!*.zip')" ]; then
  echo "WARNING: uncommitted changes outside compendium/. Only committed files go into 04_code/." >&2
  git status --short -- . ':!compendium' ':!*.zip' | head -20 >&2
fi
COMMIT=$(git rev-parse --short HEAD)

# 1. compendium documents and the files you added
mkdir -p "$ROOT"
cp -a compendium/. "$ROOT/"
rm -f "$ROOT/build-compendium.sh"
find "$ROOT" -name '_TODO.md' -delete

# 2. code and data snapshot
mkdir -p "$ROOT/04_code/P4P-Besu"
git archive --format=tar HEAD -- . ':!compendium' | tar -x -C "$ROOT/04_code/P4P-Besu"
# forge-std is a submodule and is not in git archive; note how to fetch it
echo "voting-contract/lib/forge-std is a git submodule: run 'forge install foundry-rs/forge-std' in voting-contract/." \
  > "$ROOT/04_code/P4P-Besu/voting-contract/lib/README.txt" 2>/dev/null || true

# 3. placeholders
sed -i -e "s/<UPI-A>/$UPI_A/g" -e "s/<UPI-B>/$UPI_B/g" -e "s/<COMMIT>/$COMMIT/g" "$ROOT/README.md"

# 4. checks
problems=0
for f in $(find compendium -name '_TODO.md'); do
  echo "TODO still open: $f" >&2; problems=1
done
for d in 01_project-records 02_submissions/patrick-sheng 02_submissions/eason-chang 03_design 05_data-and-analysis/plots; do
  if [ -z "$(ls -A "$ROOT/$d" 2>/dev/null)" ]; then
    echo "EMPTY: $d" >&2; problems=1
  fi
done
if grep -q '<plot file>\|<raw JSON-RPC output' "$ROOT/05_data-and-analysis/FIGURE-DATA-MAP.md"; then
  echo "FIGURE-DATA-MAP.md still has <plot file> placeholders" >&2; problems=1
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
echo "Wrote $OUT_ZIP ($(numfmt --to=iec "$SIZE"), commit $COMMIT)"
if [ "$SIZE" -ge 2000000000 ]; then
  echo "ERROR: zip is over the 2 GB Canvas limit" >&2; exit 1
fi
if [ "$problems" -ne 0 ]; then
  echo "Built, but see the warnings above before submitting." >&2
  exit 2
fi
echo "All checks passed."
