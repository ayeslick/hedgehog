// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
pragma abicoder v2;

/// Implements versioning
interface IVersioned {
    struct Version {
        uint16 major;
        uint16 minor;
        uint16 patch;
    }

    /// @return The version of the contract.
    function version() external view returns (Version memory);
}
