# Design History: Project #68

Assessing the Suitability of Blockchain Frameworks for New Zealand General Elections

Authors: Eason Chang and Patrick Sheng

## About this document

This document records the design work, experiments and decisions that shaped the project but are not described in the final reports. For each one it gives what was tried, what happened, and why the project changed direction. It is meant to help anyone continuing the work understand why the system looks the way it does, and avoid repeating dead ends.

Dates refer to supervisor meetings, which are recorded in `meeting_notes.md`. The sources read along the way are in `literature_notes.md`.

---

## 1. From optimising MACI to a private blockchain (March to April 2026)

### Starting point
The project began as a continuation of the 2025 Part IV work by Kwon and Browne, which evaluated MACI (Minimal Anti-Collusion Infrastructure) on public Ethereum networks. Their results showed two bottlenecks: slow and congested vote submission on public chains, and off-chain proof generation that would take weeks for a national election. The original project title was "Assessing the Performance and Scalability of MACI as a Standalone DLT Framework".

### First plan
The Semester One literature review proposed two optimisations:
- Move MACI from a public chain to a permissioned network using a PBFT-style consensus protocol, chosen over proof of authority because PBFT puts consistency ahead of availability.
- Replace MACI's Groth16 proofs with a faster proof system such as Halo2 or ZK-STARKs to break the sequential proving bottleneck.

### Why it changed
At the meeting of 22 April, the supervisors suggested not limiting the research to MACI and looking at other infrastructures. They also questioned MACI's "last vote counts" rule, since a voter could be pressured to change their vote at the last minute.

At the meeting of 29 April, the team started looking at replacing zero-knowledge proofs with a simpler hash-based check between nodes. This led to the key design insight: if the network is run by a set of known, trusted organisations, and every change needs agreement from a quorum of them, then no single party can alter the record, and zero-knowledge proofs are no longer needed to prove the tally was computed correctly. The project therefore moved from optimising MACI to building and evaluating a private, permissioned blockchain directly.

### Comparison of three models
Three architectures were compared before settling on this approach:
- **Centralised server:** a single operator holds the only copy of the votes. Fast and simple, but one compromised or dishonest operator could change the result without anyone being able to tell.
- **Public, permissionless blockchain (the MACI approach):** no single trusted party, but throughput and confirmation times are limited by public network congestion and gas costs, and proof generation scales poorly with the number of voters.
- **Private, permissioned blockchain (chosen):** a defined set of trusted organisations, such as the Electoral Commission and independent auditors, run the validators together. Changing the record would need a quorum of them to collude, and the network is not shared with other traffic.

### Permission model
The first design split permissions into three tiers:
- **Voters and the voting app:** can only submit a vote. They have no part in consensus.
- **Trusted organisations (validators):** take part in consensus and hold a full copy of the ledger and voter roll.
- **The network as a whole (quorum):** a change to votes or the voter roll only takes effect once enough validators agree, so no single organisation can write on its own.

The later prototype kept this idea, using Besu's validator set for the second tier and the voting contract for the voter roll.

---

## 2. The custom protocol design (May to June 2026)

Before choosing a platform, the team designed its own voting protocol in supervisor meetings. Most of it was later replaced by features Besu already provides, but the design work explains the requirements the platform had to meet.

### Vote pool and validation (13 May)
- Votes wait in a pool until they are verified.
- Nodes take votes from the pool asynchronously, so the same vote is not picked up twice.
- When a block is full it is verified twice: the node checks the hash of each transaction, and the next node checks the new block is correct.
- Each vote is hashed from the voter's identity and their choice.
- Tallying could be done in full, or block by block (for example blocks 1 to 5, then 6 to 10), and confirmed with the other nodes.

### The mempool as a voter roll (3 June)
The design changed the role of the mempool:
- The mempool would not hold votes, and would not be shared: every node keeps its own.
- Instead it would hold the registered identities (verified through RealMe) of people who have not voted yet.
- When a vote arrives, the voter's name is removed from the mempool, marking them as voted or in progress.
- If a vote arrives for a name that is not in the mempool, that person has already voted or a vote is being processed, so the new vote is rejected.

Consensus would work by each node checking that the other nodes reach the same storage hash for a vote, then forming a block every 100 votes and checking that every node reaches the same block hash. The general direction was a PBFT-style protocol, so that a broken or corrupted node could be identified by the majority.

### Open questions raised (9 to 10 June)
The custom design left several questions open:
- **Vote routing:** how a vote reaches the right node in the first place.
- **Corrupted nodes:** whether a corrupted node could ignore the majority and act on its own. Enforcing the rule with a smart contract was suggested but not confirmed.
- **Simultaneous double votes:** if the same voter's vote reaches two nodes at the same moment, one copy must be dropped. A priority order between nodes was suggested.
- **Ordering parallel consensus rounds:** whether to use a fixed index by node ID or a dynamic index across all nodes. This was deliberately left aside.
- **Broadcasting:** every node talks to every other node, which needs some form of parallel processing.

HoneyBadgerBFT, which uses threshold cryptography to tolerate faulty nodes, was noted as a reference. The plan for testing was to start with up to five nodes in local terminals, then move to cloud machines in different regions, timing each step with timestamps.

### How these were resolved
Moving to Hyperledger Besu answered most of these questions without custom code:
- **Vote routing:** a vote can be sent to any validator, which passes it to its peers over Besu's P2P network.
- **Corrupted nodes and ordering:** IBFT 2.0 orders transactions into blocks and tolerates up to a third of validators being faulty, which replaces the custom hash-checking and ordering design.
- **Double votes:** because every vote is a transaction in an ordered block, a second vote from the same voter is processed after the first and rejected by the voting contract, wherever it arrived.

---

