//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// fallback function

// function doesn't exist
// directly send eth

/*
  fallback() or receive() ?
      Ether is sent to contract
            is msg.data empty ?
                 /         \
                yes        no
               /            \
      receive() exists?   fallback()
             /      \
           yes      no
           /         \
      receive()   fallback()

      receive函数只负责接受主币
*/
contract Fallback {

    event Log(string func, address sender, uint value, bytes data);

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    function test() returns (uint s){
        return 1;
    }


}
