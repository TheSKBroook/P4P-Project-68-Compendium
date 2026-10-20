# Meeting Notes: Project #68

Assessing the Suitability of Blockchain Frameworks for New Zealand General Elections

- Students: Eason, Patrick Sheng
- Supervisor: Dr Dev Singh
- Co-supervisor: Prof Kevin Sowerby
- Regular meeting: Wednesdays, 11:15 am
- Attendees: all four unless noted otherwise in an entry

## About these notes

These notes were compiled from the team's Discord channel, where notes were posted before or after each meeting. Entries are in date order and grouped by the University of Auckland 2026 semester calendar. Each entry is labelled with its type:

- Meeting summary: notes taken during or straight after a meeting
- Presentation run-through: the team presented to the supervisors with no further feedback, so no minutes were taken
- Progress check: the meeting was a progress update with no new feedback or action items, so no minutes were taken
- No meeting: no meeting was held that week

Notes are kept as originally written, with spelling corrected.

---

# Semester One

## Week 1 (Wed 4 March 2026)
Type: Meeting summary

- First meeting with Dev and Kevin, where we arranged the regular weekly meeting
- Dev and Kevin suggested that we meet Chris, who worked on the previous project, and get a copy of the previous project report

## Weeks 2 and 3 (Wed 11 and 18 March 2026)
Type: Progress check (no minutes recorded)

Progress updates on the literature review, covering:
- New Zealand's voting and electoral standards
- Existing examples of online voting
- Chris and Joshua's previous project report and its findings
- Foundations of blockchain technology
- Potential solutions

## Week 4 (Wed 25 March 2026)
Type: Meeting summary

Progress update on the literature review, then planned the work for the following week:

Assignment:
- Complete draft literature review (due 2 April)
  - Work on the general overview of the research (i.e. how can we get MACI to work as a solution for an NZ online voting system)

Objectives:
- Research on voting systems for NZ and other countries
- Research on private blockchain
  - What is needed: Ethereum? Consensus layer?
  - What has been done already on MACI using a public blockchain in an NZ online voting system? (Josh and Chris report)
  - What are the current limitations? (e.g. scalability limited due to public Ethereum)
  - What can we look towards modifying to minimise the effect of the limitations?
    - How will that affect security/decentralisation in comparison to other existing methods?

## Week 5 (Wed 1 April 2026)
Type: Meeting summary

Presented the draft literature review to Dev and Kevin for their feedback.

## Wed 8 April 2026
Type: No meeting (mid-semester break)

## Wed 15 April 2026
Type: No meeting (mid-semester break)

## Week 6 (Wed 22 April 2026)
Type: Meeting summary

Kevin and Dev suggested assessing higher-level problems, e.g.:
- Hardware costs for setting up a private blockchain for online voting
- Can it be reused on future occasions, or in other places (e.g. referendums)?
- What are the ongoing costs?
- Would this be cheaper than the current voting system?

Dev suggested not limiting our research to MACI; we should consider other infrastructures as well.
- The "last vote counts" approach might not be good either: people could be forced to change their vote at the last minute?

## Week 7 (Wed 29 April 2026)
Type: Meeting summary

- Cost: break down the cost, and identify the replacement cost with our approach
- DAO: what are the vulnerabilities of a DAO (attacks?)
- Hash: node validation consensus
- Off-chain: replace ZK-proof with another hashing function?
- Private:
  - Devs:
    - 1 software function (send vote, validate vote?) -> send to the next node to see the latency
    - 1 software node validation (putting nodes, updating nodes). We can reduce some steps in setting up/configuring if we use a private network? (i.e. we only have one type of thing going through our network)
- Private blockchain demonstration:
  - Software to do the testing and model the performance of our private blockchain (after modification)
  - Also helpful to assess the performance and other metrics under different scenarios (e.g. national election, smaller elections, etc.)

## Week 8 (Wed 6 May 2026)
Type: No meeting (assignment workload in other courses)

## Week 9 (Wed 13 May 2026)
Type: Meeting summary

Diagram: transaction hash -> block hash, passed from one node (N1) to the next node.

Private blockchain:
- Collection of votes in a pool (waiting to be verified)
- Nodes
  - Grab votes from the pool
    - Asynchronous, to prevent the same votes being grabbed twice
  - Block full -> needs to be verified
    1. The node itself -> validates the transaction hash
    2. Node on the new block -> validates correctness
    - Sketch: H[ H(id), H(votes) ] -> hash
- Votes -> create votes -> votes -> hash -> H(votes), from (id) and (votes)
- Tallying (done by a node)
  - Full tally
  - Tally by a few blocks (e.g. blocks 1 to 5, 6 to 10)
  - Confirm with other nodes

Cost:
- Kevin: model calculation on the number of distributed nodes vs resources

## Week 10 (Wed 20 May 2026)
Type: Meeting summary
Attendees: Eason, Patrick, Kevin (Dev was sick)

Not much on the project itself; mostly about future deliverables.
- Ideally finish most of the implementation and report writing during the break
- Prepare a presentation (~15 min plus Q&A) for the project seminar on 25 July

## Week 11 (Wed 27 May 2026)
Type: Progress check (no minutes recorded)

## Week 12 (Wed 3 June 2026)
Type: Meeting summary

Mempool:
- The mempool isn't for storing votes, and it's not a centralised pool; every node has its own mempool
- The mempool should be used to store registered identities (RealMe) that have not voted yet
  - When a new vote comes in, take the name out of the mempool (to show it has voted / the vote is being processed)
  - When a repeated vote comes in, check whether the name is in the mempool; if not, that person has already voted or a vote is currently being processed

