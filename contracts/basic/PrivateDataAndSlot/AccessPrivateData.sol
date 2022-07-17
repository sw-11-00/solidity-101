// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    1. https://learnblockchain.cn/books/geth/part7/storage.html 详解SOLIDITY合约数据存储布局
    2. Contract deployed on Ropsten 0x3505a02BCDFbb225988161a95528bfDb279faD6b
    3. Preventative Techniques
        1. Don't store sensitive information on the blockchain.
        2. Encrypt sensitive information
*/
contract Vault {

    /*
        # Storage
        - 2 ** 256 slots
        - 32 bytes for each slot
        - data is stored sequentially in the order of declaration
        - storage is optimized to save space. If neighboring variables fit in a single
          32 bytes, then they are packed into the same slot, starting from the right
    */

    // slot 0
    uint public count = 123; // 32bytes (2 ** 8) * 32
    // slot 1
    address public owner = msg.sender; // 20bytes (2 ** 8) * 20
    bool public isTrue = true; // 1byte
    uint16 public u16 = 31; // 2 bytes (2 ** 8) * 2
    // slot 2
    bytes32 private password;

    // constants dont use storage, hard coded in the contract by code
    uint public constant someConst = 123;
    // slot 3, 4, 5 (one for each array element)
    bytes32[3] public data;
    struct User {
        uint id;
        bytes32 password;
    }
    // slot 6 - storage length of array
    // array elements - starting from slot keccak(6)
    // slot where array element is stored = keccak256(slot)) + (index * elementSize)
    // where slot = 6 and elementSize = 2 (1 (uint) +  1 (bytes32))
    // first user slot keccak(6), second user slot keccak(6) + 2
    User[] private users;
    // slot 7 - empty
    // entries are stored at hash(key, slot)
    // where slot = 7, key = map key
    mapping(uint => User) private idToUser;

    constructor(bytes32 _password) {
        password = _password;
    }

    function addUser(bytes32 _password) public {
        User memory user = User({id:user.length, password:_password});
        users.push(user);
        idToUser[user.id] = user;
    }

    function getArrayLocation(
        uint slot,
        uint index,
        uint elementSize
    ) public pure returns (uint) {
        return uint(keccak256(abi.encodePacked(slot))) + (index * elementSize);
    }

    function getMapLocation(uint slot, uint key) public pure returns (uint) {
        return uint(keccak256(abi.encodePacked(key, slot)));
    }

    // truffle console --network ropsten
    // addr = "0x3505a02BCDFbb225988161a95528bfDb279faD6b"
    // web3.eth.getStorageAt(addr, 0, console.log)
    // parseInt("0x7b", 16)
    // web3.eth.getStorageAt(addr, 2, console.log)
    // web3.utils.toAscii("0x4141414242424343430000000000000000000000000000000000000000000000")

    /*
        slot 6 - array length
        getArrayLocation(6, 0, 2)
        web3.utils.numberToHex("111414077815863400510004064629973595961579173665589224203503662149373724986687")
        Note: We can also use web3 to get data location
        web3.utils.soliditySha3({ type: "uint", value: 6 })
        1st user
        web3.eth.getStorageAt("0x3505a02BCDFbb225988161a95528bfDb279faD6b", "0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f", console.log)
        web3.eth.getStorageAt("0x3505a02BCDFbb225988161a95528bfDb279faD6b", "0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d40", console.log)
        Note: use web3.toAscii to convert bytes32 to alphabet
        2nd user
        web3.eth.getStorageAt("0x3505a02BCDFbb225988161a95528bfDb279faD6b", "0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d41", console.log)
        web3.eth.getStorageAt("0x3505a02BCDFbb225988161a95528bfDb279faD6b", "0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d42", console.log)

        slot 7 - empty
        getMapLocation(7, 1)
        web3.utils.numberToHex("81222191986226809103279119994707868322855741819905904417953092666699096963112")
        Note: We can also use web3 to get data location
        web3.utils.soliditySha3({ type: "uint", value: 1 }, {type: "uint", value: 7})
        user 1
        web3.eth.getStorageAt("0x3505a02BCDFbb225988161a95528bfDb279faD6b", "0xb39221ace053465ec3453ce2b36430bd138b997ecea25c1043da0c366812b828", console.log)
        web3.eth.getStorageAt("0x3505a02BCDFbb225988161a95528bfDb279faD6b", "0xb39221ace053465ec3453ce2b36430bd138b997ecea25c1043da0c366812b829", console.log)
    */
}
