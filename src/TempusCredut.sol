// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

//CREDUT NFT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error NotCurrentHolder();
error AmountExceedsDepositValue();

contract TempusCredut is ERC721("Tempus CREDUT", "tCREDUT"), Ownable {
    uint256 private _tokenId;

    //NFTID => value stored in NFT
    mapping(uint256 => uint256) public depositValue;

    event AddValue(address indexed customer, uint256 tokenId, uint256 amount);
    event SubtractValue(
        address indexed customer,
        uint256 tokenId,
        uint256 amount
    );
    event Deleted(address indexed customer, uint256 tokenId, uint256 value);

    //core
    function createCREDUT(address customer, uint256 amount) public onlyOwner {
        uint256 tokenId = ++_tokenId;
        depositValue[tokenId] = amount;
        _safeMint(customer, tokenId);
    }

    /*customer cannot withdraw more than depositValue
    because it will throw Arithmetic over/underflow error
    */
    function subtractValueFromCREDUT(
        address customer,
        uint256 tokenId,
        uint256 amount
    ) public onlyOwner {
        address currentHolder = ERC721.ownerOf(tokenId);
        if (currentHolder != customer) revert NotCurrentHolder();
        depositValue[tokenId] -= amount;
        emit SubtractValue(customer, tokenId, amount);
    }

    function deleteCREDUT(address customer, uint256 tokenId)
        public
        onlyOwner
        returns (uint256 value)
    {
        address currentHolder = ERC721.ownerOf(tokenId);
        if (currentHolder != customer) revert NotCurrentHolder();
        value = depositValue[tokenId];
        delete depositValue[tokenId];
        _burn(tokenId);
        emit Deleted(customer, tokenId, value);
        return value;
    }
}