// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

abstract contract FixVulnerableContractEvents {
    /*** Events ***/

    /// @notice Emitted when a deposit is made.
    /// @param account The address of the account making the deposit.
    /// @param amount The amount of Ether deposited.
    /// @param newBalance The new balance of the account after the deposit.
    event Deposit(address indexed account, uint256 amount, uint256 newBalance);

    /// @notice Emitted when a withdrawal is made.
    /// @param account The address of the account making the withdrawal.
    /// @param amount The amount of Ether withdrawn.
    event Withdraw(address indexed account, uint256 amount);

    /// @notice Emitted when ownership of the contract is transferred.
    /// @param owner The current owner's address before the transfer.
    /// @param newOwner The address of the new owner after the transfer.
    event OwnershipTransferred(address indexed owner, address indexed newOwner);
}