Consensus mechanism (validating):
- Assume for now that nodes have a secure method to communicate with each other (for passing raw vote data between nodes)
- Votes enter node A, which validates whether the vote can enter the blockchain by checking that the other nodes (B, C, etc.) get the same storing hash (i.e. node A gets the same storing hash as node B). Add the block after validation
- Can create a block at 100 votes and then run another consensus round (i.e. node A creates a block with a block hash; node B should get the same block hash if everything was handled correctly)
- Main idea should be around pBFT? So we can identify and fix broken/corrupted nodes based on the majority?

## Study break (Wed 10 June 2026)
Type: Meeting summary

Multiple consensus rounds running at the same time: how to order them?
- Fixed index with node ID
- Dynamic index across all nodes
  - We can abstract this away for now

Broadcast nodes clarification:
- Each node talks to all nodes instead of one to one
- Need to think of some way to do parallel processing

HoneyBadger: MPC
- HBFT, using a shared public key to overcome faulty nodes

Simulation:
- Start by running up to 5 nodes in terminals
- Later use the cloud to simulate different areas

When to start a task:
- Event based
- Estimate processing time
- Timestamp from the terminal (can work out the time taken)

## Wed 17 June 2026
Type: No meeting (exam period)

## Wed 24 June 2026
Type: No meeting (exam period)

---

# Inter-semester break

## Wed 1 July 2026
Type: No meeting (inter-semester break)

## Wed 8 July 2026
Type: Meeting summary
Attendees: Eason, Patrick, Kevin (Dev was away)

- Keep focusing on the project seminar and the mid-year report
- Consider using analogies to explain the project concept (to keep it simpler), and be careful with wording (e.g. saying something like "democracy (distributed system) is better than ...")
- To wrap up the presentation, talk about next steps
- Include diagrams to explain some parts
- Write about the technical implementation and how it works in the mid-year report
  - Talk about PRE-PREPARE, PREPARE, COMMIT?
  - Should include some figures for costs? (later, in the final report)

## Wed 15 July 2026
Type: Meeting summary

Practice run of the project seminar presentation for Dev and Kevin, followed by their feedback.

Patrick:
- Blockchain is one of various options we are considering for online voting
- State assumptions about national elections
  - e.g. designing a system for 3 million votes (say that we are designing for 5 million votes)
- When explaining how online voting works on a blockchain:
  - Blockchain of records -> explain what the records are in a traditional blockchain; in ours, they are votes
- Explain the problem with MACI on a private blockchain as well

Eason:
- Permission: identity management
  - Explain what permission involves
  - Which nodes are part of the network?
- The Electoral Commission gives the list of registered voters
  - Every time a voter votes, we verify that they are on the list
- Voting process
  - Mention that votes are sent to one of many nodes

Final:
- Create appendix slides that are helpful for Q&A

Next meeting: Wednesday 22 July 2026, 11:15 am

---

# Semester Two

## Week 1 (Wed 22 July 2026)
Type: Presentation run-through (no minutes recorded)

Went through the seminar presentation again with Dev and Kevin. No further feedback was given, so no minutes were taken.

## Week 2 (Wed 29 July 2026)
Type: Progress check (no minutes recorded)

## Week 3 (Wed 5 August 2026)
Type: Meeting summary

Besu:
- Besu creates blocks asynchronously, though exactly how it does this was still to be checked.
- Besu is an existing framework that runs as a private Ethereum network, so we can connect to it instead of building our own blockchain.
- Besu handles block storage within the private Ethereum network.
- Besu runs the Ethereum Virtual Machine (EVM), so a smart contract can handle vote verification.
- Besu can restore the chain's data history.

Besu solves:
- Besu handles how votes are communicated between nodes through its P2P network, instead of a server listening for votes.
- Besu already includes a BFT consensus algorithm, so we do not need to build our own.
- Open question: can we add a manual delay?

## Week 4 (Wed 12 August 2026)
Type: No meeting (both students unwell)

## Week 5 (Wed 19 August 2026)
Type: Meeting summary

- Consider the purpose of using blockchain
- Look at other online data storage systems, and find the benefit of using blockchain
- Kevin suggested starting to draft sections for the final report, and then working towards them
- Dev talked about some work relating to [note incomplete in original]

Report splitting:
- Both cover:
  - Electoral Commission setup of registered voters
  - Voting system structure (e.g. mempool, voting, nodes, consensus)
  - Comparison with MACI?
- Patrick:
  - Cover Besu and its detailed configuration and structure, and mention what could be changed in a private approach
- Eason:
  - Mention Besu, and talk about the investigation of a new private approach
- The reports should ideally cover a performance comparison: MACI -> Besu -> new approach

## Week 6 (Wed 26 August 2026)
Type: Progress check (no minutes recorded)

Progress update. Started planning the final report structure and producing the material needed for it.

## Wed 2 September 2026
Type: No meeting (mid-semester break)

## Wed 9 September 2026
Type: No meeting (mid-semester break)

## Weeks 7 to 9 (Wed 16, 23 and 30 September 2026)
Type: Progress check (no minutes recorded)

Weekly progress updates on the final report, covering:
- Developing the report structure and the content needed for each section
- Running tests and collecting the testing data used in the report

## Week 10 (Wed 7 October 2026)
Type: Meeting summary

Poster check: Dev and Kevin reviewed our poster for presentation day.

## Week 10 (Fri 9 October 2026, online)
Type: Meeting summary

Extra online meeting to go through the revised poster with Dev and Kevin.

## Week 11 (Wed 14 October 2026)
Type: Meeting summary

Report check: Dev and Kevin gave advice on the final report and on presentation day.
