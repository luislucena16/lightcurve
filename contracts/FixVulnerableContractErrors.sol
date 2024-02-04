// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

abstract contract FixVulnerableContractErrors {
    // Owner
    
    /// @notice Indicates that only the owner is allowed to call this function.
    error OnlyOwnerCanCall();

    // Despoit

    /// @notice Indicates that the deposit amount must be greater than zero.
    error DepositAmountMustBeGreaterThanZero();

    // Withdraw

    /// @notice Indicates that the operation failed due to insufficient balance or an invalid amount.
    error InsufficientBalanceOrInvalidAmount();

    // Transfer Ownership

    /// @notice NewOwnerCannotBeZeroAddress The new owner's address cannot be the zero address.
    error NewOwnerCannotBeZeroAddress();

    /// @notice NewOwnerCannotBeAContract The new owner cannot be a contract address.
    error NewOwnerCannotBeAContract();
}
