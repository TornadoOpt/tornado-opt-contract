## TornadoOpt V1 (Quick Guide)

Very Cheap Privacy pool with off-chain Merkle Tree updates by Folding Scheme + Groth16 Decider, on-chain checkpoint for Registering the Merkle Root, and Groth16 withdrawals.

### 1) Setup
- Install Foundry: https://book.getfoundry.sh/
- Init submodules: `git submodule update --init --recursive`
- Build & test: `forge build` / `forge test`

### 2) Deploy
```bash
export RPC_URL=...
export PRIVATE_KEY=...
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url $RPC_URL --private-key $PRIVATE_KEY \
  --broadcast -vv
```
