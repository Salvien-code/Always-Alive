// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@aave/periphery-v3/contracts/misc/interfaces/IWrappedTokenGatewayV3.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/core-v3/contracts/interfaces/IAToken.sol";

/**
 * @author Simon Samuel
 * @notice We can't earn yield on the AAVE testnet so I can not integrate this into
 * the always alive protocol. Will send equivalent profit from the Always Alive contract
 * instead.
 */
contract YieldAggregator {
    address aMATICAddress = 0x89a6AE840b3F8f489418933A220315eeA36d11fF;
    IAToken aMATIC = IAToken(aMATICAddress);

    address WETHGateWayAddress = 0x2a58E9bbb5434FdA7FF78051a4B82cb0EF669C17;
    IWrappedTokenGatewayV3 WETHGateWay =
        IWrappedTokenGatewayV3(WETHGateWayAddress);

    IPoolAddressesProvider poolAddressProvider =
        IPoolAddressesProvider(0x5343b5bA672Ae99d627A1C87866b8E53F47Db2E6);

    address poolAddress;

    constructor() {
        poolAddress = poolAddressProvider.getPool();
    }

    event suppliedMatic(address user, uint256 when);
    event withdrawnMatic(address user, uint256 when);
    event approvedMatic(address spender, uint256 amount);

    function depositMatic(uint256 amount) public payable {
        WETHGateWay.depositETH{value: amount}(poolAddress, msg.sender, 0);
        emit suppliedMatic(msg.sender, block.timestamp);
    }

    function calculateMatic(uint256 totalDepositedAmount)
        public
        view
        returns (uint256)
    {
        uint256 profit = aMATIC.balanceOf(msg.sender) - totalDepositedAmount;
        return profit;

        // bool approved = aMATIC.approve(WETHGateWayAddress, amount);
        // require(approved, "Could not approve.");
        // emit approvedMatic(WETHGateWayAddress, amount);
        // WETHGateWay.withdrawETH(poolAddress, amount, kin);
        // emit withdrawnMatic(kin, block.timestamp);
    }
}
