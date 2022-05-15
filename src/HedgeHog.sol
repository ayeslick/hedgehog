// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

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
        uint256 minTYSRate,
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

    ITOKENMANAGER public immutable tokenmanager;
    address public tToken;

    constructor(ITOKENMANAGER _tokenmanager, address _tToken) {
        tokenmanager = _tokenmanager;
        tToken = _tToken;
    }

    uint256 public globalAmount;

    function depositThenRecieveCredsAndCredit(uint256 _amount) external {}

    function rolloverAfterMaturity() external onlyOwner {}

    function _interactWithTempus() internal {}
}
