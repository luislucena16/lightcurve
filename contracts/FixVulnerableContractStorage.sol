// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

abstract contract FixVulnerableContractStorage {
     /*** Storage ***/

    /// @notice Mapping of account addresses to their corresponding Ether balances in the contract.
    /// @dev This internal mapping stores the Ether balances associated with different account addresses.
    mapping(address => uint256) internal balances;

    /// @notice The address representing the owner of the contract.
    /// @dev This internal variable holds the address of the owner who has control over the contract.
    address internal owner;
}
