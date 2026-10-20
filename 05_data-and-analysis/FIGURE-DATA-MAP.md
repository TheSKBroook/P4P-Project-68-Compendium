# Figure and Table to Data Map

Every figure and table in the two final reports that presents measured results, with the data it
was drawn from. Paths are relative to `04_code/P4P-Besu/perf-testing/reports/`. The scripts or
spreadsheets that draw each chart are in `../plots/`.

Figures that are diagrams rather than data (Sheng Figs 1 to 3; Chang Figs 1 to 6) have their
sources in `03_design/`.

## P. Sheng, *Evaluating the Suitability of Blockchain Frameworks for New Zealand's General Election*

| Item | Content | Data | Summary / write-up | Plot |
|---|---|---|---|---|
| Table 2 | Fault tolerance, quorum and messages per block by network size | Calculated from n = 3f + 1 and IBFT 2.0 message counts (no measured data) | Report Section 2.7 | |
| Table 3 | Main network parameters | `../../network/ibftConfigFile.json`, `../network/generate-network.mjs` | `06_environment/ENVIRONMENT.md` | |
| Table 4 | Test environment per round | `additional/env.txt`, per-run `env.txt` | `06_environment/ENVIRONMENT.md`, `r2-soak/R2-ELECTION-SCALE-RESULTS.md` §2 | |
| Fig 4(a), 4(b) | Round 1 confirmed throughput and latency vs target rate, n = 4, 7, 10 | `scalability-results/n4-20261008-032842/summary.csv`, `n7-20261008-034602/summary.csv`, `n10-20261008-035937/summary.csv` | `scalability-results/AREA1-RESULTS.md`, "Round 1 results" | `<plot file>` |
| Fig 5 | Spike and stress tests over time, n = 4 | Spike: `throughput-results/n4-20261008-232149/timeline-spike.csv`, `spike-phases.csv`. Stress: `throughput-results/n4-20261008-233320/timeline-stress.csv`, `stress-steps.csv` | `throughput-results/AREA4-RESULTS.md` | `<plot file>` |
| Fig 6(a) | Agreement time per block, n = 4 to 16 (round 3) | `scalability-results/round3-agreement/agreement-recomputed.csv` (recomputed from validator log timestamps by `../scripts/r3-agreement-recompute.py`); raw runs in `round3-agreement/n*-r0-*`, `n*-r10-*` | `AREA1-RESULTS.md`, "Round 3, Test 2" | `<plot file>` |
| Fig 6(b) | Idle CPU cores in use, n = 4 to 16 (round 2) | `r2-scalability/n{4,7,10,13,16}-20261015-*/samples.csv`, `steps.csv` | `r2-scalability/R2-AREA1-RESULTS.md` | `<plot file>` |
| Fig 7 | Longest block gap with f validators offline, n = 4 to 13 (round 3) | `crash-fault-results/n4-within-20261017-072257/`, `n7-within-20261017-072910/`, `n10-within-20261017-073543/`, `n13-within-20261017-074731/` (`fault-events.csv`, `timeline.csv`) | `crash-fault-results/AREA2-RESULTS.md`, "Round 3 results" | `<plot file>` |
| Table 5 | Over-tolerance results, round 1 vs round 2, n = 4 | Round 1: `crash-fault-results/n4-over-20261008-042837/`. Round 2: `r2-soak/area2-20261016-065505/a2-quorum-result.csv`, `a2-quorum.csv.summary.json` | `AREA2-RESULTS.md`; `R2-ELECTION-SCALE-RESULTS.md` §8 | |
| Table 6 | Measured results per network size | `scalability-results/round3/`, `round3-agreement/agreement-recomputed.csv`, `crash-fault-results/*-20261017-*`, `malicious-results/` | `AREA1`, `AREA2`, `AREA3-RESULTS.md`, Round 3 sections; `round3-index.log` | |
| Table 7 | Comparison with the 2025 MACI evaluation | This project's figures from the rows above; MACI figures from the 2025 Kwon and Browne reports | Report Section 6 | |
| Text, Section 5 | 1M-vote soak on 3.3M-voter chain, full-roll verification, 1,000 mass double votes | `r2-soak/soak-*/checkpoints.csv`, `*.summary.json`; `r2-soak/verify-20261016-102811/verify.json`; `r2-soak/double-20261016-065424/` | `R2-ELECTION-SCALE-RESULTS.md` §6, §7, §9 | |

## E. Chang, *Assessing the Suitability of Blockchain Frameworks for New Zealand General Elections*

| Item | Content | Data | Summary / write-up | Plot |
|---|---|---|---|---|
| Section 4.1 | Test environment | `additional/env.txt` | `ADDITIONAL-RESULTS.md`, "T0" | |
| Section 5.1, Fig 7(a) | Recount time per validator, 10,000 votes, with and without a crash | `additional/T1-S1-n4-20261014-16*-run{1,2,3}/audit.csv`, `additional/T1-S2-n4-20261014-17*-run{1,2,3}/audit.csv`; combined in `additional/T1-audit-all.csv` | `ADDITIONAL-RESULTS.md`, "T1" | `plots/Chang_Fig7_recount-time.png` |
| Fig 7(b) | Recount time scaled to 3.7M and 5M votes | Derived from Fig 7(a) data by linear scaling | `ADDITIONAL-RESULTS.md`, "T1" | `plots/Chang_Fig7_recount-time.png` |
| Section 5.1, crash scenario | Validator 4 catch-up time and block count during the 60 s outage | `additional/T1-S2-*/fault-events.csv`, `fault-script.log` | `ADDITIONAL-RESULTS.md`, "T1" | |
| Fig 8 | Growth of one validator's data directory over the storage test | `additional/T3-n4-20261014-173048-run1/storage.csv` | `ADDITIONAL-RESULTS.md`, "T3" | `plots/Chang_Fig8_storage-growth.png` |
| Fig 9(a), 9(b) | Storage by record type, measured (10,000 voters) and estimated (3.7M voters, 21 days) | `additional/T3-n4-20261014-173048-run1/storage-summary.csv`, `storage-summary.json`, produced by `../monitoring/storage-extrapolate.js` | `ADDITIONAL-RESULTS.md`, "T3" | `plots/Chang_Fig9_storage-by-record-type.png` |
| Appendix A | Example block and receipt for one vote | `<raw JSON-RPC output, to be added>` | Report Appendix A | |
| Table 1 | Suitability against the criteria of Section 2.1 | Summary of the results above and the companion report | Report Section 6 | |
