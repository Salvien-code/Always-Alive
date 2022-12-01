// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VRFConsumer is VRFConsumerBaseV2, ConfirmedOwner {
    mapping(uint256 => RequestStatus) public requests;
    VRFCoordinatorV2Interface COORDINATOR;

    uint64 subscriptionId;

    uint256[] public requestIds;
    uint256 public lastRequestId;

    bytes32 keyHash =
        0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f;

    uint32 callbackGasLimit = 2_000_000;

    uint16 requestConfirmations = 3;

    uint32 numWords = 5;

    struct RequestStatus {
        bool fulfilled;
        bool exists;
        uint256[] randomWords;
    }

    bool activated = false;

    // Chainlink Events
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    constructor(uint64 _subscriptionId)
        VRFConsumerBaseV2(0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed)
        ConfirmedOwner(msg.sender)
    {
        COORDINATOR = VRFCoordinatorV2Interface(
            0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed
        );
        subscriptionId = _subscriptionId;
    }

    function requestRandomWords()
        external
        onlyOwner
        returns (uint256 requestId)
    {
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(requests[_requestId].exists, "request not found");
        requests[_requestId].fulfilled = true;
        requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);

        // Section for paying random kin profit
    }

    function getRequestStatus(uint256 _requestId)
        external
        view
        returns (bool fulfilled, uint256[] memory randomWords)
    {
        require(requests[_requestId].exists, "request not found");
        RequestStatus memory request = requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }
}
