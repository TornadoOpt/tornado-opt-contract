## TornadoOpt V1 (Quick Guide)

Privacy pool with off-chain Merkle updates, on-chain checkpoints for Virtual Merkle Root by Folding Scheme(ZK), and Groth16 withdrawals.

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
