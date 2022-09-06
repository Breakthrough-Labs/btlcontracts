// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SCR Deploy using create
 * @author Breakthrough Labs Inc.
 * @notice Utility
 * @custom:version Experimental.1
 * @custom:address 1
 * @custom:default-precision 0
 * @custom:simple-description Smart Contract Recipes Deployer
 * @dev Smart Contract Recipes Deployer
 *
 */
contract SCRDeploy is Ownable {
    event Deploy(address indexed deployer, address indexed deployment);

    function deployContract(bytes memory bytecode)
        external
        payable
        returns (address)
    {
        address deployedAddress;
        require(bytecode.length != 0, "Create: bytecode length is zero");
        assembly {
            deployedAddress := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        require(deployedAddress != address(0), "Create: Failed on deploy");
        emit Deploy(msg.sender, deployedAddress);
        return deployedAddress;
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
