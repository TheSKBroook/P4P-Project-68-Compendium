# Future Work

Suggestions for anyone continuing this project, drawn from Section 7 of both final reports and from
the unfinished items recorded in the test write-ups.

## 1. Test on realistic infrastructure

- **One machine per validator, at separate sites.** Every result here comes from one shared VM, so
  throughput limits belong to the test machine and network delay between sites is absent. Running each
  validator on its own machine would show how much latency agreement really adds, and whether 10 to 13
  validators (the size recommended in the Sheng report) can sustain 100 votes per second.
- **The full 5M-vote soak.** Round 2 seeded 3.3M voters and cast 1M votes; the plan was 5.5M voters
  and 5M votes. The harness supports this (`scripts/run-r2.sh`), given a host that does not throttle.
- **The original 300 to 500 votes per second target and the full-size Area 4 tests** (n = 7, 0.1 to 4.3M
  voters, 4-hour endurance), configured in `perf-testing/caliper/benchmarks/throughput/`.
- **A realistic workload** including failed and repeated votes, which are stored in blocks but emit
  no `VoteCast` event, so their storage cost was not measured (Chang report, Section 4.5).

## 2. Attacks by dishonest validators

Only attacks by voters were tested. Attacks by a validator, such as sending false or conflicting
consensus messages, were designed but not built. `perf-testing/ibft-fuzzing/` holds a design checked
against the Besu 24.12.0 source and two starter patch files for a modified Besu build.

## 3. Newer Besu version

Besu 24.12.0 caused two problems: validators that stopped importing blocks while still reporting as
active, and `eth_getBlockReceipts` costs that grow with the square of the block size. Thread dumps are
kept in the reports. A newer release should be tested, and one that supports an empty-block period
would also reduce idle storage and CPU (Chang report, Section 7).

## 4. Ballot secrecy

The prototype stores every vote openly with the voter's address. Before any real use, votes must be
stored in a form that hides each choice but still allows an independent recount, for example
encrypted under a key shared by several organisations, and the cost of doing so measured. Encrypting
vote payloads (for example with ECIES) and unlinking voter identity with one-time keys were considered
during the project but not implemented.

## 5. Trust in the administrator and voter identity

- Split the administrator key between several organisations instead of one account.
- Link registration to a verified identity (for example RealMe) so each person receives exactly one
  voting address.

## 6. Public verification

- Publish the contract source and give independent observers the full chain to recount once voting
  closes.
- During voting, share only each block's hash so observers can later confirm no block changed
  without seeing any votes early.
- Trial the system in smaller elections first.

## 7. Smaller items

- `perf-testing/network/generate-network.mjs` can write Docker Compose files, but the Docker path was
  never run; all tests used native systemd units.
- `--bonsai-limit-trie-logs-enabled=false` would keep full historical state for audits; its storage
  cost was not measured.
- The Next.js frontend is a demonstration of the voter's view, not a hardened client.
