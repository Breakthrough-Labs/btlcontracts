// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Capped Token
 * @author Breakthrough Labs Inc.
 * @notice Token, ERC20, Mintable, Capped
 * @custom:version 1.0.7
 * @custom:address 3
 * @custom:default-precision 18
 * @custom:simple-description Token that allows the owner to mint tokens up to the cap.
 * @dev ERC20 token with the following features:
 *
 *  - Premint your total supply.
 *  - Minting is allowed, but only up to the maximum cap.
 *
 */

contract CappedToken is ERC20Capped, Ownable {
    /**
     * @param name Token Name
     * @param symbol Token Symbol
     * @param totalSupply Initial Supply
     * @param cap Maximum Tokens
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        uint256 cap
    ) payable ERC20(name, symbol) ERC20Capped(cap) {
        _mint(msg.sender, totalSupply);
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `to`, increasing
     * the total supply. Only accessible by the contract owner.
     */
    function mint(uint256 amount, address to) external onlyOwner {
        _mint(to, amount);
    }
}
