// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Assembly {

    function add(uint a, uint b) public pure returns (uint) {
        assembly {
            let sum := add(a, b)
            mstore(0x0, sum)
            return (0x0, 32)
        }
    }

    function call(uint a) public pure returns (uint) {
        bytes4 sig = bytes4(keccak256("call(uint)"));
        assembly {
            mstore(0x0, sig)
            let addressData := add(0x0, 4)
            mstore(addressData, a)
            return (addressData, 32)
        }
    }
}
