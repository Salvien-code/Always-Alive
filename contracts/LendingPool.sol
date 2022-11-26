// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/core-v3/contracts/interfaces/IPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract YieldAggregator {
    using SafeERC20 for IERC20;

    IPoolAddressesProvider poolAddressProvider =
        IPoolAddressesProvider(0x178113104fEcbcD7fF8669a0150721e231F0FD4B);
    address poolAddress = poolAddressProvider.getPool();
    IPool pool = IPool(poolAddress);

    address owner;

    constructor() {
        owner = msg.sender;
    }

    event suppliedAsset(address user, uint256 when);

    function depositAsset(address asset, uint256 amount) public {
        IERC20(asset).safeApprove(address(pool), amount);
        pool.supply(asset, amount, msg.sender, 0);
        emit suppliedAsset(msg.sender, block.timestamp);
    }
}
