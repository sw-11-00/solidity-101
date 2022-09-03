以太坊节点有一个`eth_call`方法，让用户可以模拟一笔交易，并返回可能的交易结果，但不真正在区块链上执行它（交易不上链）。



在`ethers.js`中你可以利用`contract`对象的`callStatic()`来调用以太坊节点的`eth_call`。如果调用成功，则返回`ture`；如果失败，则报错并返回失败原因。方法：

```solidity
const tx = await contract.callStatic.函数名( 参数, {override})
console.log(`交易会成功吗？：`, tx)
```

- 函数名：为模拟调用的函数名。
- 参数：调用函数的参数。
- {override}：选填，可包含一下参数：
  - `from`：执行时的`msg.sender`，也就是你可以模拟任何一个人的调用，比如V神。
  - `value`：执行时的`msg.value`。
  - `blockTag`：执行时的区块高度。
  - `gasPrice`
  - `gasLimit`
  - `nonce`



 