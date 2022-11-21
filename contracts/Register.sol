// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Register {
    address owner;

    struct kin {
        address kinAddress;
        uint256 kinAmount;
        uint256 lockInterval;
    }

    mapping(address => kin) kinship;

    // mapping (address => );
    constructor() {
        owner = msg.sender;
    }
}
