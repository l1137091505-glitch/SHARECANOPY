# Verification

- Frontend: `npm run build`
- Contract: `npx solc@0.8.24 --bin --abi contracts/src/ShareCanopy.sol`
- BOT Chain RPC: `eth_chainId` must return `0x2a5`.
- Wallet: EIP-6963 discovery, explicit chooser, chain switch/add and contract-bytecode check.

The implementation was derived from public product behavior only. Reference source, branding, copy, images, contract code and signature layout were not reused.
