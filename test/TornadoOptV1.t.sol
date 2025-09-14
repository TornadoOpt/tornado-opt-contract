// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {TornadoOptV1} from "../src/TornadoOptV1.sol";

contract MockIVCVerifier {
    bool public ok;

    constructor(bool _ok) {
        ok = _ok;
    }

    function set(bool _ok) external {
        ok = _ok;
    }

    function verify(bytes calldata, bytes32, bytes32) external view returns (bool) {
        return ok;
    }
}

contract MockWithdrawVerifier {
    bool public ok;

    constructor(bool _ok) {
        ok = _ok;
    }

    function set(bool _ok) external {
        ok = _ok;
    }

    function verify(bytes calldata, bytes32, bytes32, bytes32) external view returns (bool) {
        return ok;
    }
}

contract TornadoOptV1Test is Test {
    TornadoOptV1 internal pool;
    MockIVCVerifier internal ivc;
    MockWithdrawVerifier internal wv;

    uint256 constant DENOM = 1 ether;

    function setUp() public {
        ivc = new MockIVCVerifier(true);
        wv = new MockWithdrawVerifier(true);
        pool = new TornadoOptV1(DENOM, address(ivc), address(wv));
    }

    // Fixture-based check against Rust test output
    // From Rust fixture:
    // sha256(preimage)=0x2dc193c143896f77f4e75f78999741356dae7f4352e55b758c81a57773bb8e53
    // next hash_chain_root (Fr)=0x008ebb7377a5818c755be552437fae6d35419799785fe7f4776f8943c193c12d
    function testHashChainFixture_PrevZero_Commit123() public {
        bytes32 commitment = bytes32(uint256(123));
        pool.deposit{value: DENOM}(commitment);
        bytes32 expected = 0x008ebb7377a5818c755be552437fae6d35419799785fe7f4776f8943c193c12d;
        assertEq(pool.hashChainRoot(), expected);
        assertEq(pool.nextIndex(), 1);
    }
}
