# Test Environment and Specifications

This project is software only, so the "equipment" is the test machine and the software stack. All
values below are taken from the environment records saved during testing
(`perf-testing/reports/additional/env.txt`, per-run `env.txt` files, and
`perf-testing/reports/r2-soak/R2-ELECTION-SCALE-RESULTS.md`, Section 2).

## 1. Hardware

All validators and the load generator ran together on one virtual machine hosted on a laptop.

### Host

| Item | Value |
|---|---|
| CPU | Intel Core Ultra 5 125H (14 cores, 18 threads) |
| RAM | 32 GB |
| OS | Windows |
| Hypervisor | Oracle VirtualBox (Guest Additions 7.2.8 r173730) |
| Other heavy processes during tests | None |

### Virtual machine

| Item | Round 1 and additional tests (T0 to T3), 8 to 14 Oct 2026 | Rounds 2 and 3, 15 to 17 Oct 2026 |
|---|---|---|
| vCPU | 4 | 6 |
| Memory | 8 GB allocated (7.7 GiB visible) | 15.6 GiB visible |
| Swap | None | None |
| Disk | 40 GB dynamically allocated virtual disk | 200 GB virtual disk |
| OS | Ubuntu 24.04.4, kernel 7.0.0-38-generic | Same |
| Init / cgroups | systemd 255, cgroup v2 with memory controller | Same |

## 2. Software

| Component | Version | Purpose |
|---|---|---|
| Hyperledger Besu | 24.12.0 (`besu/v24.12.0/linux-x86_64/openjdk-java-21`) | Blockchain client on every validator |
| OpenJDK | 21.0.12.1 | Runtime for Besu |
| Solidity | 0.8.19 (`voting-contract/foundry.toml`) | Smart contract language |
| Foundry | forge, cast, anvil | Contract build, tests and deployment |
| Hyperledger Caliper | 0.7.1 (`@hyperledger/caliper-cli`, `caliper-core`) | Load generation in round 1, additional tests and round 3 fault tests |
| Node.js | 22.23.2 | Caliper, load generator, analysis scripts |
| ethers.js | ^6.17.0 | Transaction signing in the connector, load generator and attack scripts |
| Next.js / React | 16.2.9 / 19.2.4 | Voter and administrator frontend |
| Prometheus, Grafana, node_exporter | Grafana dashboards 16455 (Besu) and 1860 (node_exporter) | Monitoring in round 2 |
| jq / curl | 1.7 / 8.5.0 | Shell tooling for the fault scripts |

## 3. Network configuration

| Parameter | Value | Source |
|---|---|---|
| Consensus | IBFT 2.0 | `network/ibftConfigFile.json` |
| Chain ID | 1337 | Same |
| Block period | 2 s (100 ms, via the test-only `xblockperiodmilliseconds`, for the round 3 agreement-time test only) | Same; `perf-testing/scripts/r3-agreement.sh` |
| Round timeout | 4 s (`requesttimeoutseconds`) | Same |
| Epoch length | 30,000 blocks | Same |
| Block gas limit | `0x1fffffffffffff` (maximum) | Same |
| Gas price | 0 | Report (Sheng), Table 3 |
| Storage format | BONSAI (`--data-storage-format=BONSAI`) | `perf-testing/network/node-ctl.sh` |
| Profile / transaction pool | `--profile=ENTERPRISE` (sequenced pool); pool size 4,096 in round 1, 65,536 in rounds 2 and 3 | `R2-ELECTION-SCALE-RESULTS.md` §2 |
| Validators tested | 4, 7, 10 (round 1); 4 to 16 (round 2); 4 to 16 (round 3) | Report (Sheng), Table 4 |

## 4. Resource limits per validator

Each validator ran as its own `systemd --user` unit with a memory cap, so one out-of-memory
validator could not affect the others. The exact cap and Java heap for each run are logged as
"Memory budget" at the top of that run's `run.log`. Typical values:

| Setting | Round 1 | Round 2 soak |
|---|---|---|
| Memory cap per validator | About 900 MB at n = 4, 520 MB at n = 7, 380 MB at n = 10 | 2.6 GB |
| Java heap | About 350 MB at n = 4 | 1 GiB |

## 5. Test conditions that affect the results

- Every validator and the load generator shared one VM, so validators competed for CPU and messages
  between them arrived with almost no network delay.
- In round 2 the laptop host repeatedly reduced the CPU available to the VM. Each run from round 2
  on checks host speed with a CPU probe before starting (see `perf-testing/reports/round3-index.log`).
- No other heavy processes ran on the host during tests.
