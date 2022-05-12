// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

//import IERC20
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//import AAVE interface
//import VOLTZ interface
//import ownable
import "@openzeppelin/contracts/access/Ownable.sol";

interface IaToken {
    function balanceOf(address _user) external view returns (uint256);

    function redeem(uint256 _amount) external;
}

interface IAaveLendingPool {
    function deposit(
        address _reserve,
        uint256 _amount,
        uint16 _referralCode
    ) external;
}

//interface for Voltz

contract HedgeHog is Ownable {
    error NotEnoughFunds();
    //customer deposits TrueUSD into contract
    //contract deposits TrueUSD into AAVE
    //contract receives aTrueUSD
    //contract deposits aTrueUSD into VOLTZ
    //contract recieves fixed position tokens
    //contract wraps fixed position tokens
    //contracts enables customer to withdraw wrapped tokens less fee

    IERC20 public trueUSD = IERC20(0x016750AC630F711882812f24Dba6c95b9D35856d);

    IERC20 public aTrueUSD = IERC20(0x39914AdBe5fDbC2b9ADeedE8Bcd444b20B039204);

    IAaveLendingPool public aaveLendingPool =
        IAaveLendingPool(0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe);

    //address public constant VOLTZ_FCM_ADDRESS = 0xEe83DE30b0Be486Ebd4E6D9153A9DbcB83dEec5D;
    address public immutable wrappedToken;

    constructor(address _wrappedToken) {
        wrappedToken = _wrappedToken;
        trueUSD.approve(address(aaveLendingPool), type(uint256).max);
    }

    function depositTrueUSD(uint256 amount) external returns (uint256) {
        if (amount > trueUSD.balanceOf(msg.sender)) revert NotEnoughFunds();
        trueUSD.transferFrom(msg.sender, address(this), amount);
        // ...
        return amount;
    }

    function withdrawWrappedTokens(uint256 amount) internal returns (uint256) {
        IERC20(wrappedToken).transferFrom(address(this), msg.sender, amount);
        return amount;
    }

    //function interactWithAAVE internal
    //function interactWithVoltz internal
    //function interactWithTokenWrapper internal
}
