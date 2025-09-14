// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {TornadoOptV1} from "../src/TornadoOptV1.sol";

contract DepositOnce is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address poolAddr = vm.envAddress("POOL");
        bytes32 commitment = vm.envBytes32("COMMITMENT");

        TornadoOptV1 pool = TornadoOptV1(payable(poolAddr));
        uint256 value = vm.envOr("VALUE_WEI", pool.denomination());

        vm.startBroadcast(pk);
        pool.deposit{value: value}(commitment);
        vm.stopBroadcast();
    }
}

