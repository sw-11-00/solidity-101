pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * 释放的代币可以是一种，也可以是多种。释放周期由起始时间`_start`和时长`_duration`定义。
 * 所有转到这个合约上的代币都会遵循同样的线性释放周期，并且需要受益人调用`release()`函数提取。
 * 合约是从openzepplin的VestingWallet简化而来。
 */

contract TokenVesting {
    event ERC20Released(address indexed token, uint256 amount); // 提币事件

    mapping(address => uint256) public erc20Released; // 受益人已领取的代币数量
    address public immutable beneficiary;
    uint256 public immutable start;
    uint256 public immutable duration;

    constructor(
        address beneficiaryAddress,
        uint256 durationSeconds
    ) {
        require(beneficiaryAddress != address(0), "VestingWallet: beneficiary is zero address");
        beneficiary = beneficiaryAddress;
        start = block.timestamp;
        duration = durationSeconds;
    }

    function release(address token) public {
        uint256 releasable = vestedAmount(token, uint256(block.timestamp)) - erc20Released[token];
        erc20Released[token] += releasable;
        emit ERC20Released(token, releasable);
        IERC20(token).transfer(beneficiary, releasable);
    }

    function vestedAmount(address token, uint256 timestamp) public view returns (uint256) {
        uint256 totalAllocation = IERC20(token).balanceOf(address(this)) + erc20Released[token];
        if (timestamp < start) {
            return 0;
        } else if (timestamp > start + duration) {
            return totalAllocation;
        } else {
            return (totalAllocation * (timestamp - start)) / duration;
        }
    }
}
