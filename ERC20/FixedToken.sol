// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../base/Royalty.sol";

/**
 * @title Basic ERC20 Token
 * @author Breakthrough Labs Inc.
 * @notice Token, ERC20, Fixed Supply
 * @custom:version 1.0.4
 * @custom:default-precision 18
 * @custom:simple-description Standard ERC20. A fixed supply is minted on deployment, and
 * new tokens can never be created.
 * @dev ERC20 token, including:
 *
 *  - Preminted initial supply.
 *  - No minting capabilities. Token supply is fixed.
 *
 */

contract FixedToken is ERC20, Royalty {
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
