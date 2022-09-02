// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../base/ERC721A.sol";
import "../base/Royalty.sol";

/**
 * @title ERC721A NFT and Sale
 * @author Breakthrough Labs Inc.
 * @notice NFT, Sale, ERC721, ERC721A
 * @custom:version 1.0.4
 * @custom:default-precision 0
 * @custom:simple-description An ERC721A NFT implemention with a built in sale. ERC721A
 * is an improved implementation of the IERC721 standard that supports minting multiple
 * tokens for close to the cost of one.
 * @dev ERC721A is an improved implementation of the IERC721 standard that supports minting multiple tokens for close to the cost of one. This implementation includes:
 *
 *  - Built-in sale mechanism with an adjustable price.
 *  - Reserve function for the owner to mint free NFTs.
 *  - Fixed maximum supply.
 *
 */

contract StandardERC721A is ERC721A, Ownable, Royalty {
    bool public saleIsActive = false;
    string private _baseURIextended;

    uint256 public immutable MAX_SUPPLY;
    /// @custom:precision 18
    uint256 public currentPrice;
    uint256 public walletLimit;

    /**
     * @param _name NFT Name
     * @param _symbol NFT Symbol
     * @param _uri Token URI used for metadata
     * @param price Initial Price | precision:18
     * @param maxSupply Maximum # of NFTs
     */
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _uri,
        uint256 price,
        uint256 maxSupply
    ) payable ERC721A(_name, _symbol) {
        _baseURIextended = _uri;
        currentPrice = price;
        MAX_SUPPLY = maxSupply;
    }

    /**
     * @dev An external method for users to purchase and mint NFTs. Requires that the sale
     * is active, that the minted NFTs will not exceed the `MAX_SUPPLY`, and that a
     * sufficient payable value is sent.
     * @param amount The number of NFTs to mint.
     */
    function mint(uint256 amount) external payable {
        uint256 ts = totalSupply();

        require(saleIsActive, "Sale must be active to mint tokens");
        require(ts + amount <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(
            currentPrice * amount == msg.value,
            "Value sent is not correct"
        );

        _safeMint(msg.sender, amount);
    }

    /**
     * @dev A way for the owner to reserve a specifc number of NFTs without having to
     * interact with the sale.
     * @param to The address to send reserved NFTs to.
     * @param amount The number of NFTs to reserve.
     */
    function reserve(address to, uint256 amount) external onlyOwner {
        uint256 ts = totalSupply();
        require(ts + amount <= MAX_SUPPLY, "Purchase would exceed max tokens");
        _safeMint(to, amount);
    }

    /**
     * @dev A way for the owner to withdraw all proceeds from the sale.
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    /**
     * @dev Sets whether or not the NFT sale is active.
     * @param isActive Whether or not the sale will be active.
     */
    function setSaleIsActive(bool isActive) external onlyOwner {
        saleIsActive = isActive;
    }

    /**
     * @dev Sets the price of each NFT during the initial sale.
     * @param price The price of each NFT during the initial sale | precision:18
     */
    function setCurrentPrice(uint256 price) external onlyOwner {
        currentPrice = price;
    }

    /**
     * @dev Updates the baseURI that will be used to retrieve NFT metadata.
     * @param baseURI_ The baseURI to be used.
     */
    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }
}
