// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Token Vesting
 * @author Breakthrough Labs Inc.
 */

contract TokenVesting is Ownable {
    struct Vest {
        uint256 amount;
        uint256 claimed;
        uint256 start;
        uint256 end;
        bool cancellable;
    }

    IERC20 public token;
    mapping(address => Vest) public vests;

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
    }

    function createVest(
        address to,
        uint256 amount,
        uint256 start,
        uint256 end,
        bool cancellable
    ) external onlyOwner {
        Vest storage vest = vests[to];
        require(vest.amount == 0, "Account is already vested.");
        vest.amount = amount;
        vest.claimed = 0;
        vest.start = block.timestamp + 2629746 * start;
        vest.end = block.timestamp + 2629746 * end;
        vest.cancellable = cancellable;
        token.transferFrom(_msgSender(), address(this), amount);
    }

    function cancelVest(address account) external onlyOwner {
        Vest storage vest = vests[account];
        require(vest.cancellable, "Cannot cancel."); // will also fail on nonexistent vests
        uint256 totalReleased = _totalReleased(vest);
        uint256 claimable = totalReleased - vest.claimed;
        uint256 locked = vest.amount - totalReleased;
        vest.amount = 0;
        // Avoid re-entrancy attacks by doing all the transfers last
        token.transfer(_msgSender(), locked);
        token.transfer(account, claimable);
    }

    function claim() external {
        address account = _msgSender();
        Vest storage vest = vests[account];
        uint256 totalReleased = _totalReleased(vest);
        uint256 amount = totalReleased - vest.claimed;
        require(amount > 0, "Nothing to claim.");
        vest.claimed = totalReleased;
        // Avoid re-entrancy attacks by doing the transfer last
        token.transfer(account, amount);
    }

    function getTotalVested(address account) external view returns (uint256) {
        Vest storage vest = vests[account];
        require(vest.amount != 0, "Account is not vested.");
        return vest.amount;
    }

    function getClaimable(address account) external view returns (uint256) {
        Vest storage vest = vests[account];
        return _totalReleased(vest) - vest.claimed;
    }

    function getLocked(address account) external view returns (uint256) {
        Vest storage vest = vests[account];
        return vest.amount - _totalReleased(vest);
    }

    function _totalReleased(Vest storage vest) private view returns (uint256) {
        require(vest.amount != 0, "Account is not vested.");
        if (block.timestamp <= vest.start) return 0;
        if (block.timestamp >= vest.end) return vest.amount;
        return
            (vest.amount * (block.timestamp - vest.start)) /
            (vest.end - vest.start);
    }
}
