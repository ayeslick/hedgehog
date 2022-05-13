// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

//import IERC20
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//import ownable
import "@openzeppelin/contracts/access/Ownable.sol";

contract HedgeHog is Ownable {
    error NotEnoughFunds();
}
