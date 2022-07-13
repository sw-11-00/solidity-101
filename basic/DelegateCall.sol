//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract B {

    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {

    uint public num;
    address public sender;
    uint public value;

    function setValue(address _contract, uint _num) public payable {
//        (bool success, bytes memory data) = _contract.delegatecall(
//            abi.encodeWithSignature("setVars(uint256)", _num)
//        );
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSelect(B.setVars.selector, _num)
        );
        require(success, "delegatecall fail");
    }
}
