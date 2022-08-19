// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakeLabsRewardToken is ERC20, Ownable {
    uint8 constant _decimals = 18;
    uint256 constant _totalSupply = 100 * (10**7) * 10**_decimals; // 1B tokens for distribution

    constructor() ERC20("StakeLabsRewardToken", "SLRT") {
        _mint(msg.sender, _totalSupply);
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount * 1e18);
    }
}
