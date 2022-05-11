// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

//import IERC20
//import AAVE interface
//import VOLTZ interface
//import ownable

contract HedgeHog {
    //customer deposits USDC into contract
    //contract deposits USDC into AAVE
    //contract receives aUSDC
    //contract deposits aUSDC into VOLTZ
    //contract recieves fixed position tokens
    //contract wraps fixed position tokens
    //contracts enables customer to withdraw wrapped tokens less fee

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

    //function interactWithAAVE internal
    //function interactWithVoltz internal
    //function interactWithTokenWrapper internal
}
