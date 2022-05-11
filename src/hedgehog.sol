// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

//import IERC20
//import AAVE interface
//import VOLTZ interface

contract HedgeHog {
    //customer deposits USDC into contract
    //contract deposits USDC into AAVE
    //contract receives aUSDC
    //contract deposits aUSDC into VOLTZ
    //contract recieves fixed position tokens
    //contract wraps fixed position tokens
    //contracts allows customer to withdraw tokens

    //constructor here
    //USDC address
    //aUSDC address
    //voltz address
    //wrappedToken address

    function deposit(uint256 amount) public pure returns (uint256) {
        return amount;
    }

    function withdraw(uint256 amount) public pure returns (uint256) {
        return amount;
    }

    //function interactWithAAVE
    //function interactWithVoltz
    //function interactWithTokenWrapper
}
