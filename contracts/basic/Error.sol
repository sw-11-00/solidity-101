pragma solidity ^0.8.0;

// 可以像 event 那样定义一个错误类型，同时可以节省 gas，并且可以在错误信息中添加参数
contract TestToken {
    error InsufficientBalance(uint256 available, uint256 required);

    mapping(address => uint) balance;

    function transfer(address to, uint256 amount) public {
        if (amount > balance[msg.sender])
            revert InsufficientBalance({
            available : balance[msg.sender],
            required : amount
            });
        balance[msg.sender] -= amount;
        balance[to] += amount;
    }
    // ...
}
