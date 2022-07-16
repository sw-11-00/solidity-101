pragma solidity ^0.8.0;

contract Overload {
    /*
        Solidity allows functions to be overloaded, that is, functions with the same name
        but different input parameter types can exist at the same time, and they are regarded
        as different functions. Note that solidity does not allow modifier overloading.
    */
    function saySomething() public pure returns (string memory){
        return ("Nothing");
    }

    function saySomething(string memory something) public pure returns (string memory){
        return (something);
    }

    function f(uint8 _in) public pure returns (uint8 out) {
        out = _in;
    }

    function f(uint256 _in) public pure returns (uint256 out) {
        out = _in;
    }
}
