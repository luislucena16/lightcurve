// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <=0.8.20;

/* solhint-disable no-empty-blocks */

import {IBaseAuthorizationModuleHarness} from "./IBaseAuthorizationModuleHarness.sol";
import {AuthorizationModulesConstantsHarness} from "./AuthorizationModulesConstantsHarness.sol";

/// @dev Base contract for authorization modules
abstract contract BaseAuthorizationModuleHarness is
    IBaseAuthorizationModuleHarness,
    AuthorizationModulesConstantsHarness
{

}