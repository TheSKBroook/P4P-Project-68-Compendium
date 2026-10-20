# Voting Frontend

A Next.js web app that shows the voting system from the voter's and the election administrator's
point of view. It talks directly to a Besu validator's JSON-RPC endpoint through ethers.js; there is
no separate backend.

It is a demonstration client for the project, not a hardened voting client: private keys are typed
into the browser, and nothing here was security-reviewed.

## Pages

| Route | Who | What it does |
|---|---|---|
| `/` | Anyone | Choose the voter or administrator view |
| `/voter` | Voter | Enter the network settings, connect with a voter's private key, see voter status (NotVoted, Processing, Voted), cast a vote |
| `/admin` | Administrator | Register voters, open and close voting, watch live results, and a simple live benchmark view (rolling throughput, block utilisation, finality latency) |

## Running it

Needs Node.js 20 or later, a running network (see the root `README.md`) and a deployed
`VotingSystem` contract.

```bash
cd frontend
npm install
npm run dev        # http://localhost:3000
```

On either page, enter under **Network Configuration**:

- the RPC URL of any validator, for example `http://127.0.0.1:8545`
- the deployed contract address (printed by `forge script script/Deploy.s.sol`)

Then connect with a private key: the deployer's key for `/admin`, or a registered voter's key for
`/voter`. Transactions are sent with a gas price of 0, matching the network configuration.

## Code layout

| Path | Contents |
|---|---|
| `app/voter/page.tsx`, `app/admin/page.tsx` | The two views |
| `lib/blockchain.ts` | Provider and contract helpers, error messages for contract reverts |
| `lib/abi.ts` | `VotingSystem` ABI |
| `lib/types.ts` | Shared types |
| `components/ui/` | shadcn/ui components |

Built with Next.js 16.2.9, React 19.2.4 and ethers 6.
