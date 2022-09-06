// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Subscription NFT
 * @author Breakthrough Labs Inc.
 */

abstract contract SubscriptionNFT is ERC721, Ownable {
    using Strings for uint256;
    using Address for address payable;

    // Potential optimization: store price per second instead of price per year
    uint256 public subscriptionPrice;
    mapping(uint256 => uint256) public expireTime;
    string public tokenUriA;
    string public tokenUriB;

    constructor(
        string memory name,
        string memory symbol,
        string memory activeURI,
        string memory inactiveURI,
        uint256 initialSubscriptionPrice
    ) ERC721(name, symbol) {
        tokenUriA = activeURI;
        tokenUriB = inactiveURI;
        subscriptionPrice = initialSubscriptionPrice;
    }

    function isActive(uint256 tokenId) public view returns (bool) {
        return expireTime[tokenId] > block.timestamp;
    }

    function refillSubscription(uint256 tokenId) external payable {
        require(_exists(tokenId), "Invalid token ID");
        require(msg.value > 0, "Cannot refill with 0 time.");

        // 31,556,952 seconds in a year. 365.2425 days
        uint256 time = (msg.value * 31556952) / subscriptionPrice;
        if (isActive(tokenId)) expireTime[tokenId] += time;
        else expireTime[tokenId] = block.timestamp + time;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId), "ERC721: invalid token ID");

        string memory baseURI = isActive(tokenId) ? tokenUriA : tokenUriB;
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }

    function setActiveURI(string memory uri) external onlyOwner {
        tokenUriA = uri;
    }

    function setInactiveURI(string memory uri) external onlyOwner {
        tokenUriB = uri;
    }

    function setSubscriptionPrice(uint256 annualPrice) external onlyOwner {
        subscriptionPrice = annualPrice;
    }

    function ownerWithdraw(uint256 amount) external onlyOwner {
        payable(_msgSender()).sendValue(amount);
    }

    function mint(address to, uint256 id) external onlyOwner {
        _mint(to, id);
    }
}