## 3. Choosing the platform and consensus protocol (June to August 2026)

### Besu, with CometBFT as a fallback
Hyperledger Besu was the starting choice because it is an Ethereum client with a private network mode, built-in Byzantine fault-tolerant consensus, permissioning, and support for Solidity smart contracts. Using an Ethereum-compatible platform also meant the same Hyperledger Caliper benchmarking tool used in the 2025 MACI work could be reused. CometBFT was kept as a fallback in case Besu could not support the design, but it was not needed, so no formal comparison between the two was made.

The team also looked at forking Besu's consensus module to get full control over the messages sent between nodes and the timing of block creation. This was not pursued once the project moved the voting rules into a smart contract (Section 4).

### IBFT 2.0 rather than QBFT
IBFT 2.0 was chosen at the start of the project, before the team knew that Besu recommends QBFT for new enterprise networks. By the time this was found, the network configuration, scripts and tests were all built on IBFT 2.0, so switching was ruled out for time reasons. IBFT 2.0 has been formally analysed for safety and liveness, which supported keeping it. Testing QBFT is listed as future work.

### Meeting of 5 August
At the meeting of 5 August, the team listed what Besu would handle for the project: block creation, connecting to an existing private Ethereum framework instead of building a new chain, block storage, running a smart contract through the EVM to handle vote verification, and restoring the chain's history. Besu would also handle passing votes between nodes over P2P, and already includes a BFT consensus algorithm. One open question was whether a manual delay could be added between blocks.

---

## 4. The mempool mismatch and the move to a smart contract (July to August 2026)

### The problem
When the custom mempool design (Section 2) was compared with how Besu actually works, it did not fit. In Besu, the transaction pool holds pending transactions waiting to be added to a block. It cannot be repurposed as a list of registered voters, and each node's pool is not kept consistent with the others by consensus. This was recorded as the main unresolved finding at mid-year, and it blocked formal testing.

### The two options
- **Work within Besu's extension points:** hold the voter roll and the voting rules in a smart contract, so that every change to the roll is agreed by consensus and copied to every validator.
- **Modify Besu's source code:** change how the transaction pool behaves so it could act as the voter roll.

### The decision
The project took the first option. The voting contract holds the voter roll, and each registered voter moves through three states: NotVoted, Processing and Voted. A second vote from the same voter is rejected by the contract. This kept Besu unmodified, made the voter roll part of the agreed record rather than local to each node, and made the system easier to test and reproduce.

---

## 5. Network setup: from multiple machines to one (June to October 2026)

### Local multi-node network (24 June)
The first working network ran several Besu nodes on one machine, with one node acting as the bootnode that others connect to first.

### Bootnode on a VPS
To show that nodes could connect across real machines, a bootnode was set up on a Hostinger VPS with a public IP address, and peer nodes on other computers joined it. This worked, and confirmed that a validator network could be spread across different machines and networks. Problems solved along the way are recorded in the environment notes, including:
- The genesis file must be byte-for-byte identical on every node. Copying it by pasting text added a trailing newline, which caused "no sync target" errors.
- A node's enode URL must use its public IP address, not `127.0.0.1` or `0.0.0.0`, or other machines cannot reach it.
- Port 30303 must be open for both TCP and UDP. On the VPS, the hosting panel's firewall was the only active firewall, and UDP had to be opened separately.
- Nodes using different database formats (FOREST and BONSAI) cannot share a data directory; either set `--data-storage-format` explicitly or wipe and recreate the data directory, after backing up the node's key files.

### Why testing moved to one computer
Running and resetting a multi-machine network for every test was slow and hard to control, so all formal testing moved to a single virtual machine, with every validator as a separate process. This made tests repeatable, but it means network delay between sites was not measured. Testing on separate machines in different locations is listed as future work.

---

## 6. Test planned but left out of the reports

### Votes waiting in the transaction pool during an outage (T2)
This test looked at what happens to votes waiting in the validators' transaction pools when too many validators fail and blocks stop being produced. It used a four-validator network receiving 25 votes per second for 300 s; 40 s in, two validators were stopped so the network lost its quorum, then restarted after 60 s. It was run on 14 October 2026 with different pool sizes, and its data is kept in `04_code/P4P-Besu/perf-testing/reports/additional/` (`T2-summary.csv` and the `T2-*` run folders), with a write-up in `ADDITIONAL-RESULTS.md`.

Main observations:
- With Besu's default pool of 4,096 transactions, the pools filled during the outage and about 31.5% of the votes sent were lost.
- With a pool of 16,384 transactions, almost no votes were lost.
- In every full run, one validator ran out of Java heap memory about 105 s after the chain resumed, so the results had to be reconstructed from the block logs and pool samples rather than produced by the test harness.

It was dropped from the reports because it overlapped with the crash-fault tests already reported, and because the memory failures made the results harder to interpret clearly. The observation still matters for a real deployment: transaction pools need to be large enough to hold every vote that could arrive during the longest expected outage, and validators need enough memory to process the backlog once blocks resume.

---

## 7. Questions raised but not studied

These were raised by the supervisors or in design discussions, but were outside the final scope. They are carried forward in `07_future-work/FUTURE-WORK.md` where relevant.
- **Cost (22 and 29 April, 13 May):** hardware and ongoing costs of running the network, whether it could be reused for future elections or referendums, whether it would be cheaper than the current system, and a model of the number of nodes against the resources they need.
- **DAO-style attacks (29 April):** what vulnerabilities a decentralised governance structure could introduce.
- **Election sizes (29 April):** comparing performance for a national election against smaller elections.
- **Offline voting (assessor question at the Part IV conference):** whether the system could be combined with paper voting, for example by sharing the voter roll so a voter cannot vote both online and on paper.
