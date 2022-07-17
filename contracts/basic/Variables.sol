pragma solidity ^0.8.0;

/*
    1. local
        declared inside a function
        not stored on the blockchain
    2. state
        declared outside a function
        stored on the blockchain
    3. global (provides information about the blockchain)
*/
contract Variables {

    // State variables are stored on the blockchain.
    string public text = "Hello";
    uint public num = 123;

    function doSomething() public {
        uint i = 456;
        uint timestamp = block.timestamp;
        address sender = msg.sender;
    }
}
