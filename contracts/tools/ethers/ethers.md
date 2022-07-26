```javascript
// 需要导入 ethers 包
const { ethers } = require("ethers");

// 构建 provider，可以理解为与区块链交互的桥梁
// 1. 可使用最基础的 JsonRpcProvider 进行构建 provider
const INFURA_ID = 'xxx..';
const provider = new ethers.providers.JsonRpcProvider(`https://mainnet.infura.io/v3/${INFURA_ID}`);

// 2. 也可使用封装好的特定 provider，例如 AlchemyProvider，InfuraProvider
// 使用 alchemy 的时候，第一个参数若为 null 则代表主网
const ALCHEMY_ID = `xxx...`;
const provider = new ethers.providers.AlchemyProvider('null', ALCHEMY_ID);
```

```javascript
// 获取当前网络最新的区块号 
let blockNumber = await provider.getBlockNumber(); 

// 获取余额，参数为地址，返回值是 bignumber 格式，单位为 wei
let balance = await provider.getBalance("0x...");

// 将 wei 格式转化为 ether 格式，bignumber 和 toString 格式都可以作为参数
let balance_in_ether = ethers.utils.formatEther(balance);

// 将 ether 转换为 wei 格式，返回值为 bignumber 格式
let result = ethers.utils.parseEther("1.0");

// 获取 gas price，返回值为 bignumber 格式
let gasPrice = await provider.getGasPrice();

// 获取内存 storage slot
// 第一个参数是合约地址，第二个参数是插槽位置
// 插槽位置可以使用十进制或者十六进制，十六进制需要加引号
await provider.getStorageAt("0x...", 3);
await provider.getStorageAt("0x...", "0x121");

// 获取地址的 nonce
await provider.getTransactionCount("0x...");
```

```javascript
// 构建钱包有两种方法
// 1. 直接通过 provider 和 私钥 构建
const privateKey1 = `0x...` // Private key of account 1
const wallet = new ethers.Wallet(privateKey1, provider);

// 2. 先通过 私钥 构建钱包，然后连接 provider
wallet = new ethers.Wallet(privateKey1);
walletSigner = wallet.connect(provider);

// 获取钱包地址
let address = await wallet.getAddress();
```

```javascript
// eth 转账
const tx = await wallet.sendTransaction({
    to: wallet2.getAddress(),
    value: ethers.utils.parseEther("100")
});

// 等待交易上链
await tx.wait();
// 打印交易信息
console.log(tx);
```

```javascript
// 可以直接通过 函数签名 构建 abi
// 需要用到哪个函数就写哪个，不需要写出全部的函数签名
const ERC20_ABI = [
    "function name() public view returns (string)",
    "function symbol() view returns (string)",
    "function totalSupply() view returns (uint256)",
    "function balanceOf(address) view returns (uint)",

    "event Transfer(address indexed from, address indexed to, uint amount)"
];

// 合约地址
const address = '0x...';
// 通过 地址，abi，provider 构建合约对象
const contract = new ethers.Contract(address, ERC20_ABI, provider);
```

```javascript
// 读取 name() 的值
const name = await contract.name();
console.log(name.toString());

// 读取 symbol() 的值
const symbol = await contract.symbol();
console.log(symbol);

// 读取 ERC20 合约中 balanceOf 的值
const balance = await contract.balanceOf('0x....');
console.log(balance.toString());
```

```javascript
// 获取钱包的 ERC20 余额
const balance = await contract.balanceOf(wallet.getAddress());

// 合约连接钱包对象
const contractWithWallet = contract.connect(wallet);

// 调用合约的 transfer 方法向其他账户转账
// 注意这里是调用 ERC20 合约的 transfer 函数，而不是原生货币转账
// 如果要调用 approve 函数，则为 contractWithWallet.approve
const tx = await contractWithWallet.transfer('0x...', balance);
// 等待交易上链
await tx.wait();

console.log(tx);
```

```javascript
// Transfer 事件要在 abi 中声明
// 括号中的参数分别对应 Transfer 事件的参数
contract.on("Transfer", (from, to, amount, event) => {
    console.log(`${from} sent ${ethers.utils.formatEther(amount)} to ${to}`);
});

// 这里是指定参数的监听行为
// 例如，我只想监听接收人是 `0x1234....` 的事件，那么就这样指定地址
// 构造一个 filter，然后通过 filter 筛选
filter = contract.filters.Transfer(null, '0x1234....');

// Receive an event when that filter occurs
contract.on(filter, (from, to, amount, event) => {
    // The to will always be "address"
    console.log(`I got ${ethers.utils.formatEther(amount)} from ${from}.`);
});
```

```javascript
// 创建 指定发送人是 myAddress 的 filter
const myAddress = `0x...`;
filterFrom = contract.filters.Transfer(myAddress, null);

// 创建 指定接收人是 myAddress 的 filter
filterTo = contract.filters.Transfer(null, myAddress);
// 扫描指定区块的范围

console.log(await contract.queryFilter(filterFrom, 14692250, 14693250))

// 扫描最近 1000 个区块
console.log(await contract.queryFilter(filterFrom, -1000))

// 扫描所有区块
await daiContract.queryFilter(filterTo)
```

```javascript
// 签名 utf-8
const signature = await wallet.signMessage('hello world');
console.log(signature);

// 更常见的 case 是签名 hash，长度为 32 字节
// 注意签名十六进制时，必须要将其转换为数组格式

// This string is 66 characters long
message = "0x4c8f18581c0167eb90a761b4a304e009b924f03b619a0c0e8ea3adfce20aee64";
// This array representation is 32 bytes long
messageBytes = ethers.utils.arrayify(message);

// To sign a hash, you most often want to sign the bytes
const signature2 = await wallet.signMessage(messageBytes);
console.log(signature2);
```

```javascript
// 我们上面在做一些写操作，例如转 ETH，写合约等操作时
// 使用的 gasLimit、gasPrice，都是由链上获取的默认数值
// 如果想要手动指定，需要添加一个额外的参数
// 声明一个对象，填写需要覆盖的字段，例如
let overrides = {
    gasLimit: 230000,
    maxFeePerGas: ethers.utils.parseUnits('12', 'gwei'),
    maxPriorityFeePerGas: ethers.utils.parseUnits('3', 'gwei'),
    nonce: (await provider.getTransactionCount(wallet.getAddress()))
}
// 将 overrides 作为最后一个参数
await walletWithSigner.transfer(wallet2.getAddress(), amount, overrides)
```

