# Research Compendium: Project 68

**Evaluating the suitability of a private permissioned blockchain (Hyperledger Besu, IBFT 2.0) for New Zealand general elections**

Part 4 Project, Department of Electrical, Computer and Software Engineering, University of Auckland, 2026

| | |
|---|---|
| Students | Patrick Sheng (`<UPI-A>`), Eason Chang (`<UPI-B>`) |
| Supervisors | Dev Singh, Kevin Sowerby |
| Source repository | https://github.com/Patrick-Sheng/P4P-Besu (branch `main`) |
| Compendium snapshot | Commit `<COMMIT>` of `main` |

This compendium is the online technical appendix to the two individual final reports. It contains the
code, configuration, raw test data, analysis scripts and procedures needed to rebuild the voting network,
repeat every test reported, and trace every figure and table back to the data it came from.

## 1. What the project did

We built a private, permissioned blockchain for recording votes in a New Zealand general election and
evaluated whether it could meet the requirements of a national election. The system runs on
Hyperledger Besu 24.12.0 with IBFT 2.0 consensus, and the voting rules live in one Solidity smart
contract, `VotingSystem.sol`, which moves each voter through three states (NotVoted, Processing, Voted).

The two reports split the evaluation:

| Report | Focus | Tests it draws on |
|---|---|---|
| **P. Sheng**, *Evaluating the Suitability of Blockchain Frameworks for New Zealand's General Election*: consensus and performance | Throughput, confirmation latency, network size, validator failures, voter attacks | Areas 1 to 4 (round 1), round 2 election-scale tests, round 3 validator-count tests |
| **E. Chang**, *Assessing the Suitability of Blockchain Frameworks for New Zealand General Elections*: infrastructure and integrity | Network design, tally audit across validators, storage growth | Additional tests T0 to T3 |

## 2. Folder structure

```
68_<UPI-A>_<UPI-B>-compendium/
├── README.md                    This file
├── 01_project-records/          Project brief, meeting notes and actions, journal
├── 02_submissions/
│   ├── patrick-sheng/           Every file Patrick submitted on Canvas
│   └── eason-chang/             Every file Eason submitted on Canvas
├── 03_design/                   Architecture and process diagrams (Draw.io / Mermaid sources and exports)
├── 04_code/P4P-Besu/            Snapshot of the source repository (see Section 3)
├── 05_data-and-analysis/
│   ├── FIGURE-DATA-MAP.md       Every report figure and table mapped to its data and script
│   └── plots/                   Scripts or spreadsheets that draw the report figures
├── 06_environment/
│   └── ENVIRONMENT.md           Test machine specification, software versions, network parameters
└── 07_future-work/
    └── FUTURE-WORK.md           Open questions, unfinished work and suggested next steps
```

### 2.1 Individual submissions (`02_submissions/`)

| Submission | Type | Patrick Sheng | Eason Chang |
|---|---|---|---|
| Project Scope, Research Objectives and Literature Review (2 Apr) | Individual | ✓ | |
| Mid-Year Technical Report (24 Jul) | Individual | ✓ | |
| Conference Presentation slides (25 Jul) | Joint | ✓ (shared copy) | |
| Display Day Poster, `Poster_68.pdf` (9 Oct) | Joint | ✓ (shared copy) | |
| Final Research Report (18 Oct) | Individual | `P4P Final Report - Patrick Sheng.pdf` | `P4P Final Report - Eason Chang.pdf` |

## 3. Source code (`04_code/P4P-Besu/`)

| Folder | Contents |
|---|---|
| `network/` | IBFT 2.0 genesis configuration (`ibftConfigFile.json`) and `start-nodes.sh` for the original 4-validator network |
| `voting-contract/` | `src/VotingSystem.sol`, Foundry tests (`test/VotingSystem.t.sol`), deployment script (`script/Deploy.s.sol`), manual `cast` scripts (`test-scripts/`) |
| `frontend/` | Next.js voter and administrator web app used to demonstrate the voter's view |
| `perf-testing/network/` | `generate-network.mjs` builds an N-validator network; `node-ctl.sh`, `start-native.sh`, `stop-native.sh` run it |
| `perf-testing/caliper/` | Hyperledger Caliper 0.7.1 workspace: custom per-voter connector, workloads, benchmark configs, voter seeding |
| `perf-testing/loadgen/` | `p4p-gen.js`, the fixed-rate load generator used in rounds 2 and 3, and `verify.js` (full-roll tally check) |
| `perf-testing/fault-injection/` | Crash-fault scripts (within and over tolerance) and the three voter attacks (double vote, equivocation, replay) |
| `perf-testing/monitoring/` | Resource sampling, watchdog, percentile and block-time analysis, tally audit, storage extrapolation |
| `perf-testing/scripts/` | One launcher per test campaign (see Section 5) |
| `perf-testing/ibft-fuzzing/` | Design and starter patch for validator-level (wire-protocol) attacks. Not built or run |
| `perf-testing/reports/` | All raw and summarised results (see Section 4) |
| `docs/` | Test plan for the additional infrastructure tests (T0 to T4) |

