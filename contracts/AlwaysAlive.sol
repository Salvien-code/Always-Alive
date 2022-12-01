// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./YieldAggregator.sol";
import "./VRFConsumer.sol";
import "./SignatureVerifier.sol";

/**
 * @author Simon Samuel
 */
contract AlwaysAlive is VRFConsumer, YieldAggregator, SignatureVerifier {
    // Registration Constants
    int8 public MAX_NUMBER_OF_CONFIRMATIONS = 5;
    uint256 public MIN_AMOUNT = 0.001 ether;

    // Interval Constants
    uint64 private INCREMENT_CONFIRMATION_INTERVAL = 6 * 60 * 60;
    uint64 private REQUEST_RANDOM_NUMBER_INTERVAL = 24 * 60 * 60;
    uint64 private INHERIT_INTERVAL = 3 * 24 * 60 * 60;
    uint64 private BLESS_INTERVAL = 24 * 60 * 60;

    // Tracking Variables
    uint256 private lastIncrementStamp;
    uint256 private lastInheritStamp;
    uint256 private lastBlessStamp;
    address public lastBlessedKin;
    uint256 private lastVRFStamp;
    uint256 public lastBlessPayout;

    // User Data
    struct Kin {
        address payable kinAddress;
        uint256 kinAmount;
        bool paidKin;
        bool validationOfLife;
        bool signed;
        int8 currNumberOfConfirmations;
    }

    mapping(address => Kin) kinship;
    address[] public users;

    // Events for logging
    event blessed(address kin, uint256 amount, uint256 when);
    event inheritered(address kin, uint256 when);
    event registered(address user, uint256 when);
    event incrementedConfirmations(uint256 when);

    constructor(uint64 _subscriptionId) payable VRFConsumer(_subscriptionId) {
        lastIncrementStamp = block.timestamp;
        lastInheritStamp = block.timestamp;
        lastBlessStamp = block.timestamp;
        lastVRFStamp = block.timestamp;
    }

    // Helpful Modifiers
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
     * @param signature Signature proving that user has authorized contract.
     */
    function register(address payable _kinAddress, bytes memory signature)
        public
        payable
        canRegisterOnlyOnce(msg.sender)
        kinMustBeAnEOA(_kinAddress)
    {
        require(msg.value >= MIN_AMOUNT, "Minimum Registration is 0.001 MATIC");
        require(verify(msg.sender, signature), "Not a valid signature!");

        kinship[msg.sender].currNumberOfConfirmations = 0;
        kinship[msg.sender].kinAddress = _kinAddress;
        kinship[msg.sender].validationOfLife = true;
        kinship[msg.sender].kinAmount = msg.value;
        kinship[msg.sender].paidKin = false;
        kinship[msg.sender].signed = true;

        users.push(msg.sender);
        emit registered(msg.sender, block.timestamp);
    }

    // =====    BLESSING SECTION     =====
    function bless() public view {
        require(
            (block.timestamp - lastBlessStamp) > BLESS_INTERVAL,
            "Not up to a Day!"
        );

        // Sends balance to AAVE and collects profit for the day.
    }

    // =====    INHERITANCE SECTION       =====
    /**
     * @dev This function is called by chainlink automation every 3 days.
     * It transfers deposited funds to next of kin if validation of life is false.
     */

    function inherit() public {
        require(
            (block.timestamp - lastInheritStamp) > INHERIT_INTERVAL,
            "Not up to 6 hours!"
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
     * @dev This function is called by Chainlink Automation and
     * increases the Confirmations of all users that are still alive
     * every hour.
     */
    function incrementConfirmations() public {
        require(
            (block.timestamp - lastIncrementStamp) >
                INCREMENT_CONFIRMATION_INTERVAL,
            "Not up to 6 hours!"
        );

        lastIncrementStamp = block.timestamp;

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

    /**
     * @dev Resets the current confirmation of the user to 0.
     * Thereby assuring the protocol the user is still alive.
     */

    function validateLife() public onlyUsers(msg.sender) {
        kinship[msg.sender].currNumberOfConfirmations = 0;
    }

    // =====    GETTERS SECTION        =====
    /**
     * @dev Returns current Confirmation counts if user is alive but
     * -1 is user is not.
     */
    function getCurrentConfirmations(address _user)
        external
        view
        onlyUsers(_user)
        returns (int8)
    {
        if (kinship[_user].validationOfLife) {
            return kinship[_user].currNumberOfConfirmations;
        } else {
            return -1;
        }
    }

    function getLastBlessedKin() external view returns (address) {
        return lastBlessedKin;
    }

    function getLastPayout() external view returns (uint256) {
        return lastBlessPayout;
    }

    receive() external payable {}

    fallback() external payable {}
}
