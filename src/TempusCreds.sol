// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

import "solmate/tokens/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TempusCreds is ERC20("Tempus DAI Creds", "tDAICreds", 18), Ownable {
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(address customer, uint256 amount) public onlyOwner {
        _burn(customer, amount);
    }
}
