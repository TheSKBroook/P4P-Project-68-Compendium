# Literature Notes: Project #68

Assessing the Suitability of Blockchain Frameworks for New Zealand General Elections

Author: Eason Chang

## About these notes

These notes record the sources read during the project, grouped by topic. Each entry gives:
- Link: where to find the source
- What it covers: a one-line summary
- Key takeaway: what the project took from it, or why it was set aside

Papers are linked rather than included, because most are under copyright. The two 2025 Part IV reports by Kwon and Browne are unpublished University of Auckland reports and can be obtained from the supervisors.

### How the reading changed over the project

In Semester One the project aimed to make MACI scale for a national election, so the early reading focused on MACI, zero-knowledge proof systems and permissioned consensus (PoA and PBFT).

After the supervisors suggested not limiting the research to MACI (meeting of 22 April 2026), the project moved to a private, permissioned blockchain built on Hyperledger Besu. Under a trusted-entity permission model, zero-knowledge proofs are no longer needed, so the reading shifted towards consensus protocols, private blockchain platforms and Besu itself. The MACI and zero-knowledge sources are kept in Section 4 as background for anyone returning to MACI or adding ballot secrecy.

---

## 1. New Zealand elections and electoral standards

### Electoral Commission, "Election integrity"
- Link: https://elections.nz/democracy-in-nz/about-elections/election-integrity/
- What it covers: The safeguards in New Zealand's paper election, including scrutineers, double hand counts, published results by voting place and judge-supervised recounts.
- Key takeaway: The baseline of transparency and auditability that any online system would have to match.

### Electoral Commission, "2023 General Election: Official result statistics"
- Link: https://archive.electionresults.govt.nz/electionresults_2023/statistics/index.html
- What it covers: Official 2023 figures, including total votes cast and the split between advance and election-day votes.
- Key takeaway: The scale of a national election (about 2.9 million votes cast) and the election-day load (about 0.9 million ordinary votes on the day).

### Electoral Commission, "Official results for the 2023 General Election"
- Link: https://elections.nz/media-and-news/2023/official-results-for-the-2023-general-election/
- What it covers: How special votes are checked for eligibility before they are counted.
- Key takeaway: Eligibility checks before counting are part of ballot integrity, and suggest how paper and online votes could be cross-checked in a hybrid system.

### Electoral Commission, "Last chance to vote"
- Link: https://elections.nz/media-and-news/2023/last-chance-to-vote
- What it covers: Election-day arrangements in 2023, including more than 2,300 voting places and opening hours.
- Key takeaway: Voting places are open for ten hours, which gives a realistic election-day load of about 25 votes per second. A paper system also spreads the risk of failure across many sites.

### Electoral Commission, "2023 General Election voting statistics"
- Link: https://elections.nz/democracy-in-nz/historical-events/2023-general-election/voting-statistics/
- What it covers: Daily advance voting figures for 2023.
- Key takeaway: The vote rates used in the 2025 MACI reports match the last day of advance voting (260,219 votes on 13 October), so they understate election-day demand by a factor of nearly four.

### Electoral Act 1993, s. 167
- Link: https://www.nzlii.org/nz/legis/consol_act/ea1993103/s167.html
- What it covers: The legal requirement for the issuing officer to mark the roll when an elector is issued a ballot.
- Key takeaway: The legal basis for "one person, one vote" in the paper system. The voting contract does the same job by marking each voter as Voted.

### Electoral Commission, "Enrolment by general electorate"
- Link: https://elections.nz/stats-and-research/enrolment-statistics/enrolment-by-general-electorate
- What it covers: Current enrolment figures (3,677,600 enrolled as at 30 September 2026).
- Key takeaway: A national voter population of about 3.7 million, used for the worst-case load (about 100 votes per second if everyone voted in one ten-hour day) and for storage estimates.

### M. Loncke and J. Dumortier, "Online voting: A legal perspective" (2004)
- Link: https://doi.org/10.1080/13600860410001674742
- What it covers: Legal principles for online voting.
- Key takeaway: The ballot integrity principle of one person, one vote.

