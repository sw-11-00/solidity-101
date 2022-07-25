# 钱包原理

### 椭圆曲线**

二维平面上点的集合，按照Y轴上下对称。

**加法操作**

$$R = P + Q$$，作P和Q两点的连线，与椭圆曲线的第三个交点为-R，再按x轴取对称点，即为R。当P和Q为同一个点的时候，则做该点与椭圆曲线的切线，与椭圆曲线的第二个交点为-R，再按x轴取对称点，即为R。椭圆曲线是有限域，相加后的点仍在集合中，即交点-R一定存在。

**乘法操作**

在椭圆曲线上取一个计算上更安全的生成点G，$$K = k * G$$，通过提前算好$$2^{n}G$$来加速计算过程，已知K和G的情况下，无法计算出k。

**k是私钥，K是公钥。**

### 私钥

### 公钥

### 地址

椭圆曲线(私钥) -> 公钥(x, y) -> keccak256(x + y) -> 截取20bytes -> 地址：节省存储空间且减少地址碰撞

### 签名

**目的**

1. 证明持有地址的私钥且不暴露私钥
2. 证明私钥持有者同意了交易内容

**签名算法**

1. ECDSA：基础算法，不支持聚合签名，多签的时候需要依次验证
2. Schnorr(Bitcoin Taproot软分叉)：支持聚合签名，但需要signer与之进行交互
3. BLS(Filecoin、ETH2)：支持聚合签名同时解决交互问题

### 助记词

**BIP39**

用助记词生成种子。Mnemonic + Salt("mnemonic" + (optional)passphrase) -> Key Stretching Function(PBKDF2 using HMAC-SHA512) -> 2048rounds -> 512bit seed

**BIP32**

HD Wallet(Hierarchical Deterministic Wallet，分层确定性钱包)，通过一个seed，生成多层的私钥，没有seed的情况下，私钥之间不能相互推导。

**BIP44**

约定path的使用规范，即HD Wallet中私钥的选取规范。SLIP-0044，不同链的PATH约定，新链需要注册。

```
m / purpose' / coin_type' / account' / chain / address_index
```

