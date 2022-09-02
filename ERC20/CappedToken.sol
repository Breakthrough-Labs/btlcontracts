// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../base/Royalty.sol";

/**
 * @title Capped ERC20 Token
 * @author Breakthrough Labs Inc.
 * @notice Token, ERC20, Mintable, Capped
 * @custom:version 1.0.4
 * @custom:default-precision 18
 * @custom:simple-description ERC20 that allows the owner to mint additional tokens while
 * the token supply is below the cap.
 * @dev ERC20 token, including:
 *
 *  - Preminted initial supply.
 *  - Minting is allowed, but total supply cannot exceed the cap.
 *
 */

contract CappedToken is ERC20Capped, Ownable, Royalty {
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
