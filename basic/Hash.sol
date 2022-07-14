pragma solidity ^0.8.0;

/*
        Keccak256(Cryptographic Hash Function)
        - function that takes in arbitrary size input and ouputs a data of fixed size
        - properties
            - deterministic
                - hash(x) = h, every time
            - quick to compute the hash
            - irreversible
                - given h, hard to find x such that hash(x) = h
            - small change in input changes the output significantly
            - collision resistant
                - hard to find x, y such that hash(x) = hash(y)
    */

contract Hash {

    function hash(string memory _text, uint _num, address _addr) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_text, _num, _addr));
    }

    // Example of hash collision
    // Hash collision can occur when you pass more than one dynamic data type
    // to abi.encodePacked. In such case, you should use abi.encode instead.
    function collision(string memory _text, string memory _anotherText) public pure returns (bytes32) {
        // encodePacked(AAA, BBB) -> AAABBB
        // encodePacked(AA, ABBB) -> AAABBB
        return keccak256(abi.encodePacked(_text, _anotherText));
    }
}

contract GuessTheMagicWorld {

    bytes32 public answer = 0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;

    function guess(string memory _word) public view returns (bool) {
        return keccak256(abi.encodePacked(_word)) == answer;
    }
}
