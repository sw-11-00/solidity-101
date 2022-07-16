// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Four ways to import contracts

// Source file relative location
import "./Doge.sol";

// Import a specific contract via a global symbol
import { Doge } from "./Doge.sol";

// Source file URL import
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol';

// Import via npm's directory
import '@openzeppelin/contracts/access/Ownable.sol';

contract Import {

    using Address for address;

    Doge doge = new Doge();

    function test() external {
        doge.bark();
    }
}
