// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {TornadoOptV1} from "../src/TornadoOptV1.sol";
import {WithdrawVerifierAdapter} from "../src/verifiers/WithdrawVerifierAdapter.sol";

contract TornadoOptV1Script is Script {
    function run() public returns (TornadoOptV1 pool, WithdrawVerifierAdapter withdrawVerifier) {
        // Required params via environment
        uint256 pk = vm.envUint("PRIVATE_KEY");
        uint256 denomination = vm.envUint("DENOMINATION_WEI");
        address ivcVerifier = vm.envAddress("IVC_VERIFIER");

        vm.startBroadcast(pk);

        // Deploy withdraw verifier adapter (wraps Groth16 verifier from submodule)
        withdrawVerifier = new WithdrawVerifierAdapter();

        // Deploy pool pointing to the given IVC verifier and the adapter
        pool = new TornadoOptV1(denomination, ivcVerifier, address(withdrawVerifier));

        vm.stopBroadcast();
    }
}
