// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "solmate/utils/ReentrancyGuard.sol";
import "solmate/tokens/ERC20.sol";
import "solmate/utils/SafeTransferLib.sol";
import "./interfaces/ICREDS.sol";
import "./interfaces/ICREDIT.sol";

contract TokenManagerETH is Ownable, Pausable, ReentrancyGuard {
    using SafeTransferLib for ERC20;

    error CeilingReached();
    error EmptySend();
    error EmergencyNotActive();
    error EmergencyActive();
    error NoFeesToTransfer();
    error FeeTooLow();
    error FeeTooHigh();

    ICREDS private creds;
    ICREDIT private credit;

    uint256 public globalDepositValue;
    uint256 public globalCeiling;
    uint256 public feePercentage = 30; //0.3% default
    uint256 private constant BASIS_POINTS = 10_000;
    uint256 public feeToTransfer;

    uint256 public emergencyStatus = 1; //inactive by default
    uint256 private immutable emergencyNotActive = 1;
    uint256 private immutable emergencyActive = 2;

    address payable private treasury;
    address public tToken;

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);
    event SubtractFromCredut(
        address indexed customer,
        uint256 tokenId,
        uint256 amount
    );

    constructor(
        ICREDS _creds,
        ICREDIT _credit,
        address payable _treasury,
        address _tToken,
        uint256 _globalCeiling
    ) {
        creds = _creds;
        credit = _credit;
        treasury = _treasury;
        tToken = _tToken;
        globalCeiling = _globalCeiling;
    }

    function deposit(uint256 amount)
        external
        whenNotPaused
        nonReentrant
        returns (uint256)
    {
        if (amount == 0) revert EmptySend();
        if (globalDepositValue >= globalCeiling) revert CeilingReached();

        address customer = msg.sender;
        uint256 adjustedFee = _calculateFee(amount);
        feeToTransfer += adjustedFee;
        uint256 adjustedAmount = amount - adjustedFee;
        globalDepositValue += adjustedAmount;
        ERC20(tToken).safeTransferFrom(customer, address(this), amount);
        creds.mint(customer, adjustedAmount);
        credit.createCREDUT(customer, adjustedAmount);
        emit Deposit(customer, adjustedAmount);
        return creds.balanceOf(customer);
    }

    function partialWithdraw(uint256 tokenId, uint256 amount)
        external
        whenNotPaused
        nonReentrant
    {
        address customer = msg.sender;
        credit.subtractValueFromCREDIT(customer, tokenId, amount);
        creds.burn(customer, amount);
        globalDepositValue -= amount;
        ERC20(tToken).safeTransferFrom(address(this), customer, amount);
        emit SubtractFromCredut(customer, tokenId, amount);
    }

    function claimAllUnderlying(uint256 tokenId)
        external
        whenNotPaused
        nonReentrant
    {
        address customer = msg.sender;
        uint256 amount = credit.deleteCREDIT(customer, tokenId);
        globalDepositValue -= amount;
        creds.burn(customer, amount);
        ERC20(tToken).safeTransferFrom(address(this), customer, amount);
        emit Withdrawal(customer, amount);
    }

    function activateEmergency() external onlyOwner whenPaused {
        if (emergencyStatus == emergencyNotActive)
            emergencyStatus = emergencyActive;
    }

    function deactivateEmergency() external onlyOwner {
        if (emergencyStatus == emergencyActive)
            emergencyStatus = emergencyNotActive;
    }

    //same as claimAllUnderlying except customer doesnt need an equal number of creds
    function emergencyWithdraw(uint256 tokenId)
        external
        whenPaused
        nonReentrant
    {
        if (emergencyStatus == emergencyNotActive) revert EmergencyNotActive();
        address customer = msg.sender;
        uint256 amount = credit.deleteCREDIT(customer, tokenId);
        globalDepositValue -= amount;
        ERC20(tToken).safeTransferFrom(address(this), customer, amount);
        emit Withdrawal(customer, amount);
    }

    function _calculateFee(uint256 msgValue) internal view returns (uint256) {
        uint256 adjustedMsgValue = (msgValue * feePercentage) / BASIS_POINTS;
        return adjustedMsgValue;
    }

    function setTreasuryAddress(address payable _newTreasuryAddress)
        external
        onlyOwner
    {
        treasury = _newTreasuryAddress;
    }

    function sendToFeesTreasury() external onlyOwner {
        if (feeToTransfer == 0) revert NoFeesToTransfer();

        uint256 allFees = feeToTransfer;
        feeToTransfer -= allFees;
        ERC20(tToken).safeTransferFrom(address(this), treasury, allFees);
    }

    function setTempusTokenAddress(address _tToken) external onlyOwner {
        tToken = _tToken;
    }

    function adjustCeiling(uint256 _amount) external onlyOwner {
        globalCeiling = _amount;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        if (emergencyStatus == emergencyNotActive) _unpause();
    }
}
