// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

interface ITOKENMANAGER {
    function deposit(uint256 amount) external returns (uint256);

    function partialWithdraw(uint256 tokenId, uint256 amount) external;

    function claimAllUnderlying(uint256 tokenId) external;

    function transferOwnership(address newOwner) external;
}
