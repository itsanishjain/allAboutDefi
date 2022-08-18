// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakeLabsRewardToken is ERC20 {
    uint8 constant _decimals = 18;
    uint256 constant _totalSupply = 100 * (10**6) * 10**_decimals; // 100m tokens for distribution

    constructor() ERC20("StakeLabsRewardToken", "SLRT") {
        _mint(msg.sender, _totalSupply);
    }
}