## 4. Test data (`04_code/P4P-Besu/perf-testing/reports/`)

Start with `perf-testing/reports/README.md`, which indexes every campaign and its headline result.
Each campaign folder holds a results write-up (`*-RESULTS.md`), an index log listing every launch and
its outcome (including aborted and crashed runs, with the labelled cause), and one folder per run.

| Folder | Campaign | Write-up | Used in |
|---|---|---|---|
| `scalability-results/` | Area 1, round 1 capacity ladder; round 3 latency ladder (`round3/`) and agreement time (`round3-agreement/`) | `AREA1-RESULTS.md` | Sheng |
| `crash-fault-results/` | Area 2, round 1 crash faults; round 3 f-offline tests (`*-20261017-*`) | `AREA2-RESULTS.md` | Sheng |
| `malicious-results/` | Area 3 voter attacks, rounds 1 and 3 | `AREA3-RESULTS.md` | Sheng |
| `throughput-results/` | Area 4 load, spike and stress (scaled to n = 4) | `AREA4-RESULTS.md` | Sheng |
| `r2-scalability/` | Round 2 validator ladder and idle CPU, n = 4 to 16 | `R2-AREA1-RESULTS.md` | Sheng |
| `r2-soak/` | Round 2 election-scale chain: seeding 3.3M voters, 1M-vote soak, attacks, faults, full verification | `R2-ELECTION-SCALE-RESULTS.md` | Sheng |
| `additional/` | T0 environment, T1 tally audit, T2 transaction-pool eviction, T3 storage growth | `ADDITIONAL-RESULTS.md` | Chang |
| `round3-index.log` | Launch log for round 3 | | Sheng |

### 4.1 Files in each run folder

| File | Meaning |
|---|---|
| `run.log` / `sweep.log` | Full console log of the run, including the memory budget given to each validator |
| `run-meta.txt` | Git commit and settings the run used |
| `env.txt` | Machine record at the time of the run (CPU, memory, kernel, Java, Besu) |
| `summary.csv` | One row per load step: sent and confirmed rate, p50/p95/p99 latency, failures |
| `timeline*.csv` | Per-interval sent, confirmed and latency over the run |
| `resources.csv`, `samples.csv`, `peak-mem.txt` | CPU and memory per validator over time, and the peak |
| `fault-events.csv`, `fault-script.log` | When each validator was stopped and restarted, and catch-up times |
| `watchdog.log`, `ABORT_REASON` | Resource watchdog output and, for stopped runs, the labelled cause |
| `audit.csv` / `audit.json` | T1 tally audit: per-validator tally, recount and block hash |
| `storage.csv`, `storage-summary.*` | T3 data-directory size at each phase |
| `NOTE.txt` | Hand-written note on why a run was superseded |

### 4.2 Data not included, and why

Some raw output was left out of the repository because it is very large or contains private keys:

| Left out | Reason | How to regenerate |
|---|---|---|
| Per-transaction latency files (`latency/`, `txlog/`) and round 2 per-vote CSVs | About 23 MB per 200,000 votes. Every figure uses the summaries that are kept (`summary.csv`, `*.summary.json`, `checkpoints.csv`, `steps.csv`) | Rerun the campaign; the runner writes them again |
| Validator logs (`validator*.log`) and Caliper HTML reports | Size | Rerun the campaign |
| Generated networks (`network/generated/`), Caliper network configs, voter pools, round 2 chain snapshot | Contain validator, administrator and voter private keys | `generate-network.mjs`, `deploy-and-configure.js`, `seed/generate-voters.js`, `run-r2.sh seed` |

## 5. Reproducing the work

All tests ran on one Ubuntu 24.04 virtual machine. The exact specification is in
`06_environment/ENVIRONMENT.md`. Results are bound to that machine: absolute throughput will differ
on other hardware, but the procedures are the same.

### 5.1 Prerequisites

- Ubuntu 24.04, OpenJDK 21, Hyperledger Besu 24.12.0 on the `PATH`
- Foundry (`forge`, `cast`)
- Node.js 22 (Caliper 0.7.1 requires it; `perf-testing/caliper/.nvmrc` pins it) and `npm`
- `jq`, `curl`, and systemd with cgroup v2 (the runners start each validator as a memory-capped
  `systemd --user` unit)
- At least 8 GB RAM for round 1 and about 16 GB for rounds 2 and 3

### 5.2 Build and deploy

