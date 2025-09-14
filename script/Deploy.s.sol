// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {TornadoOptV1} from "../src/TornadoOptV1.sol";
import {WithdrawVerifierAdapter} from "../src/verifiers/WithdrawVerifierAdapter.sol";
import {IVCVerifierAdapter} from "../src/verifiers/IVCVerifierAdapter.sol";

contract TornadoOptV1Script is Script {
    function run()
        public
        returns (TornadoOptV1 pool, WithdrawVerifierAdapter withdrawVerifier, IVCVerifierAdapter ivcVerifier)
    {
        // Required params via environment
        uint256 pk = vm.envUint("PRIVATE_KEY");
        uint256 denomination = vm.envUint("DENOMINATION_WEI");

        vm.startBroadcast(pk);

        // Deploy verifiers
        ivcVerifier = new IVCVerifierAdapter();
        withdrawVerifier = new WithdrawVerifierAdapter();

        // Deploy pool with fresh verifier adapters
        pool = new TornadoOptV1(denomination, address(ivcVerifier), address(withdrawVerifier));

        vm.stopBroadcast();
    }
}
