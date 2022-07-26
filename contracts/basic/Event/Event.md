# Events

Solidity中记录事件的工具，即日志。两个优点：一是能够利用较少的Gas就能将数据记录在区块链上，二是可以方便链下对链上数据进行监听。

```solidity
// Events日志包含topic和data，最多包含4个topic，data没有限制

// top[0]
keccak256(bytes("Transfer(address,address,uint256)")) // 事件签名
// topic可以方便检索，每个topic只能容纳32字节的数据

// data是abi-encoded的结果
```

日志的基础费用是 375 Gas。另外每个 `topic` 同样需要花费 375 Gas，`data` 中每个字节需要花费 8 Gas。