// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@aave/periphery-v3/contracts/misc/interfaces/IWrappedTokenGatewayV3.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract YieldAggregator {
    using SafeERC20 for IERC20;

    address aWETHTokenAddress = 0x685bF4eab23993E94b4CFb9383599c926B66cF57;
    IERC20 aWETH = IERC20(aWETHTokenAddress);

    address WETHGateWayAddress = 0x2a58E9bbb5434FdA7FF78051a4B82cb0EF669C17;
    IWrappedTokenGatewayV3 WETHGateWay =
        IWrappedTokenGatewayV3(WETHGateWayAddress);

    IPoolAddressesProvider poolAddressProvider =
        IPoolAddressesProvider(0x5343b5bA672Ae99d627A1C87866b8E53F47Db2E6);

    address public poolAddress = poolAddressProvider.getPool();

    event suppliedMatic(address user, uint256 when);
    event withdrawnMatic(address user, uint256 when);

    function depositMatic(uint256 amount) public {
        WETHGateWay.depositETH{value: amount}(poolAddress, msg.sender, 0);
        emit suppliedMatic(msg.sender, block.timestamp);
    }

    function withdrawMatic(uint256 amount, address kin) public {
        aWETH.approve(WETHGateWayAddress, amount);
        WETHGateWay.withdrawETH(poolAddress, amount, kin);
        emit withdrawnMatic(kin, block.timestamp);
    }
}
