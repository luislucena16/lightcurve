// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

abstract contract FixVulnerableContractEvents {
    event Deposit(address indexed account, uint256 amount, uint256 newBalance);
    event Withdraw(address indexed account, uint256 amount);
    event OwnershipTransferred(address indexed owner, address indexed newOwner);
}
