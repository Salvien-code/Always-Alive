// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./YieldAggregator.sol";
import "./VRFConsumer.sol";

/**
 * @author Simon Samuel
 */
contract AlwaysAlive is YieldAggregator, VRFConsumer {
    address public lastBlessedKin;

    uint256 private lastHourStamp;
    uint256 private lastDayStamp;
    uint256 private lastWeekStamp;

    uint256 public MIN_AMOUNT = 0.001 ether;
    uint8 public MAX_NUMBER_OF_CONFIRMATIONS = 5;

    uint16 private HOURLY_INTERVAL = 60 * 60;
    uint32 private DAILY_INTERVAL = 24 * 60 * 60;
    uint64 private WEEKLY_INTERVAL = 7 * 24 * 60 * 60;

    struct Kin {
        address payable kinAddress;
        uint256 kinAmount;
        bool paidKin;
        bool validationOfLife;
        uint8 currNumberOfConfirmations;
    }

    mapping(address => Kin) kinship;
    address[] public users;

    // Core Events
    event registered(address user, uint256 when);
    event inheritered(address kin, uint256 when);
    event blessed(address kin, uint256 when);

    // Timed Events
    event incrementedConfirmations(uint256 when);
    event paidDailyProfits(address kin, uint256 when);
    event deposited(address payer, uint256 amount);

    constructor(uint64 _subscriptionId)
        payable
        YieldAggregator()
        VRFConsumer(_subscriptionId)
    {
        lastHourStamp = block.timestamp;
        lastDayStamp = block.timestamp;
        lastWeekStamp = block.timestamp;
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
        require(!alreadyRegistered, "Already registered!");
        _;
    }

    modifier kinMustBeAnEOA(address _kin) {
        uint size;
        assembly {
            size := extcodesize(_kin)
        }
        require(size == 0, "Kin Address cannot be a smart contract!");
        _;
    }

    // =====    REGISTRATION SECTION   =====
    /**
     * @param _kinAddress The address of the kin that the contract pays deposited funds to.
     */
    function register(address payable _kinAddress)
        public
        payable
        canRegisterOnlyOnce(msg.sender)
        kinMustBeAnEOA(_kinAddress)
    {
        require(msg.value >= MIN_AMOUNT, "Minimum Registration is 0.001 MATIC");

        kinship[msg.sender].currNumberOfConfirmations = 0;
        kinship[msg.sender].kinAddress = _kinAddress;
        kinship[msg.sender].paidKin = false;
        kinship[msg.sender].validationOfLife = true;
        kinship[msg.sender].kinAmount = msg.value;

        users.push(msg.sender);
        emit registered(msg.sender, block.timestamp);
    }

    // =====    BLESSING SECTION     =====
    function bless() public view {
        require(
            (block.timestamp - lastWeekStamp) > WEEKLY_INTERVAL,
            "Not up to a Week!"
        );

        // Sends balance to AAVE and collects profit for the day.
    }

    // =====    INHERITANCE SECTION       =====
    /**
     * @dev This function is called by chainlink automation every 24 hours.
     * It transfers deposited funds to next of kin if validation of life is false.
     */

    function inherit() public {
        require(
            (block.timestamp - lastDayStamp) > DAILY_INTERVAL,
            "Not up to a Day!"
        );
        for (uint8 i = 0; i < users.length; i++) {
            if (
                kinship[users[i]].validationOfLife == false &&
                kinship[users[i]].paidKin == false
            ) {
                (bool sent, ) = kinship[users[i]].kinAddress.call{
                    value: kinship[users[i]].kinAmount
                }("");
                require(sent, "Failed to send Inheritance to kin.");
                kinship[users[i]].paidKin = true;

                emit inheritered(kinship[users[i]].kinAddress, block.timestamp);
            }
        }
    }

    // =====    HELPERS SECTION        =====
    /**
     * @dev Resets the current confirmation of the user to 0.
     * Thereby assuring the protocol the user is still alive.
     */
    function validateLife() public onlyUsers(msg.sender) {
        kinship[msg.sender].currNumberOfConfirmations = 0;
    }

    /**
     * @dev This function is called by Chainlink Automation and
     * increases the Confirmations of all users that are still alive
     * every hour.
     */
    function incrementConfirmations() public {
        require(
            (block.timestamp - lastHourStamp) > HOURLY_INTERVAL,
            "Not up to an hour!"
        );

        lastHourStamp = block.timestamp;

        for (uint8 i = 0; i < users.length; i++) {
            if (kinship[users[i]].validationOfLife) {
                kinship[users[i]].currNumberOfConfirmations++;
            }

            if (
                kinship[users[i]].currNumberOfConfirmations >
                MAX_NUMBER_OF_CONFIRMATIONS
            ) {
                kinship[users[i]].validationOfLife = false;
            }
        }

        emit incrementedConfirmations(block.timestamp);
    }

    function getCurrentConfirmations(address _user)
        external
        view
        onlyUsers(_user)
        returns (uint8)
    {
        return kinship[_user].currNumberOfConfirmations;
    }

    function getLastBlessedKin() external view returns (address) {
        return lastBlessedKin;
    }

    receive() external payable {
        emit deposited(msg.sender, msg.value);
    }

    fallback() external payable {
        emit deposited(msg.sender, msg.value);
    }
}
