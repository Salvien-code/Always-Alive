// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @author Simon Samuel
 */
contract AlwaysAlive {
    address public owner;
    uint256 private lastHourStamp;
    uint256 private lastDayStamp;

    uint256 public MIN_AMOUNT = 0.001 ether;
    uint8 public MAX_NUMBER_OF_CONFIRMATIONS = 5;

    uint16 private HOURLY_INTERVAL = 60 * 60;
    uint32 private DAILY_INTERVAL = 24 * 60 * 60;

    struct kin {
        address kinAddress;
        uint256 kinAmount;
        bool paidKin;
        bool validationOfLife;
        uint8 currNumberOfConfirmations;
    }

    mapping(address => kin) kinship;
    address[] public users;

    // Core Events
    event registered(string message, address user, uint256 when);
    event invested(string message, address kin, uint256 when);
    event blessed(string message, address kin, uint256 when);

    // Timed Events
    event incrementedConfirmations(string message, uint256 when);
    event paidDailyProfits(string message, address kin, uint256 when);
    event deposited(string message, address payer, uint256 amount);

    constructor() payable {
        owner = msg.sender;
        lastHourStamp = block.timestamp;
        lastDayStamp = block.timestamp;
    }

    modifier onlyUsers(address _user) {
        bool activeUser = false;
        for (uint8 i = 0; i < users.length; i++) {
            if (users[i] == _user) {
                activeUser = true;
            }
        }
        require(activeUser, "User is not registered!");
        _;
    }

    modifier canRegisterOnlyOnce(address _user) {
        bool alreadyRegistered = false;
        for (uint8 i = 0; i < users.length; i++) {
            if (users[i] == _user) {
                alreadyRegistered = true;
            }
        }
        require(!alreadyRegistered, "User is already registered!");
        _;
    }

    // =====    REGISTRATION SECTION   =====
    /**
     * @param _kinAddress The address of the kin that the contract pays deposited funds to.
     */
    function register(address _kinAddress)
        public
        payable
        canRegisterOnlyOnce(msg.sender)
    {
        require(msg.value >= MIN_AMOUNT, "Minimum Registration is 0.1 MATIC");

        kinship[msg.sender].currNumberOfConfirmations = 0;
        kinship[msg.sender].kinAddress = _kinAddress;
        kinship[msg.sender].paidKin = false;
        kinship[msg.sender].validationOfLife = true;
        kinship[msg.sender].kinAmount = msg.value;

        users.push(msg.sender);
        emit registered(
            "Successfully registered for Always Alive Contract",
            msg.sender,
            block.timestamp
        );
    }

    // =====    INVESTMENT SECTION     =====
    function invest() public {
        require(
            (block.timestamp - lastDayStamp) > DAILY_INTERVAL,
            "Not up to a Day!"
        );

        // Sends balance to AAVE and collects profit for the day.
    }

    // =====    BLESSING SECTION       =====
    function bless() public {
        require(
            (block.timestamp - lastDayStamp) > DAILY_INTERVAL,
            "Not up to a Day!"
        );
        for (uint8 i = 0; i < users.length; i++) {
            if (
                kinship[users[i]].validationOfLife == true &&
                kinship[users[i]].paidKin == false
            ) {
                (bool sent, ) = kinship[users[i]].kinAddress.call{
                    value: kinship[users[i]].kinAmount
                }("");
                require(sent, "Failed to send blessings.");
            }
        }
    }

    // =====    HELPERS SECTION        =====
    function validateLife() public onlyUsers(msg.sender) {
        kinship[msg.sender].currNumberOfConfirmations = 0;
    }

    function deposit() public payable {
        emit deposited("Recieved some MATIC", msg.sender, msg.value);
    }

    function incrementConfirmations() public {
        require(
            (block.timestamp - lastHourStamp) > HOURLY_INTERVAL,
            "Not up to an hour!"
        );

        lastHourStamp = block.timestamp;

        for (uint8 i = 0; i < users.length; i++) {
            kinship[users[i]].currNumberOfConfirmations++;
            if (
                kinship[users[i]].currNumberOfConfirmations >
                MAX_NUMBER_OF_CONFIRMATIONS
            ) {
                kinship[users[i]].validationOfLife = false;
            }
        }

        emit incrementedConfirmations(
            "Incremented confirmations for all users",
            block.timestamp
        );
    }

    function getCurrentConfirmations(address _user)
        public
        view
        onlyUsers(_user)
        returns (uint8)
    {
        return kinship[_user].currNumberOfConfirmations;
    }

    receive() external payable {
        emit deposited("Received some MATIC", msg.sender, msg.value);
    }

    fallback() external payable {
        emit deposited("Received some MATIC", msg.sender, msg.value);
    }
}
