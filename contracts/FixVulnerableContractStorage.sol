// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

abstract contract FixVulnerableContractStorage {
    mapping(address => uint256) internal balances;
    address internal owner;
}
