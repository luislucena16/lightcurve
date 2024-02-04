// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "contracts/FixVulnerableContractStorage.sol";
import "contracts/FixVulnerableContractEvents.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract FixVulnerableContract is ReentrancyGuard, FixVulnerableContractEvents, FixVulnerableContractStorage {

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        require(msg.value > 0, "Deposit amount must be greater than 0");
        emit Deposit(msg.sender, msg.value, balances[msg.sender]);
    }

    function withdraw(uint256 amount) public nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance or invalid amount");

        balances[msg.sender] -= amount;

        payable(msg.sender).transfer(amount);

        emit Withdraw(msg.sender, amount);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be zero address");
        require(!isContract(newOwner), "New owner cannot be a contract");

        owner = newOwner;
        emit OwnershipTransferred(owner, newOwner);
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}
