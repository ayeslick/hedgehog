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
import "./interfaces/ICREDIT.sol";
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

    //Potential Updates:
    //check the maturity date
    //checks the fee, for the UI
    //admin rollsover underlying to new term
    //for rollover:
    //call either redeemToBacking or redeemToYieldBearing
    //then call depositAndFix

    ITOKENMANAGER internal immutable tokenmanager;
    ITEMPUSCONTROLLER internal immutable TEMPUS_CONTROLLER;
    address internal tToken;
    ITempusAMM internal immutable TEMPUS_AMM;
    address internal immutable CREDS;
    ICREDIT internal immutable CREDIT;
    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    uint256 internal constant DEADLINE = 8640000000000000; //for demo
    uint256 internal constant MINTYSRATE = 29574853134128102; //for demo

    constructor(
        ITOKENMANAGER _tokenmanager,
        ITEMPUSCONTROLLER _tempusController,
        address _tToken,
        ITempusAMM _tempusAMM,
        address _creds,
        ICREDIT _credit
    ) {
        tokenmanager = _tokenmanager;
        TEMPUS_CONTROLLER = _tempusController;
        TEMPUS_AMM = _tempusAMM;
        tToken = _tToken;
        CREDS = _creds;
        CREDIT = _credit;
        ERC20(tToken).approve(address(this), type(uint256).max);
        ERC20(CREDS).approve(address(this), type(uint256).max);
    }

    function depositThenReceiveCredsAndCredit(uint256 amount) external {
        address customer = msg.sender;
        ERC20(DAI).transferFrom(customer, address(this), amount);
        TEMPUS_CONTROLLER.depositAndFix(
            TEMPUS_AMM,
            amount,
            true,
            MINTYSRATE,
            DEADLINE
        );
        uint256 credsRecieved = tokenmanager.deposit(amount);
        //contract receives creds & credit. send to msg.sender
        ERC20(CREDS).transferFrom(address(this), customer, credsRecieved);
        ICREDIT(CREDIT).transferFrom(address(this), customer, 1); //for demo, should return both creds and credit
    }

    function increaseCredit(uint256 tokenId, uint256 amount)
        external
        returns (uint256)
    {
        address customer = msg.sender;
        uint256 credsRecieved = tokenmanager.increaseCredit(tokenId, amount);
        ERC20(CREDS).transferFrom(address(this), customer, credsRecieved);
        return credsRecieved;
    }

    function decreaseCredit(uint256 tokenId, uint256 amount)
        external
        returns (uint256)
    {
        address customer = msg.sender;
        ERC20(CREDS).transferFrom(customer, address(this), amount);
        uint256 currentBalance = tokenmanager.decreaseCredit(tokenId, amount);
        return currentBalance;
    }

    function claimUnderlying(uint256 tokenId) external returns (uint256) {
        //cannot access depositValue from here. The follow will have to do for now
        address customer = msg.sender;
        ICREDIT(CREDIT).transferFrom(customer, address(this), tokenId);
        uint256 amountOfClaimed = tokenmanager.claimUnderlying(tokenId); //assumes contract has enough creds before transferring from customer
        ERC20(CREDS).transferFrom(customer, address(this), amountOfClaimed); //contract doesnt know how many creds to transfer before calling tokenmanger
        return amountOfClaimed;
    }
}
