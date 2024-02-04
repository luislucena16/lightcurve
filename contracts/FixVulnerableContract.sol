// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "contracts/FixVulnerableContractErrors.sol";
import "contracts/FixVulnerableContractStorage.sol";
import "contracts/FixVulnerableContractEvents.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

    /// @title Fixed Version of VulnerableContract
    /// @notice This contract is an improved version that addresses vulnerabilities found in VulnerableContract.
    /// @dev It incorporates reentrancy protection, emits events with additional information, and includes error handling mechanisms.
contract FixVulnerableContract is ReentrancyGuard, FixVulnerableContractEvents, FixVulnerableContractStorage, FixVulnerableContractErrors {
    // The implementation of this contract includes modules for reentrancy protection, events, storage, and error handling.


    /// @dev Modifier that allows only the owner of the contract to call the function.
    modifier onlyOwner() {
    if (msg.sender != owner) revert OnlyOwnerCanCall();
    _;
    }

    /// @notice Contract constructor that initializes the owner to the sender's address.
    /// @dev This constructor is automatically executed upon deployment, setting the initial owner of the contract to the sender's address.
    constructor() {
        owner = msg.sender;
    }

    /// @notice Deposits Ether into the contract, updating the sender's balance.
    /// @dev This function is designed for receiving Ether deposits.
    /// @dev The deposited amount, sent with the transaction, must be greater than zero; otherwise, it reverts with a DepositAmountMustBeGreaterThanZero error.
    function deposit() public payable {
        if (msg.value == 0) revert DepositAmountMustBeGreaterThanZero();
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value, balances[msg.sender]);
    }

    /// @notice Withdraws a specified amount of Ether from the sender's balance.
    /// @dev This function is non-reentrant and includes proper error handling.
    /// @dev Emits a Withdraw event upon successful withdrawal.
    /// @param amount The amount of Ether to withdraw.
    function withdraw(uint256 amount) public nonReentrant {
        if (balances[msg.sender] < amount) revert InsufficientBalanceOrInvalidAmount();
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    /// @notice Transfers ownership of the contract to a new address.
    /// @dev Only the current owner can call this function.
    /// @dev Emits an OwnershipTransferred event upon successful transfer.
    /// @param newOwner The address of the new owner.
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner == address(0)) revert NewOwnerCannotBeZeroAddress();
        if (isContract(newOwner)) revert NewOwnerCannotBeAContract();
        owner = newOwner;
        emit OwnershipTransferred(owner, newOwner);
    }

    //------------------------------------------------
    //                  Assembly
    //------------------------------------------------

    /// @notice Checks whether an address corresponds to a contract or an externally owned account.
    /// @dev This internal function determines if the provided address is associated with a smart contract.
    /// @param account The address to check.
    /// @return True if the address corresponds to a smart contract, false otherwise.
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    //------------------------------------------------
    //                  Getters
    //------------------------------------------------

    /// @notice Retrieves the Ether balance of the calling account.
    /// @dev This function provides the Ether balance associated with the caller's address.
    /// @return The Ether balance of the calling account.
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    /// @notice Retrieves the current owner's address of the contract.
    /// @dev This function provides the address of the current owner.
    /// @return The address of the current owner of the contract.
    function getOwner() public view returns (address) {
        return owner;
    }
}
