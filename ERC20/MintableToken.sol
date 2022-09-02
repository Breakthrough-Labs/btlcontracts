// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../base/Royalty.sol";

/**
 * @title Mintable ERC20 Token
 * @author Breakthrough Labs Inc.
 * @notice Token, ERC20, Mintable
 * @custom:version 1.0.4
 * @custom:default-precision 18
 * @custom:simple-description ERC20 that allows the owner to mint additional tokens. There
 * is no cap on the total supply.
 * @dev ERC20 token, including:
 *
 *  - Preminted initial supply.
 *  - Minting is allowed. There is no cap on the total supply.
 *  - Only the contract owner can mint new tokens.
 *
 */

contract MintableToken is ERC20, Ownable, Royalty {
    /**
     * @param name Token Name
     * @param symbol Token Symbol
     * @param initialSupply Initial Supply
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) payable ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `to`, increasing
     * the total supply. Only accessible by the contract owner.
     */
    function mint(uint256 amount, address to) external onlyOwner {
        _mint(to, amount);
    }
}
