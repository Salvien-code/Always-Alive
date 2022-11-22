// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @author Simon Samuel
 */

contract Register {
    address public owner;
    uint256 public MIN_AMOUNT = 0.1 ether;

    struct kin {
        address kinAddress; // The Contract address of the next of kin.
        uint256 kinAmount; // The deposited amount to be sent to the next of kin.
        uint256 interval; // The interval for before requestion for a validation of life from the user.
        bool validationOfLife; // This checks to see if the user is still alive.
        uint16 maxNumberOfConfirmations; // Sets the max number of times the user can validate life. Defaults to 5 if input exceeds 5
        uint16 currNumberOfConfirmations; // Will send kinAmount to kinAddress if this == maxNumberOfConfirmations
    }

    mapping(address => kin) kinship;
    address[] public users;

    event registered(string message, uint256 when);

    constructor() {
        owner = msg.sender;
    }

    /**
     * @param _kinAddress: Contract Address of the Next of Kin that receives the deposited tokens.
     * @param _interval: Specifies the interval between each validation of life, (Month or Hourly).
     * @param _maxNumberOfConfirmations: Contract will transfer funds to kin if currNumberOfConfirmations == MaxNumberOfConfirmations.
     *
     */
    function register(
        address _kinAddress,
        uint256 _interval,
        uint8 _maxNumberOfConfirmations
    ) public payable {
        require(
            msg.value >= MIN_AMOUNT,
            "You have to send a minimum of 0.1 MATIC."
        );

        // Calls a signing function [Signature]

        // Populates kinship

        kinship[msg.sender].kinAddress = _kinAddress;
        kinship[msg.sender].interval = _interval;
        kinship[msg.sender].kinAmount = msg.value;

        kinship[msg.sender].currNumberOfConfirmations = 0;
        kinship[msg.sender].validationOfLife = true;
        if (_maxNumberOfConfirmations < 5) {
            kinship[msg.sender]
                .maxNumberOfConfirmations = _maxNumberOfConfirmations;
        } else {
            kinship[msg.sender].maxNumberOfConfirmations = 5;
        }

        // Pays for gas for paying kin [Gasless transaction]
        users.push(msg.sender);

        emit registered("Successfully registered", block.timestamp);
    }
}
