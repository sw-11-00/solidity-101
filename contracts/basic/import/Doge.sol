// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Doge {
    event Log(string msg);

    function bark() public virtual{
        emit Log("barkkkkkkkkkk!!!!");
    }

    function bark1() public virtual{
        emit Log("barkkkkkkkkkk!!!!");
    }

    function bark2() public virtual {
        emit Log("barkkkkkkkkkk!!!!");
    }
}