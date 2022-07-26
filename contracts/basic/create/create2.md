**CREATE2 是一个可以在合约中创建合约的操作码。**



根据官方 [EIP 文档](https://eips.ethereum.org/EIPS/eip-1014)，create2 一共接收四个参数，分别是：

1. endowment（创建合约时往合约中打的 ETH 数量）
2. memory_start（代码在内存中的起始位置，一般固定为 **add(bytecode, 0x20)** ）
3. memory_length（代码长度，一般固定为 **mload(bytecode)** ）
4. salt（随机数盐）

这里要注意的是第一个参数如果大于 0 的话，需要待部署合约的构造方法带有 **payable**。随机数盐是由用户自定，须为 **bytes32** 格式。

```solidity
bytes32 salt = keccak256(abi.encodePacked(token0, token1));
```



**create2 还有一个优点，相较于以前的 new 创建合约方法。**





### 实现

https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Create2.sol

```solidity
pragma solidity 0.8.10;

import "@openzeppelin/contracts/utils/Create2.sol";

contract Factory {
    event Deployed(address addr);

    function getAddress() public view returns (address) {
        return
            Create2.computeAddress(
                keccak256("Here is salt"),
                keccak256(
                    abi.encodePacked(type(Template).creationCode, abi.encode(3))
                )
            );
    }

    function deploy() public {
        address addr = Create2.deploy(
            0,
            keccak256("Here is salt"),
            abi.encodePacked(type(Template).creationCode, abi.encode(3))
        );
        emit Deployed(addr);
    }
}

contract Template {
    uint256 public a;

    constructor(uint256 _a) {
        a = _a;
    }
}
```

对于构造函数有参数的情况，需要将参数编码并拼接在合约字节码后面作为完整的字节码传入。

```solidity
abi.encodePacked(type(Template).creationCode, abi.encode(3))
```

构造方法参数的编码是如何确定的？

```solidity
contract NamedCoffeeCoin {
    constructor(string memory _symbol, string memory _name, address _to) {
        ...
    }
    ...
}
```

一共有3个参数。如果我们希望传入`COFFEE`、`Cappuccino`以及`0x32ABb0DD3BC57d6406d3F499ccaa761996F4ddBb`，就需要把这3个参数编码。这里我们使用一个能在线编码的网页[https://abi.hashex.org](https://abi.hashex.org/)，直接输入构造方法参数，直接把编码后的构造方法参数复制出来即可。(https://www.liaoxuefeng.com/article/1430588932227106)