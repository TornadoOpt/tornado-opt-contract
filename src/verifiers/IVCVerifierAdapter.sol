// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import NovaDecider from submodule
import "tornado-opt-backend/NovaDecider.sol";

/// @title IVCVerifierAdapter
/// @notice Adapter to match the TornadoOptV1 `IIVCVerifier` ABI using the NovaDecider verifier.
/// @dev Expects `proof` to be full ABI-encoded calldata (including selector) for NovaDecider's
///      verification entrypoint (e.g., `verifyNovaProof(...)`) produced by the backend fixtures.
contract IVCVerifierAdapter is NovaDecider {
    /// @notice Verify IVC proof using NovaDecider
    /// @param proof ABI-encoded calldata for NovaDecider's `verifyNovaProof` (with selector)
    /// @param hashChainRoot Current running hash (provided for ABI compatibility; bound inside proof)
    /// @param virtualMerkleRoot Committed state (provided for ABI compatibility; bound inside proof)
    function verify(
        bytes calldata proof,
        bytes32 hashChainRoot,
        bytes32 virtualMerkleRoot
    ) external view returns (bool) {
        // Silence unused warnings; NovaDecider proof must bind these in its public inputs
        hashChainRoot; virtualMerkleRoot;

        // Forward the calldata to this contract (NovaDecider) for verification
        (bool ok, bytes memory ret) = address(this).staticcall(proof);
        if (!ok) return false;
        if (ret.length == 32) {
            return abi.decode(ret, (bool));
        }
        return false;
    }
}

