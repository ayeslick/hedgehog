// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

//import IERC20
import "solmate/tokens/ERC20.sol";

//import IERC721
import "solmate/tokens/ERC721.sol";

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
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    uint256 internal constant DEADLINE = 8640000000000000; //for demo
    uint256 internal constant MINTYSRATE = 29574853134128102; //for demo
    address internal constant CREDS =
        0x02df3a3F960393F5B349E40A599FEda91a7cc1A7; // for demo
    address internal constant CREDIT =
        0x821f3361D454cc98b7555221A06Be563a7E2E0A6; //for demo

    constructor(ITOKENMANAGER _tokenmanager) {
        tokenmanager = _tokenmanager;
        ERC20(tToken).approve(address(this), type(uint256).max);
    }

    function depositThenRecieveCredsAndCredit(uint256 amount) external {
        address customer = msg.sender;
        // ERC20(DAI).transferFrom(customer, address(this), amount);
        // TEMPUS_CONTROLLER.depositAndFix(
        //     TEMPUS_AMM,
        //     amount,
        //     true,
        //     MINTYSRATE,
        //     DEADLINE
        // );
        // uint256 tempusTokens = ERC20(tToken).balanceOf(address(this));
        tokenmanager.deposit(amount);
        //send creds & credit to msg.sender
        // ERC20(CREDS).transferFrom(address(this), customer, credsRecieved);
        // ERC721(CREDIT).transferFrom(address(this), customer, 1); //for demo
    }

    function increaseCredit(uint256 amount) external {}

    function decreaseCredit(uint256 amount) external {}

    function claimUnderlying(uint256 amount) external {}
}
