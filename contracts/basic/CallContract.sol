// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract OtherContract {

    uint256 private _x = 0;
    event Log(uint amount, uint gas);

    function getBalance() view public returns (uint) {
        return address(this).balance;
    }

    function setX(uint256 x) external payable {
        _x = x;
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    function getX() external view returns (uint x) {
        x = _x;
    }
}

contract CallContract {

    function callSetX(address _Address, uint256 x) external {
        OtherContract(_Address).setX(x);
    }

    function callGetX(OtherContract _Address) external view returns (uint x) {
        x = _Address.getX();
    }

    function callGetX2(address _Address) external view returns (uint x) {
        OtherContract oc = OtherContract(_Address);
        x = oc.getX();
    }

    function setXTransferETH(address otherContract, uint256 x) payable external {
        OtherContract(otherContract).setX{value:msg.value}(x);
    }
}
