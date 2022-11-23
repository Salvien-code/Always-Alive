// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @author Simon Samuel
 */
contract AlwaysAlive {
    address public owner;
    uint256 public lastTimeStamp;

    uint256 public MIN_AMOUNT = 0.001 ether;
    uint8 public MAX_NUMBER_OF_CONFIRMATIONS = 5;

    uint16 private HOURLY_INTERVAL = 60 * 60;
    uint32 private DAILY_INTERVAL = 24 * 60 * 60;

    struct kin {
        address kinAddress;
        uint256 kinAmount;
        bool validationOfLife;
        uint8 currNumberOfConfirmations;
    }

    mapping(address => kin) kinship;
    address[] public activeUsers;
    address[] public nullUsers;

    event registered(string message, address user, uint256 when);
    event invested(string message, address kin, uint256 when);
    event blessed(string message, address kin, uint256 when);

    constructor() payable {
        owner = msg.sender;
        lastTimeStamp = block.timestamp;
    }

    modifier onlyUsers(address _user) {
        bool notNullUser = false;
        for (uint8 i = 0; i < nullUsers.length; i++) {
            if (nullUsers[i] == _user) {
                notNullUser = true;
            }
        }
        require(!notNullUser, "User cannot register twice!");

        bool activeUser = false;
        for (uint8 i = 0; i < activeUsers.length; i++) {
            if (activeUsers[i] == _user) {
                activeUser = true;
            }
        }
        require(activeUser, "User is not registered!");
        _;
    }

    // =====    REGISTRATION SECTION   =====
    /**
     * @param _kinAddress The address of the kin that the contract pays deposited funds to.
     */
    function register(address _kinAddress) public payable {
        require(msg.value >= MIN_AMOUNT, "Minimum Registration is 0.1 MATIC");

        kinship[msg.sender].currNumberOfConfirmations = 0;
        kinship[msg.sender].kinAddress = _kinAddress;
        kinship[msg.sender].validationOfLife = true;
        kinship[msg.sender].kinAmount = msg.value;

        activeUsers.push(msg.sender);
        emit registered(
            "Successfully registered for Always Alive Contract",
            msg.sender,
            block.timestamp
        );
    }

    // =====    INVESTMENT SECTION     =====
    function invest() public {}

    // =====    BLESSING SECTION       =====
    function bless() public {}

    // =====    HELPERS SECTION        =====
}