### U.S. Election Assistance Commission, "Voluntary Voting System Guidelines 2.0" (2021)
- Link: https://www.eac.gov/sites/default/files/TestingCertification/Voluntary_Voting_System_Guidelines_Version_2_0.pdf
- What it covers: US certification principles for voting systems.
- Key takeaway: The main source for evaluation criteria such as transparency, auditability and ballot secrecy. Its limitation is that it was written for in-person equipment and does not allow networked devices in a certified system.

### J. Molineaux, "A working paper on online voting (internet voting, eVoting) in New Zealand" (2018)
- Link: https://thepolicyobservatory.aut.ac.nz/__data/assets/pdf_file/0006/233088/A-working-paper-on-internet-voting-in-New-Zealand-December-2018.pdf
- What it covers: New Zealand's history with online voting, including the cancelled 2016 local body trial.
- Key takeaway: The 2016 trial was cancelled over time, cost and security concerns. The underlying problem is trust in whoever runs the servers.

### Manatū Taonga, Ministry for Culture and Heritage, "Early elections" (2014)
- Link: https://nzhistory.govt.nz/politics/election-day/early-elections
- What it covers: New Zealand's first elections from 1853, when voting was not secret.
- Key takeaway: Historical background only. The project works from the current electoral system.

---

## 2. Online voting in practice and its risks

### State Electoral Office of Estonia, "Voter turnout at Riigikogu elections was 63.7%" (2023)
- Link: https://www.valimised.ee/en/voter-turnout-riigikogu-elections-was-637
- What it covers: Official 2023 Estonian election figures (312,181 of 613,801 votes cast online).
- Key takeaway: Estonia is the most established national internet voting system, with just over half of votes cast online in 2023.

### State Electoral Office of Estonia, "Statistics"
- Link: https://www.valimised.ee/en/archive/statistics
- What it covers: Historical Estonian internet voting statistics.
- Key takeaway: Internet voting has been offered in Estonia since 2005.

### P. Ehin, M. Solvak, J. Willemson, and P. Vinkel, "Internet voting in Estonia 2005–2019: Evidence from eleven elections" (2022)
- Link: https://doi.org/10.1016/j.giq.2022.101718
- What it covers: A study of internet voting across eleven Estonian elections.
- Key takeaway: Internet voting was widely used and trusted, but did not raise turnout where voting was already easy. This tempers the accessibility argument for online voting.

### D. Springall et al., "Security analysis of the Estonian Internet voting system" (2014)
- Link: https://doi.org/10.1145/2660267.2660315
- What it covers: A security review of the Estonian system, with attacks demonstrated on a reproduction of its servers and voters' computers.
- Key takeaway: A centralised online system concentrates risk on its servers and on voters' devices. Estonia is also a useful example of a conventional centralised design to compare against.

### S. Park, M. Specter, N. Narula, and R. L. Rivest, "Going from bad to worse: From Internet voting to blockchain voting" (2021)
- Link: https://doi.org/10.1093/cybsec/tyaa025
- What it covers: Argues that internet voting makes large, undetectable failures more likely, and that blockchains do not fix this.
- Key takeaway: The main critical counterpoint to blockchain voting. A private blockchain can share trust in the record among several organisations, but it is not a full solution to online voting.

### D. Jefferson, A. D. Rubin, B. Simons, and D. Wagner, "Analyzing internet voting security" (2004)
- Link: Commun. ACM, vol. 47, no. 10, pp. 59–64
- What it covers: Security analysis of the US SERVE internet voting proposal.
- Key takeaway: Denial-of-service attacks can block many voters at once and can target particular groups.

### C. Culnane, M. Eldridge, A. Essex, and V. Teague, "Trust implications of DDoS protection in online elections" (2017)
- Link: https://doi.org/10.1007/978-3-319-68687-5_8
- What it covers: The 2017 Western Australian election's use of a third-party DDoS protection service and what that means for trust.
- Key takeaway: Availability risk is larger for an online system than for paper.

---

## 3. Previous project

### C. Kwon, "Evaluating the scalability and suitability of MACI as an online solution for New Zealand's general election" (2025)
- Link: Unpublished Part IV report, University of Auckland (available from the supervisors)
- What it covers: On-chain benchmarks of MACI vote submission on Ethereum Sepolia, Optimism Sepolia and Gnosis Chiado using Hyperledger Caliper.
- Key takeaway: The starting point for this project. Public layer 1 chains could not handle national volumes, layer 2 networks remained exposed to congestion and fluctuating gas costs, and spam transactions could degrade throughput. These findings motivated looking at a private network.

