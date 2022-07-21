// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {

    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;

    string public name;
    string public symbol;

    uint8 public decimals = 18;

    constructor(string memory name_, string memory symbol_){
        name = name_;
        symbol = symbol_;
    }

    function transfer(address recipient, uint amount) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}

contract Faucet {

    uint256 public amountAllowed = 100;
    address public tokenContract;
    mapping(address => bool) public requestedAddress;
    mapping(address => mapping(address => uint256)) public lastWithdrawTime;

    event SendToken(address indexed receiver, uint256 indexed amount);

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    function requestTokens() external {
        require(requestedAddress[msg.sender] == false, "Can't Request Multiple Times!");
        IERC20 token = IERC20(tokenContract);
        require(token.balanceOf(address(this)) > amountAllowed, "Faucet Empty!");
        token.transfer(msg.sender, amountAllowed);
        requestedAddress[msg.sender] = true;

        emit SendToken(msg.sender, amountAllowed);

    }

    function withdraw() external {
        IERC20 token = IERC20(tokenContract);
        uint256 withdrawableTime = lastWithdrawTime[msg.sender][tokenContract] + 24 * 60 * 60;
        require(block.timestamp >= withdrawableTime, "time limit");
        IERC20(token).transfer(msg.sender, amountAllowed);
        lastWithdrawTime[msg.sender][tokenContract] = block.timestamp;
    }
}
