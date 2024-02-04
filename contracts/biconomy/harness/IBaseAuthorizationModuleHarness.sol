// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IAuthorizationModuleHarness} from "./IAuthorizationModuleHarness.sol";
import {ISignatureValidatorHarness} from "./ISignatureValidatorHarness.sol";

/* solhint-disable no-empty-blocks */
interface IBaseAuthorizationModuleHarness is
    IAuthorizationModuleHarness,
    ISignatureValidatorHarness
{

}