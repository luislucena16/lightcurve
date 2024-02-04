// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {UserOperationHarness} from "../aa-harness/UserOperationHarness.sol";
import {EcdsaOwnershipRegistryModuleHarness} from "./harness/EcdsaOwnershipRegistryModuleHarness.sol";
import {UserOperationLibHarness} from "../aa-harness/UserOperationHarness.sol";
import {MerkleProofHarness} from "./../oz-harness/MerkleProofHarness.sol";
import {_packValidationData} from "@account-abstraction/contracts/core/Helpers.sol";

/**
 * @title ECDSA Multichain Validator module for Biconomy Smart Accounts.
 * @dev Biconomy’s Multichain Validator module enables use cases which
 * require several actions to be authorized for several chains with just one
 * signature required from user.
 * - Leverages Merkle Trees to efficiently manage large datasets
 * - Inherits from the ECDSA Ownership Registry Module
 * - Compatible with Biconomy Modular Interface v 0.1
 * - Does not introduce any additional security trade-offs compared to the
 *   vanilla ERC-4337 flow.
 * @author Fil Makarov - <filipp.makarov@biconomy.io>
 */
contract BiconomyPoC is EcdsaOwnershipRegistryModuleHarness {
    using UserOperationLibHarness for UserOperationHarness;
    
    // Event emitted when user transaction limit is exceeded
    event TransactionLimitExceeded(address indexed user, uint256 transactionCount, uint256 limit);

    // Variables to store user limits
    mapping(address => uint256) internal userSpendingLimits;
    
    // Transaction counter per user to limit daily transactions
    uint256 private userTransactionCount;

    // Modify the limit and limit transactions
    uint256 constant internal TRANSACTION_LIMIT = 10;

    /**
    * @dev Modifier to validate user spending limit.
    * @param sender The address of the user.
    * @param spentAmount The amount to be spent.
    * Requirements:
    * - User spending limit must be either uninitialized or greater than or equal to the spent amount.
    */
    modifier validateSpendingLimit(address sender, uint256 spentAmount) {
    require(userSpendingLimits[sender] == 0 || userSpendingLimits[sender] >= spentAmount, "User spending limit exceeded");
    _;
    }

    /**
    * @dev Modifier to validate transaction limit.
    * Requirements:
    * - User transaction count plus one must be less than or equal to the transaction limit.
    */
    modifier validateTransactionLimit() {
    require(userTransactionCount + 1 <= TRANSACTION_LIMIT, "Transaction limit exceeded");
    _;
    }

    /**
    * @dev Validates a user operation, ensuring it meets spending and transaction limits.
    * The validation involves checking the user's spending limit, transaction limit, and the signature.
    * The signature can be either a single-chain signature or a multi-chain signature, validated using a Merkle tree.
    * @param userOp The user operation to be validated.
    * @param userOpHash The hash of the user operation provided by the entry point.
    * @return status The validation status:
    * - 0: Successful validation.
    * - 1: Signature validation failed.
    * - 2: Invalid user operation.
    */
    function validateUserOp(
        UserOperationHarness calldata userOp,
        bytes32 userOpHash
        // spentAmount, validateSpendingLimit and validateTransactionLimit are values added for the PoC
    ) external validateSpendingLimit(msg.sender, userOp.spentAmount) validateTransactionLimit returns (uint256) {
        (bytes memory moduleSignature, ) = abi.decode(
            userOp.signature,
            (bytes, address)
        );

        address sender;
        // read sender from userOp, which is the first userOp member (saves gas)
        assembly {
            sender := calldataload(userOp)
        }

        if (moduleSignature.length == 65) {
            // it's not a multichain signature
            return _verifySignature(
                userOpHash,
                moduleSignature,
                address(uint160(sender))
            ) ? VALIDATION_SUCCESS : SIG_VALIDATION_FAILED;
        }

        // otherwise it is a multichain signature
        (
            uint48 validUntil,
            uint48 validAfter,
            bytes32 merkleTreeRoot,
            bytes32[] memory merkleProof,
            bytes memory multichainSignature
        ) = abi.decode(
                moduleSignature,
                (uint48, uint48, bytes32, bytes32[], bytes)
            );

        // make a leaf out of userOpHash, validUntil, and validAfter
        bytes32 leaf = keccak256(
            abi.encodePacked(validUntil, validAfter, userOpHash)
        );

        // Verify the Merkle proof
        // This MerkleProofHarness was created to use in the PoC
        if (!MerkleProofHarness.verify(merkleProof, merkleTreeRoot, leaf)) {
            revert("Invalid UserOp");
        }

        // Check spending limit
        // This condition was created to use in the PoC (userSpendingLimits, spentAmount)
        if (userSpendingLimits[sender] > 0 && userSpendingLimits[sender] < userOp.spentAmount) {
            revert("User spending limit exceeded");
        }

        // Check transaction limit per day
        // This condition was created to use in the PoC (userTransactionCount, TRANSACTION_LIMIT, event TransactionLimitExceeded)
        if (userTransactionCount + 1 > TRANSACTION_LIMIT) {
            emit TransactionLimitExceeded(sender,userTransactionCount + 1, TRANSACTION_LIMIT);
            revert("Transaction limit exceeded");
        }

        // Increment transaction count for the user
        // This increment was added for the PoC use
        userTransactionCount ++;

        // Verify the multi-chain signature
        return _verifySignature(
            merkleTreeRoot,
            multichainSignature,
            address(uint160(sender))
        ) ? _packValidationData(
            false, // sigVerificationFailed = false
            validUntil,
            validAfter
        ) : SIG_VALIDATION_FAILED;
    }
}
