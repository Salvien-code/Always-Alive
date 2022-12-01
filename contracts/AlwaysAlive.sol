// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./YieldAggregator.sol";
import "./VRFConsumer.sol";
import "./SignatureVerifier.sol";

/**
 * @author Simon Samuel
 */
contract AlwaysAlive {
    // Registration Constants
    int8 public MAX_NUMBER_OF_CONFIRMATIONS = 5;
    uint256 public MIN_AMOUNT = 0.001 ether;
    uint256 public MAX_AMOUNT = 1 ether;

    // Interval Constants
    uint64 private INCREMENT_CONFIRMATION_INTERVAL = 3 * 60 * 60;
    uint64 private REQUEST_RANDOM_NUMBER_INTERVAL = 6 * 60 * 60;
    uint64 private INHERIT_INTERVAL = 12 * 60 * 60;
    uint64 private BLESS_INTERVAL = 6 * 60 * 60;

    // Helper Contracts
    VRFConsumer Consumer;
    YieldAggregator Aggregator;
    SignatureVerifier Verifier;

    // Tracking Variables
    uint256 private totalDepositedFunds;
    uint256 private lastIncrementStamp;
    uint256 private lastInheritStamp;
    uint256 private lastBlessStamp;
    uint256 public lastBlessPayout;
    address public lastBlessedKin;
    uint256 private lastVRFStamp;
    uint256 private lastVRFId;

    // User Data
    struct Kin {
        address payable kinAddress;
        uint256 kinAmount;
        bool paidKin;
        bool validationOfLife;
        bytes signature;
        int8 currNumberOfConfirmations;
    }

    mapping(address => Kin) kinship;
    address[] public users;

    // Events
    event blessed(address kin, uint256 amount, uint256 when);
    event inheritered(address kin, uint256 when);
    event registered(address user, uint256 when);
    event incrementedConfirmations(uint256 when);

    constructor(uint64 _subscriptionId) payable {
        Consumer = new VRFConsumer(_subscriptionId);
        Verifier = new SignatureVerifier();
        Aggregator = new YieldAggregator();

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
        require(
            msg.value <= MAX_AMOUNT,
            "Cannot register with more than 1 MATIC"
        );

        // TODO: Get Signature verification to work
        // require(
        //     Verifier.verify(msg.sender, signature),
        //     "Not a valid signature!"
        // );

        kinship[msg.sender].currNumberOfConfirmations = 0;
        kinship[msg.sender].kinAddress = _kinAddress;
        kinship[msg.sender].validationOfLife = true;
        kinship[msg.sender].kinAmount = msg.value;
        kinship[msg.sender].paidKin = false;
        kinship[msg.sender].signature = signature;

        // Transfers Registration MATIC to AAVE.
        Aggregator.depositMatic{value: msg.value}(msg.value);
        totalDepositedFunds += msg.value;
        users.push(msg.sender);

        emit registered(msg.sender, block.timestamp);
    }

    // =====    BLESSING SECTION     =====
    /**
     * @dev This function is called at 12 Midnight everyday
     * and sends profit from AAVE to a random Next of kin.
     */
    function bless() public payable {
        require(
            (block.timestamp - lastBlessStamp) > BLESS_INTERVAL,
            "Not up to a Day!"
        );

        (bool fulfilled, uint256[] memory randomWords) = Consumer
            .getRequestStatus(lastVRFId);

        require(fulfilled, "Random Words not received!");

        // Selects a random index of the RandomWords
        uint256 randomIndex = block.timestamp % randomWords.length;

        // Selects a random winner based on the selected random number
        uint256 randomWinnerIndex = randomWords[randomIndex] % users.length;
        address kin = kinship[users[randomWinnerIndex]].kinAddress;

        // Sends 90% of the earned yield to a the kin.
        uint256 profit = Aggregator.calculateMatic(totalDepositedFunds);
        uint256 blessingAmount = (profit * 9) / 10;

        (bool sent, ) = kin.call{value: blessingAmount}("");
        require(sent, "Failed to bless kin.");

        lastBlessPayout = blessingAmount;
        lastBlessedKin = kin;

        emit blessed(kin, blessingAmount, block.timestamp);
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
                totalDepositedFunds -= kinship[users[i]].kinAmount;
                kinship[users[i]].paidKin = true;

                emit inheritered(kinship[users[i]].kinAddress, block.timestamp);
            }
        }
    }

    // =====    HELPERS SECTION        =====
    /**
     * @dev This function requests 5 random numbers at 12 Noon everyday and stores them.
     */
    function requestRandomness() public {
        require(
            (block.timestamp - lastVRFStamp) > REQUEST_RANDOM_NUMBER_INTERVAL,
            "Not up to a Day!"
        );
        lastVRFId = Consumer.requestRandomWords();
    }

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

    function getConsumerAddress() external view returns (address) {
        return address(Consumer);
    }

    function getVerifierAddress() external view returns (address) {
        return address(Verifier);
    }

    function getAggregatorAddress() external view returns (address) {
        return address(Aggregator);
    }

    receive() external payable {}

    fallback() external payable {}
}