### J. Browne, "Evaluating the scalability and suitability of MACI as an online solution for New Zealand's general election" (2025)
- Link: Unpublished Part IV report, University of Auckland (available from the supervisors)
- What it covers: The off-chain cost of MACI's proof generation and tallying, including an 11x speed-up from parallel proving.
- Key takeaway: Evaluation criteria adapted from VVSG 2.0 and Loncke and Dumortier, a target of results within one day, and MACI tally times of about 2.86 weeks for 5 million votes (about 1.27 weeks with the speed-up). These figures are the benchmark a new approach would need to beat.

---

## 4. MACI and zero-knowledge proofs

Read in Semester One, when the project aimed to optimise MACI. Set aside once the project moved to a permissioned network, where zero-knowledge proofs are not needed.

### V. Buterin, "Minimal anti-collusion infrastructure" (2019)
- Link: https://ethresear.ch/t/minimal-anti-collusion-infrastructure/5413
- What it covers: The original MACI proposal.
- Key takeaway: MACI uses a trusted coordinator and zero-knowledge proofs to prevent bribery and coercion on a public blockchain.

### K. Charbonnet, "A technical introduction to MACI 1.0" (2022)
- Link: https://medium.com/privacy-scaling-explorations/a-technical-introduction-to-maci-1-0-db95c3a9439a
- What it covers: How MACI's coordinator, encrypted messages, key changes and off-chain tally work.
- Key takeaway: Voters can change their key to override a coerced vote, and only the last valid message counts. The supervisors later questioned whether "last vote counts" is safe, since people could be pressured at the last minute.

### Privacy & Scaling Explorations, "Minimal Anti-Collusion Infrastructure (MACI)" documentation
- Link: https://maci.pse.dev/
- What it covers: Official MACI documentation.
- Key takeaway: Reference for how MACI is deployed and run.

### J. Groth, "On the size of pairing-based non-interactive arguments" (2016)
- What it covers: Groth16, the proof system used by MACI.
- Key takeaway: Small proofs and fast verification, but a trusted setup for each circuit and proving that scales linearly, which causes MACI's sequential bottleneck.

### A. Gabizon, Z. J. Williamson, and O. Ciobotaru, "PLONK: Permutations over Lagrange-bases for oecumenical noninteractive arguments of knowledge" (2019)
- Link: https://eprint.iacr.org/2019/953
- What it covers: A proof system with a universal, updatable trusted setup.
- Key takeaway: More flexible setup than Groth16, at the cost of larger proofs.

### S. Bowe, J. Grigg, and D. Hopwood, "Recursive proof composition without a trusted setup" (2019)
- Link: https://eprint.iacr.org/2019/1021
- What it covers: Halo, which removes the trusted setup and supports recursive proofs.
- Key takeaway: Recursive proofs could aggregate many voting operations, a possible way to break MACI's sequential bottleneck.

### E. Ben-Sasson, I. Bentov, Y. Horesh, and M. Riabzev, "Scalable, transparent, and post-quantum secure computational integrity" (2018)
- Link: https://eprint.iacr.org/2018/046
- What it covers: ZK-STARKs, which use hash functions instead of elliptic curves and need no trusted setup.
- Key takeaway: Proving time scales quasi-linearly, but proofs are large. Large proofs matter less on a private network with no gas fees.

---

## 5. Blockchain foundations

### S. Nakamoto, "Bitcoin: A peer-to-peer electronic cash system" (2008)
- Link: https://bitcoin.org/bitcoin.pdf
- What it covers: The original blockchain design.
- Key takeaway: What a blockchain is, and why changing an old block breaks the hash chain.

### V. Buterin, "Ethereum: A next-generation smart contract and decentralized application platform" (2014)
- Link: https://ethereum.org/en/whitepaper/
- What it covers: The Ethereum white paper.
- Key takeaway: A smart contract is code that every node executes in the same way, so all nodes reach the same result.

---

## 6. Consensus and Byzantine fault tolerance

