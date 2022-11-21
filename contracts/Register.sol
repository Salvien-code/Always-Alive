// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Register {
    address public owner;
    uint256 public MIN_AMOUNT = 0.1 ether;

    struct kin {
        address kinAddress;
        uint256 kinAmount;
        uint256 lockInterval;
    }

    mapping(address => kin) kinship;

    event registered();

    // mapping (address => );
    constructor() {
        owner = msg.sender;
    }

    function register() public payable {
        require(
            msg.value >= MIN_AMOUNT,
            "You have to send a minimum of 0.1 MATIC."
        );
    }
}
