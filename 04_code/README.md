# 04_code: Source code snapshot

This folder holds the source repository (https://github.com/Patrick-Sheng/P4P-Besu, branch `main`) in `P4P-Besu/`.

## While preparing the compendium

`P4P-Besu/` is a normal git clone of the source repository. It is not committed to the compendium repository (it is listed in `.gitignore`), and it is not copied into the zip as it is.

To set it up, from the compendium repository's root folder:

```bash
git clone https://github.com/Patrick-Sheng/P4P-Besu.git 04_code/P4P-Besu
```

Before building, make sure the clone is on the right branch and up to date:

```bash
git -C 04_code/P4P-Besu checkout main
git -C 04_code/P4P-Besu pull
```

### Updated READMEs (`Code-Doc/`)

`Code-Doc/` holds rewritten READMEs for the source repository that are not yet on its `main` branch:
- `README.md`: the repository's root README (stack, layout, basic 4-validator setup)
- `frontend/README.md`: the voter and administrator web app
- `voting-contract/README.md`: the contract, its tests and deployment

The build script copies these over the matching files in the snapshot, so the zip has the updated versions. Once they are committed to `main` in the source repository, this folder can be deleted.

## Building the zip

From the compendium repository's root folder, run:

```bash
bash build-compendium.sh <upiA> <upiB>
```

The script:
1. Copies the compendium documents into a staging folder, without the `P4P-Besu/` clone, `Code-Doc/`, the build script, `.git`, `.gitignore`, any `_TODO.md` files and any built zips.
2. Exports the clone's committed files with `git archive HEAD` into `04_code/P4P-Besu/` in the staging folder, then copies `Code-Doc/` over it.
3. Fills in the UPIs and the clone's commit hash in the main `README.md`.
4. Checks for open TODOs, empty folders, unfilled placeholders, a `.git` folder in the snapshot, private keys and the 2 GB limit.
5. Writes `68_<upiA>_<upiB>-compendium.zip` in the repository root (ignored by git).

Only committed files are exported, so the clone's `.git` history, gitignored `.env` files, validator keys and chain data stay out of the zip. Do not zip this folder by hand.

The script needs bash, git and zip (Ubuntu, WSL, or Git Bash with zip installed).

## In the submitted zip

`P4P-Besu/` is the exported snapshot. The commit it was taken from is given at the top of the main `README.md`. See Section 3 of that README for what each folder contains, and Section 5 for how to reproduce the tests.

The contract's test library `voting-contract/lib/forge-std` is a git submodule and is not included. Run `forge install foundry-rs/forge-std` in `voting-contract/` to fetch it.
