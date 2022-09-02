// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "../base/Royalty.sol";

/**
 * @title Voting ERC20 Token
 * @author Breakthrough Labs Inc.
 * @notice Token, ERC20, Voting, Fixed
 * @custom:version 1.0.4
 * @custom:default-precision 18
 * @custom:simple-description Fixed supply ERC20 with additional functions to allow
 * voting on connected Governance/DAO proposals.
 * @dev ERC20 token, including:
 *
 *  - Methods that allow token owners to vote on Governance/DAO proposals.
 *  - Preminted initial supply.
 *  - No minting capabilities. Token supply is fixed.
 *
 * Used alongside Governance/DAO contracts for voting.
 *
 */

contract VotingToken is ERC20, ERC20Permit, ERC20Votes, Royalty {
    /**
     * @param name Token Name
     * @param symbol Token Symbol
     * @param totalSupply Initial Supply
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) payable ERC20(name, symbol) ERC20Permit(name) {
        _mint(msg.sender, totalSupply);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}
