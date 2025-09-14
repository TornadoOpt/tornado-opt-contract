// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2 as console} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {TornadoOptV1} from "../src/TornadoOptV1.sol";

contract State is Script {
    using stdJson for string;

    function run() external view {
        address poolAddr = _resolvePool();
        TornadoOptV1 pool = TornadoOptV1(payable(poolAddr));

        console.log("pool:", poolAddr);
        console.log("denomination:", pool.denomination());
        console.log("ivcVerifier:", address(pool.ivcVerifier()));
        console.log("withdrawVerifier:", address(pool.withdrawVerifier()));
        console.logBytes32(pool.hashChainRoot());
        console.log("nextIndex:", pool.nextIndex());
    }

    function _resolvePool() internal view returns (address poolAddr) {
        // 1) Try env override
        string memory envPool = vm.envOr("POOL", string(""));
        if (bytes(envPool).length != 0) {
            return vm.parseAddress(envPool);
        }

        // 2) Fallback: read latest broadcast for this chainId
        string memory root = vm.projectRoot();
        string memory path = string.concat(
            root,
            "/broadcast/Deploy.s.sol/",
            vm.toString(block.chainid),
            "/run-latest.json"
        );
        string memory json = vm.readFile(path);

        uint256 len = json.readUint(".transactions.length");
        for (uint256 i = 0; i < len; i++) {
            string memory p = string.concat(".transactions[", vm.toString(i), "]");
            string memory name = json.readString(string.concat(p, ".contractName"));
            if (keccak256(bytes(name)) == keccak256(bytes("TornadoOptV1"))) {
                return json.readAddress(string.concat(p, ".contractAddress"));
            }
        }
        revert("POOL not found: set POOL or deploy first");
    }
}
