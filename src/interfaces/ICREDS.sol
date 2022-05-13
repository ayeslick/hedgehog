// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

interface ICREDS {
    function mint(address to, uint256 amount) external;

    function burn(address customer, uint256 amount) external;

    function transferFrom(
        address customer,
        address to,
        uint256 amount
    ) external;

    function transferOwnership(address newOwner) external;
}
