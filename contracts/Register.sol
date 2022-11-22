// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @author Simon Samuel
 */

contract Register {
    address public owner;
    uint256 public MIN_AMOUNT = 0.1 ether;

    struct kin {
        // The Contract address of the next of kin.
        address kinAddress;
        // The deposited amount to be sent to the next of kin.
        uint256 kinAmount;
        // The interval for locking the funds in the contract.
        uint256 lockInterval;
        // This checks to see if the user is still alive.
        bool validationOfLife;
        // Sets the max number of times the user can validate life.
        uint16 maxNumberOfConfirmations;
        // Will send kinAmount to kinAddress if this == maxNumberOfConfirmations
        uint16 currNumberOfConfirmations;
    }

    mapping(address => kin) kinship;
    address[] public users;

    event registered();

    // mapping (address => );
    constructor() {
        owner = msg.sender;
    }

    function register(address _kinAddress, uint256 _lockInterval)
        public
        payable
    {
        require(
            msg.value >= MIN_AMOUNT,
            "You have to send a minimum of 0.1 MATIC."
        );
        kinship[msg.sender].kinAddress = _kinAddress;
        kinship[msg.sender].lockInterval = _lockInterval;
        kinship[msg.sender].kinAmount = msg.value;

        users.push(msg.sender);
    }
}
