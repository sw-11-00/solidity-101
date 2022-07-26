// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    In Solidity any address can be casted into specific contract, even if the contract
    at the address is not the one being casted. This can be exploited to hide malicious code.
*/

contract Bar {
    event Log(string message);

    function log() public {
        emit Log("Bar was called");
    }
}

contract Foo {
    Bar bar;

    constructor(address _bar) {
        bar = Bar(_bar);
    }

    function callBar() public {
        bar.log();
    }
}

// in a seperate file
contract Mal {

    event Log(string message);

    // function () external {
    //     emit Log("Mal was called");
    // }

    // Actually we can execute the same exploit even if this function does
    // not exist by using the fallback
    function log() public {
        emit Log("Mal was called");
    }
}
