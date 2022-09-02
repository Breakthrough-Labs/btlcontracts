// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../base/Royalty.sol";

/**
 * @title Burnable ERC20 Token
 * @author Breakthrough Labs Inc.
 * @notice Token, ERC20, Burnable
 * @custom:version 1.0.4
 * @custom:default-precision 18
 * @custom:simple-description ERC20 that allows token holders to destroy tokens
 * in a way that can be recognized off-chain.
 * @dev ERC20 token, including:
 *
 *  - Preminted initial supply.
 *  - No minting capabilities. Token supply cannot increase.
 *  - Methods that allow users to burn their tokens. This directly decreases total supply.
 *
 * Used to transparently remove tokens from the supply.
 *
 */

contract BurnableToken is ERC20Burnable, Royalty {
    /**
     * @param name Token Name
     * @param symbol Token Symbol
     * @param totalSupply Token Supply
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) payable ERC20(name, symbol) {
        _mint(msg.sender, totalSupply);
    }
}