```bash
cd voting-contract && forge install && forge build && forge test -vv   # 10 tests should pass
cd ../perf-testing/caliper && npm install
cd ../fault-injection && npm install
```

The basic 4-validator network and manual deployment are described in the repository's root
`README.md`. The test runners below generate their own networks, so this step is only needed to
try the contract by hand or run the frontend.

### 5.3 Test campaigns

Every launcher runs detached as a systemd user unit, so a crashed validator cannot take down the
terminal or editor, and writes one folder per run into `perf-testing/reports/`. Follow progress
with `tail -f` on the campaign's index log.

| Campaign | Command (from `perf-testing/`) | Output |
|---|---|---|
| Round 1, Area 1 capacity ladder | `bash scripts/run-area1.sh 4 7 10` | `reports/scalability-results/` |
| Round 1, Area 2 crash faults | `bash scripts/run-area2.sh 4 7 10` | `reports/crash-fault-results/` |
| Round 1, Area 3 voter attacks | `bash scripts/run-area3.sh 4 7 10` | `reports/malicious-results/` |
| Round 1, Area 4 load, spike, stress | `bash scripts/run-area4.sh 4` | `reports/throughput-results/` |
| Additional T0 to T3 | `bash scripts/record-env.sh`, then `bash scripts/run-additional.sh T1 S1` (and `T1 S2`, `T2 V0`, `T2 V1`, `T2 V3`, `T3`) | `reports/additional/` |
| Round 2 validator ladder | `bash scripts/run-r2-area1.sh 4 7 10 13 16` | `reports/r2-scalability/` |
| Round 2 election-scale | `bash scripts/run-r2.sh smoke seed calibrate soak double area2 verify` | `reports/r2-soak/` |
| Round 3 validator-count gaps | `bash scripts/run-r3.sh` | `reports/round3-index.log` and the Area 1 to 3 folders |

Tunable settings (rates, durations, heap sizes, pool size) are environment variables documented in the
header of each script. `perf-testing/README.md` explains the harness design, including why a custom
Caliper connector and a custom load generator were needed.

### 5.4 Verification procedures

The project measures software behaviour, so there is no instrument calibration. These are the
checks that played the same role:

| Check | How | Where |
|---|---|---|
| Contract correctness | 10 Foundry unit tests: registration, admin-only access, voting window, double votes, unregistered voters, invalid candidates, tallying | `voting-contract/test/VotingSystem.t.sol` |
| Host speed before each run | CPU probe; runs wait until the host is healthy (probe ≤ 1.5 s) | `scripts/run-r3.sh`, `round3-index.log` |
| Environment record | `record-env.sh` captures CPU, memory, kernel, Java, Besu and pool settings | `reports/additional/env.txt`, per-run `env.txt` |
| Run validity | Watchdog stops and labels any run where a validator crashes, stalls or runs out of memory; labelled runs are excluded from results but kept in the index logs | `monitoring/resource-watchdog.sh`, `*-index.log` |
| State agreement | After every fault and attack test, every validator's latest block hash and tally are compared | `fault-injection/`, `monitoring/audit-tally.js` |
| Independent recount | Tally recomputed from `VoteCast` events and compared with `getTally` on each validator | `monitoring/audit-tally.js` (T1) |
| Full-roll verification | All 3.3M voter records scanned after the 1M-vote soak; expected tally known because voter *i* votes for *i* mod 3 | `loadgen/verify.js`, `reports/r2-soak/verify-20261016-102811/` |
| Latency method | Percentiles computed from per-transaction timings, since Caliper only reports min, max and mean | `monitoring/compute-percentiles.js` |

## 6. Known issues for anyone continuing this work

- **Besu 24.12.0 lock-ups.** Validators sometimes stop importing blocks while still reporting as
  active. Thread dumps are kept in `throughput-results/n4-20261008-225553/` and
  `additional/T2-V0-*-smoke/threaddump-*.txt`. The round 3 runner reruns an affected size once.
- **Caliper receipt polling.** In Besu 24.12.0, `eth_getBlockReceipts` costs grow with the square of
  the block size, and Caliper's polling alone stalled the chain at high rates. Use `loadgen/p4p-gen.js`
  for anything above about 50 votes per second.
- **Uncommitted changes in the additional tests.** Code changes made during the T1 to T3 runs are
  recorded in `reports/additional/code-changes.diff` (see `ADDITIONAL-RESULTS.md`).
- **Single-machine limits.** Every validator shared one VM, so throughput limits belong to the test
  machine and network delay between sites is absent. See `07_future-work/FUTURE-WORK.md`.
- **Do not launch Besu or Caliper from an editor terminal on a small machine.** Out-of-memory kills
  inside the editor's cgroup took the editor down in early runs. Use the `scripts/run-*.sh` launchers.
