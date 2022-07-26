//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/*
    The selfdestruct(address) function removes all bytecode from the contract address and sends all ether stored to the specified address.
    If this specified address is also a contract, no functions (including the fallback) get called.

    1. delete contract
    2. force send Ether to any address
*/

contract Kill {

    constructor() payable {}

    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function testCall() external pure returns (uint) {
        return 123;
    }
}

contract Helper {

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function kill(Kill _kill) external {
        _kill.kill();
    }
}
