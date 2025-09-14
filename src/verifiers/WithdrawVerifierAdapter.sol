// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import arkworks-solidity-verifier output from submodule
import "tornado-opt-withdraw/withdraw_solidity_verifier.sol";

/// @title WithdrawVerifierAdapter
/// @notice Adapter to bridge TornadoOptV1 withdraw verifier ABI to the generated Groth16 verifier.
/// @dev Expects `proof` to be ABI-encoded as (uint256[8]) = [ax, ay, bx0, bx1, by0, by1, cx, cy].
///      Public inputs are mapped as [virtualMerkleRoot, nullifierHash, recipient].
contract WithdrawVerifierAdapter is Verifier {
    /// @notice Verify withdraw proof against public inputs
    /// @param proof ABI-encoded uint256[8]: ax, ay, bx0, bx1, by0, by1, cx, cy
    /// @param virtualMerkleRoot State commitment registered via checkpoint
    /// @param nullifierHash Hash of the nullifier secret to prevent double-withdraw
    /// @param recipient Payout address (lower 160 bits of field element)
    function verify(bytes calldata proof, bytes32 virtualMerkleRoot, bytes32 nullifierHash, bytes32 recipient)
        external
        view
        returns (bool)
    {
        // Decode Groth16 proof
        require(proof.length == 32 * 8, "BAD_PROOF_LEN");
        uint256[8] memory w = abi.decode(proof, (uint256[8]));

        Proof memory p;
        p.a = Pairing.G1Point(w[0], w[1]);
        p.b = Pairing.G2Point([w[2], w[3]], [w[4], w[5]]);
        p.c = Pairing.G1Point(w[6], w[7]);

        // Map public inputs: [vmRoot, nullifierHash, recipient]
        uint256[3] memory input;
        input[0] = uint256(virtualMerkleRoot);
        input[1] = uint256(nullifierHash);
        input[2] = uint256(recipient);

        return verifyTx(p, input);
    }
}
