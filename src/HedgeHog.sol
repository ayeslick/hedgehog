// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

//import IERC20
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//import ownable
import "@openzeppelin/contracts/access/Ownable.sol";

contract HedgeHog is Ownable {
    error NotEnoughFunds();

    //deposit fixed income principal tokens, receive CREDS & CREDUT
    //deposit acceptedUnderlying, calls depositAndFix, wraps tTokens, receive CREDS & CREDUT
    //To redeem the value of both CREDS & CREDUT have to match

    //place all approvals within constructor

    //check the maturity date
    //checks the fee, for the UI
    //admin rollsover underlying to new term
    //for rollover:
    //call either redeemToBacking or redeemToYieldBearing
    //then call depositAndFix
}
