// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiCall {

    function multiCall(address[] calldata targets, bytes[] calldata data)
        external view returns (bytes[] memory) {
        require(targets.length == data.length, "target length != data length");
        bytes[] memory results = new bytes[](data.length);
        for (uint i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = result;
        }

        return results;
    }
}

contract TestMultiCall {

    function test(uint _i) external pure returns (uint) {
        return _i;
    }

    function getData(uint _i) external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.test.Selector, _i);
    }
}
