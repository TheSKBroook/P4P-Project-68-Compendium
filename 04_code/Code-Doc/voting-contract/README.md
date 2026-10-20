# VotingSystem Contract

The Solidity smart contract that holds the voter roll, the voting rules and the tally. Written in
Solidity 0.8.19 and built with Foundry.

## Contract

`src/VotingSystem.sol`

- The deploying account is the election administrator. Only it can register voters and open or
  close voting.
- Each registered voter address moves through three states: **NotVoted**, **Processing** and **Voted**.
  A voter can only vote once; any further attempt reverts.
- `openVoting()` and `closeVoting()` set the voting window.
- `castVote(candidateId)` checks that voting is open, the sender is registered and has not voted,
  and the candidate is valid, then records the vote and emits a `VoteCast` event with the voter's
  address and candidate.
- `getTally(candidateId)` returns the count for one candidate, and `getVoterState(voter)` returns a voter's state. The tally can also be recounted
  independently from the `VoteCast` events (see `perf-testing/monitoring/audit-tally.js`).

## Tests

`test/VotingSystem.t.sol` has 10 tests:

| Test | Checks |
|---|---|
| `test_RegisterVoter` | The administrator can register a voter |
| `test_CannotRegisterTwice` | Registering the same address again reverts |
| `test_OnlyAdminCanRegister` | Only the administrator can register voters |
| `test_CastVote` | A valid vote is recorded and counted |
| `test_DoubleVotePrevented` | A second vote from the same voter reverts |
| `test_UnregisteredVoterRejected` | An unregistered address cannot vote |
| `test_CannotVoteWhenClosed` | Voting before it opens reverts |
| `test_CannotVoteAfterClose` | Voting after it closes reverts |
| `test_InvalidCandidateRejected` | An out-of-range candidate reverts |
| `test_MultipleVotersTally` | The tally is correct across several voters |

```bash
forge install foundry-rs/forge-std   # first time only
forge build
forge test -vv
```

## Deploying to the Besu network

Create a `.env` file in this folder with the private key of the account that will be administrator
(for example one of the validator keys):

```
DEPLOYER_PRIVATE_KEY=<private key>
```

Then:

```bash
forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --legacy
```

`--legacy` is needed because the network uses legacy (type 0) transactions with a gas price of 0.
Deployment records are kept in `broadcast/Deploy.s.sol/1337/`.

## Manual test scripts

`test-scripts/` wraps `cast` for trying the contract by hand. Each script has the contract address and
RPC URL set at the top (`CONTRACT=`, `RPC=`); change them to match your deployment. Administrator
scripts read the key from `network/networkFiles/keys/`.

| Script | Use |
|---|---|
| `setup-election.sh` | Open voting |
| `register-voter.sh <voter address>` | Register a voter |
| `cast-vote.sh <voter private key> <candidate>` | Cast a vote |
| `tally.sh <candidate>` | Print one candidate's tally |

The performance tests in `perf-testing/` deploy their own copy of the contract and do not use these
scripts.