### M. Castro and B. Liskov, "Practical Byzantine fault tolerance" (1999)
- Link: Proc. 3rd Symp. Operating Syst. Design Implementation (OSDI), pp. 173–186
- What it covers: The PBFT protocol.
- Key takeaway: The 3f + 1 rule, the 2f + 1 quorum, and why message traffic grows with the square of the number of nodes.

### G. Wood, "Proof-of-Authority: Ethereum consensus" (2015)
- What it covers: Proof of authority, where known validators take turns sealing blocks.
- Key takeaway: Fast and cheap for private networks, but each block is proposed by a single leader.

### S. De Angelis et al., "PBFT vs Proof-of-Authority: Applying the CAP theorem to permissioned blockchain" (2018)
- What it covers: Compares PoA and PBFT using the CAP theorem.
- Key takeaway: PoA favours availability and can fork temporarily, while PBFT guarantees consistency. For an election, consistency matters more, which pointed the project towards a PBFT-style protocol.

### Y. Zhang, X. Wang, and J. Li, "BW-PBFT: Practical Byzantine fault tolerance consensus algorithm based on credit bidirectionally waning" (2023)
- What it covers: The scaling cost of PBFT's all-to-all messaging and a proposed variant.
- Key takeaway: PBFT slows down as validators are added, so the number of validators is a trade-off between fault tolerance and speed.

### R. Saltini and D. Hyland-Wood, "IBFT 2.0: A safe and live variation of the IBFT blockchain consensus protocol for eventually synchronous networks" (2019)
- Link: https://arxiv.org/abs/1909.10194
- What it covers: The design and proof of IBFT 2.0, which fixes flaws in the original Istanbul BFT.
- Key takeaway: IBFT 2.0 is formally proven safe and live, and gives immediate finality, so one confirmation is enough.

### Hyperledger Besu, "IBFT 2.0" documentation
- Link: https://docs.besu-eth.org/private-networks/how-to/configure/consensus/ibft
- What it covers: How to configure IBFT 2.0 in Besu.
- Key takeaway: Four validators is the minimum. The chain stops if more than a third of validators fail, rather than risk inconsistent records. Validators are added or removed by vote, and the round-change timeout should be twice the block period.

### Hyperledger Besu, "QBFT" documentation
- Link: https://docs.besu-eth.org/private-networks/how-to/configure/consensus/qbft
- What it covers: Besu's recommended enterprise consensus protocol, which builds on IBFT 2.0.
- Key takeaway: QBFT is Besu's recommended choice for new networks. The project had already been built on IBFT 2.0 by the time this was found.

### Hyperledger Besu, "Consensus protocols" documentation
- Link: https://besu.hyperledger.org/private-networks/how-to/configure/consensus
- What it covers: An overview of the consensus protocols Besu supports (IBFT 2.0, QBFT, Clique).
- Key takeaway: Starting point when choosing a consensus protocol.

### Hyperledger Besu, "Proof of authority consensus" documentation
- Link: https://besu.hyperledger.org/private-networks/concepts/poa
- What it covers: Besu's proof of authority protocols for private networks.
- Key takeaway: Private networks are faster because identified validators agree by exchanging signed messages instead of costly computation. Adding validators slows block production.

---

## 7. Blockchain platforms and performance studies

### E. Androulaki et al., "Hyperledger Fabric: A distributed operating system for permissioned blockchains" (2018)
- Link: https://doi.org/10.1145/3190508.3190538
- What it covers: The design of Hyperledger Fabric.
- Key takeaway: Fabric is the main alternative permissioned platform to an Ethereum-based network such as Besu.

### S. Pongnumkul, C. Siripanpornchana, and S. Thajchayapong, "Performance analysis of private blockchain platforms in varying workloads" (2017)
- Link: https://doi.org/10.1109/ICCCN.2017.8038517
- What it covers: A benchmark of Fabric against a private Ethereum network.
- Key takeaway: Fabric performed better in execution time, latency and throughput on the workloads tested, but none of the workloads resembled an election.

