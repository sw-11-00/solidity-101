创建`provider`和`wallet`。用的`provider`是WebSocket Provider，更持久的监听交易。因此，我们需要将`url`换成`wss`的。

```javascript
console.log("\n1. 连接 wss RPC")
// 准备 alchemy API 可以参考https://github.com/AmazingAng/WTFSolidity/blob/main/Topics/Tools/TOOL04_Alchemy/readme.md 
const ALCHEMY_RINKEBY_WSSURL = 'wss://eth-mainnet.g.alchemy.com/v2/oKmOQKbneVkxgHZfibs-iFhIlIAl6HDN';
const provider = new ethers.providers.WebSocketProvider(ALCHEMY_RINKEBY_WSSURL);
```

因为`mempool`中的未决交易很多，每秒上百个，很容易达到免费`rpc`节点的请求上限，因此我们需要用`throttle`限制请求频率。

```javascript
function throttle(fn, delay) {
    let timer;
    return function(){
        if(!timer) {
            fn.apply(this, arguments)
            timer = setTimeout(()=>{
                clearTimeout(timer)
                timer = null
            },delay)
        }
    }
}
```

监听`mempool`的未决交易，并打印交易哈希。

```javascript
provider.on("pending", async (txHash) => {
    if (txHash && i < 100) {
        // 打印txHash
        console.log(`[${(new Date).toLocaleTimeString()}] 监听Pending交易 ${i}: ${txHash} \r`);
        i++
        }
});
```

通过未决交易的哈希，获取交易详情。我们看到交易还未上链，它的`blockHash`，`blockNumber`，和`transactionIndex`都为空。但是我们可以获取到交易的发送者地址`from`，燃料费`gasPrice`，目标地址`to`，发送的以太数额`value`，发送数据`data`等等信息。机器人就是利用这些信息进行`MEV`挖掘的。

```javascript
let j = 0
provider.on("pending", throttle(async (txHash) => {
    if (txHash && i >= 100) {
        // 获取tx详情
        let tx = await provider.getTransaction(txHash);
        console.log(`\n[${(new Date).toLocaleTimeString()}] 监听Pending交易 ${j}: ${txHash} \r`);
        console.log(tx);
        j++
        }
}, 1000));
```

