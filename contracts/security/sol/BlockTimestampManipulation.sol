pragma solidity ^0.8.0;

contract Roulette {

    constructor() public payable {}

    function spin() external payable {
        require(msg.value >= 1 ether);
        if (block.timestamp % 7 == 0) {
            (bool sent, ) = msg.sender.call{value:address(this)}("");
            require(sent, "Failed to send Ether");
        }
    }
}