### L. Mostarda, A. Pinna, D. Sestili, and R. Tonelli, "Performance analysis of a Besu permissioned blockchain" (2023)
- Link: https://doi.org/10.1007/978-3-031-28694-0_26
- What it covers: Caliper benchmarks of a Besu IBFT 2.0 network run by several organisations at different sites.
- Key takeaway: The closest existing study to this project's setup. Also gives Caliper's definition of transaction latency.

### R.-V. Tkachuk, D. Ilie, R. Robert, V. Kebande, and K. Tutschku, "On the performance and scalability of consensus mechanisms in privacy-enabled decentralized renewable energy marketplace" (2024)
- Link: https://doi.org/10.1007/s12243-023-00973-8
- What it covers: Besu scalability as validators increase from 4 to 24.
- Key takeaway: Maximum throughput fell by about 42% as validators grew, but the workload was energy trading rather than an election. Few studies test Besu under election conditions.

---

## 8. Hyperledger Besu implementation references

Documentation pages, specifications and release notes used to build and configure the prototype. These are the first place to look when rebuilding the network.

### Hyperledger Besu, "Welcome" documentation
- Link: https://docs.besu-eth.org/
- Key takeaway: Besu is an open-source Ethereum client for both public and private networks.

### Hyperledger Besu, "Create a private network using IBFT 2.0"
- Link: https://docs.besu-eth.org/private-networks/tutorials/ibft
- Key takeaway: The starting configuration for the network: 2 s block period and 4 s round-change timeout.

### Hyperledger Besu, "enterprise-private.toml" (Besu 24.12.0 source)
- Link: https://github.com/hyperledger/besu/blob/24.12.0/config/src/main/resources/profiles/enterprise-private.toml
- Key takeaway: The enterprise profile's defaults: full sync, sequenced transaction pool and a minimum gas price of zero.

### Hyperledger Besu, "Permissioning" documentation
- Link: https://docs.besu-eth.org/private-networks/concepts/permissioning
- Key takeaway: Permissioning works in layers: which nodes may connect, which may validate, and which accounts may send transactions.

### Hyperledger Besu, "Node keys" documentation
- Link: https://docs.besu-eth.org/public-networks/concepts/node-keys
- Key takeaway: A node's key pair forms its enode URL and its validator address.

### Ethereum Foundation, "Node Discovery Protocol v4"
- Link: https://github.com/ethereum/devp2p/blob/master/discv4.md
- Key takeaway: Nodes find each other through bootnodes over UDP, so UDP port 30303 must be open as well as TCP.

### Ethereum Foundation, "The RLPx transport protocol"
- Link: https://github.com/ethereum/devp2p/blob/master/rlpx.md
- Key takeaway: Peer connections are encrypted, and one link carries transactions, blocks and consensus messages together.

### Hyperledger Besu, "Transaction pool" documentation
- Link: https://docs.besu-eth.org/public-networks/concepts/transactions/pool
- Key takeaway: How transactions are checked, held and passed on. The sequenced pool evicts the newest transactions when it is full.

### Hyperledger Besu, "Data storage formats" documentation
- Link: https://docs.besu-eth.org/public-networks/concepts/data-storage-formats
- Key takeaway: Bonsai and Forest store the world state differently. Forest keeps every past version of the state, so it grows with every block.

### Hyperledger Besu, "Release 24.10.0"
- Link: https://github.com/besu-eth/besu/releases/tag/24.10.0
- Key takeaway: The empty block period was an early-access, QBFT-only feature in the Besu version used.

### "QBFT no empty block," Issue #3810, besu-eth/besu
- Link: https://github.com/besu-eth/besu/issues/3810
- Key takeaway: Users reported that the empty block period did not work reliably, so the network kept producing empty blocks every 2 s.

### Hyperledger Besu, "Release 26.5.0"
- Link: https://github.com/besu-eth/besu/releases/tag/26.5.0
- Key takeaway: The empty block period became a standard option for IBFT 2.0 and QBFT, so a newer Besu should remove most of the empty block storage overhead.

---

## 9. Security extensions

### R. Gennaro and S. Goldfeder, "Fast multiparty threshold ECDSA with fast trustless setup" (2018)
- Link: https://doi.org/10.1145/3243734.3243859
- What it covers: Threshold signing, where several parties each hold a share of a key.
- Key takeaway: A possible fix for a single administrator key: split it so that no one organisation can register voters alone.
