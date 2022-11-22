// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bless {
    constructor() {}
}

interface register {
    struct kin {
        address kinAddress; // The Contract address of the next of kin.
        uint256 kinAmount; // The deposited amount to be sent to the next of kin.
        uint256 interval; // The interval for before requestion for a validation of life from the user.
        bool validationOfLife; // This checks to see if the user is still alive.
        uint16 maxNumberOfConfirmations; // Sets the max number of times the user can validate life. Defaults to 5 if input exceeds 5
        uint16 currNumberOfConfirmations; // Will send kinAmount to kinAddress if this == maxNumberOfConfirmations
    }
}
