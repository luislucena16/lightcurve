// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.20;

import {UserOperation} from "@account-abstraction/contracts/interfaces/UserOperation.sol";

// interface for modules to verify singatures signed over userOpHash
interface IAuthorizationModuleHarness {
    /**
     * @dev validates userOperation. Expects userOp.callData to be an executeBatch
     * or executeBatch_y6U call. If something goes wrong, reverts.
     * @param userOp User Operation to be validated.
     * @param userOpHash Hash of the User Operation to be validated.
     * @return validationData SIG_VALIDATION_FAILED or packed validation result.
     */
    function validateUserOp(
        UserOperation calldata userOp,
        bytes32 userOpHash
    ) external returns (uint256 validationData);
}