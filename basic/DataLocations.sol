//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Data locations - storage, memory and calldata
// storage是状态变量，memroy是局部变量，calldata只能用在输入的参数中

contract DataLocations {

    struct MyStruct {
        uint foo;
        string text;
    }

    mapping(address => MyStruct) public myStructs;

    function examples() external {
        myStructs[msg.sender] = MyStruct({foo:123, text:"bar"});
        MyStruct storage myStruct = myStructs[msg.sender];
    }
}
