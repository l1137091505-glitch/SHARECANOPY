# SHARECANOPY

SHARECANOPY is an original native-BOT distribution workspace. A creator lists 1–100 wallet addresses with positive weights, funds one round, and the Solidity contract calculates each wallet's fixed allocation. Listed wallets claim before expiry; the creator can reclaim the unclaimed remainder afterward.

## Structure

- `frontend/` — Vite + TypeScript interface with EIP-6963 wallet discovery.
- `contracts/src/ShareCanopy.sol` — native BOT distribution contract.
- `DEPLOY-ZH.md` — Chinese deployment and interaction guide.

## Local development

```bash
cd frontend
npm install
npm run dev
```

Contract writes require `VITE_SHARECANOPY_ADDRESS`. The interface does not ask for a wallet until a user opens or claims a distribution.

## Limits

- Native BOT only.
- 1–100 unique recipient addresses per round.
- Claim window: frontend limits 1–365 days.
- No platform fee.

The code has not received a professional security audit. Test with small amounts first.
