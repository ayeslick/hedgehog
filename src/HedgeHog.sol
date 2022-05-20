// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

//import IERC20
import "solmate/tokens/ERC20.sol";

//import ownable
import "@openzeppelin/contracts/access/Ownable.sol";

//import interface
import "./interfaces/ITOKENMANAGER.sol";
import "./interfaces/ITempusAMM.sol";

interface ITEMPUSCONTROLLER {
    function depositAndFix(
        ITempusAMM tempusAMM,
        uint256 tokenAmount,
        bool isBackingToken,
        uint256 minTYSRate, //how to determine this?
        uint256 deadline
    ) external;
}

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

    ITOKENMANAGER internal immutable tokenmanager;
    ITEMPUSCONTROLLER internal constant TEMPUS_CONTROLLER =
        ITEMPUSCONTROLLER(0xdB5fD0678eED82246b599da6BC36B56157E4beD8);
    address internal tToken = 0xfE932d00b9858C42108378053C11bE79656116AF;
    ITempusAMM internal constant TEMPUS_AMM =
        ITempusAMM(0x7cA043143C6e30bDA28dDc7322d7951F538D75e8);
    uint256 internal constant DEADLINE = 8640000000000000;

    constructor(ITOKENMANAGER _tokenmanager) {
        tokenmanager = _tokenmanager;
        ERC20(tToken).approve(address(this), type(uint256).max);
    }

    function depositThenRecieveCredsAndCredit(
        uint256 amount,
        uint256 minTYSRate
    ) external returns (uint256) {
        TEMPUS_CONTROLLER.depositAndFix(
            TEMPUS_AMM,
            amount,
            true,
            minTYSRate,
            DEADLINE
        );
        uint256 tempusTokens = ERC20(tToken).balanceOf(address(this));
        return tokenmanager.deposit(tempusTokens);
    }

    function depositThenAdd(uint256 amount) external {}

    function depositThenRetrievePartialUnderlying(uint256 amount) external {}

    function depositThenRetrieveAllUnderlying(uint256 amount) external {}
}
