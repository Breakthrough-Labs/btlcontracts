// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Pausable Token
 * @author Breakthrough Labs Inc.
 * @notice Token, ERC20, Pausable, Fixed
 * @custom:version 1.0.7
 * @custom:address 6
 * @custom:default-precision 18
 * @custom:simple-description Token with a fixed total supply, that allows
 * the owner to pause/unpause transfers - primarily in the case of a problem.
 * @dev ERC20 token with the following features:
 *
 *  - Premint your total supply.
 *  - No minting function. This allows users to comfortably know the future supply of the token.
 *  - Methods that allow the owner to pause or unpause token transfers.
 *
 * Useful as an emergency stop button in the case of a large bug/problem.
 *
 */

contract PausableToken is ERC20, Pausable, Ownable {
    /**
     * @param name Token Name
     * @param symbol Token Symbol
     * @param totalSupply Initial Supply
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) payable ERC20(name, symbol) {
        _mint(msg.sender, totalSupply);
    }

    /**
     * @dev Pauses the token, preventing any transfers. Only callable by the contract owner.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses the token, allowing transfers to occur again. Only callable by the contract owner.
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }
}
