以太坊智能合约中，函数选择器是函数签名 `"<function name>(<function input types>)"` 的哈希值的前`4`个字节（`8`位十六进制）。当用户调用合约的函数时，`calldata`的前`4`字节就是目标函数的选择器，决定了调用哪个函数。

由于函数选择器只有`4`字节，非常短，很容易被碰撞出来：即我们很容易找到两个不同的函数，但是他们有着相同的函数选择器。比如`transferFrom(address,address,uint256)`和`gasprice_bit_ether(int128)`有着相同的选择器：`0x23b872dd`。当然你也可以写个脚本暴力破解。

可以用这两个网站来查同一个选择器对应的不同函数：

1. https://www.4byte.directory/
2. https://sig.eth.samczsun.com/

你也可以使用下面的`Power Clash`工具进行暴力破解：

1. PowerClash: https://github.com/AmazingAng/power-clash

相比之下，钱包的公钥有`256`字节，被碰撞出来的概率几乎为`0`，非常安全。



## 漏洞合约例子

### 漏洞合约

```solidity
contract SelectorClash {
    bool public solved; // 攻击是否成功

    // 攻击者需要调用这个函数，但是调用者 msg.sender 必须是本合约。
    function putCurEpochConPubKeyBytes(bytes memory _bytes) public {
        require(msg.sender == address(this), "Not Owner");
        solved = true;
    }

    // 有漏洞，攻击者可以通过改变 _method 变量碰撞函数选择器，调用目标函数并完成攻击。
    function executeCrossChainTx(bytes memory _method, bytes memory _bytes, bytes memory _bytes1, uint64 _num) public returns(bool success){
        (success, ) = address(this).call(abi.encodePacked(bytes4(keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))), abi.encode(_bytes, _bytes1, _num)));
    }
}
```

`SelectorClash`合约有`1`个状态变量 `solved`，初始化为`false`，攻击者需要将它改为`true`。合约主要有`2`个函数，函数名沿用自 Poly Network 漏洞合约。

1. `putCurEpochConPubKeyBytes()` ：攻击者调用这个函数后，就可以将`solved`改为`true`，完成攻击。但是这个函数检查`msg.sender == address(this)`，因此调用者必须为合约本身，我们需要看下其他函数。
2. `executeCrossChainTx()` ：通过它可以调用合约内的函数，但是函数参数的类型和目标函数不太一样：目标函数的参数为`(bytes)`，而这里调用的函数参数为`(bytes,bytes,uint64)`

### 攻击方法

利用`executeCrossChainTx()`函数调用合约中的`putCurEpochConPubKeyBytes()`，目标函数的选择器为：`0x41973cd9`。观察到`executeCrossChainTx()`中是利用`_method`参数和`"(bytes,bytes,uint64)"`作为函数签名计算的选择器。因此，我们只需要选择恰当的`_method`，让这里算出的选择器等于`0x41973cd9`，通过选择器碰撞调用目标函数。

Poly Network黑客事件中，黑客碰撞出的`_method`为 `f1121318093`，即`f1121318093(bytes,bytes,uint64)`的哈希前`4`位也是`0x41973cd9`，可以成功的调用函数。接下来我们要做的就是将`0x41973cd9`转换为`bytes`类型：`0x6631313231333138303933`，然后作为参数输入到`executeCrossChainTx()`中。`executeCrossChainTx()`函数另`3`个参数不重要，都填 `0x` 就可以。



**管理好合约函数的权限，确保拥有特殊权限的合约的函数不能被用户调用。**

