// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

interface ICREDUT {
    function createCREDUT(address customer, uint256 amount) external;

    function subtractValueFromCREDUT(
        address customer,
        uint256 tokenId,
        uint256 amount
    ) external;

    function deleteCREDUT(address customer, uint256 tokenId)
        external
        returns (uint256 value);

    function transferFrom(
        address customer,
        address to,
        uint256 tokenId
    ) external;

    function transferOwnership(address newOwner) external;
}
