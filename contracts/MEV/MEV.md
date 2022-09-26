# MEV

MEV全称Miner/Maximum Extractable Value，Block创建者(PoW里的Miner，PoS里的Validator)，通过在Block中插入、排除、重排交易来获取收益。

### **为什么会有MEV**

Decentralized Sequencer

- 传统的交易系统都是中心化的FCFS（First Come First Serve），比如股票交易
- 区块链里则是去中心化的Miner从公开Mempool中选取交易，打包上链
- 因为Block存在Gas上限，默认Miner会按Gas Price从高到低排序，以获得最多的Gas Fee Payback
- 如果仅存在转账交易，上述方法确实可以实现MEV
- 当链上出现DeFi交易的时候，Miner可以通过操纵交易顺序来从DeFi协议中获取额外收益（比如三明治攻击等）



### 类型

#### **手段**

操纵交易顺序以获取收益

1. Front Running：看到获利交易，前置插入一笔一样的
2. Back Running：看到影响大的交易，紧跟插入交易搬平它的影响
3. Sandwich Attack、Time-Bandit Attack等

#### 应用

从哪些Defi协议获利

1. DEX套利、Liquidations
2. 长尾NFT

#### Dex套利

1. 利用交易对之间的价差进行搬砖
2. 特性1，Multi-hop：区块链一笔交易中可以连续进行多次swap操作，提供了交易的原子性，所以比传统套利更多hop
3. 特性2，无本金：Flashloan提供了在同一笔交易内先借后还的操作，所以可以实现无本金套利

#### Liquidations

1. DeFi借贷：为抵押比例不足的借款人，进行部分债务的清算（卖出部分抵押物以偿还借款），使其抵押比例上升。
2. 特性1：达到清算阈值后任意用户可以发起清算，通常是机器人（价格大幅度波动的时候链上也会拥堵）
3. 特性2：超额抵押，分批次清算（stETH爆仓事件）



### 影响

1. 正面影响是帮助DeFi运行：DEX的价格及时更新，借贷、稳定币等运行
   1. 套利者也在其中获得了收入
2. 负面影响
   1. Gas War：PGA（Priority Gas Auction）交易之间通过Gas竞争获得更优先的排序
      1. 链上抢购或价格波动导致大量清算时会发生
      2. 一方面极速拉高Gas，造成Gas不稳定
      3. 另一方面大量失败交易上链，浪费链上空间
   2. Dark Forest：交易进入公开的Mempool后容易被攻击，来提取其中的价值
   3. Reorg：Miner为了MEV而进行Reorg，影响区块链的终局性
3. 已有的解决方案 
   1. EIP-1559：引入Base Fee的销毁和弹性的Block Gas容量来缓解Gas War
      1. Base Fee随拥堵情况变化，且幅度限制在1.125x per block，使Gas Price的变化更平滑更好预测
      2. 增加了矿工自己插入交易的成本，减少矿工的MEV和影响Gas的行为
      3. Block Gas容量有个2x的变化空间，会随着拥堵情况缓慢变化
   2. Flashbots/MEV-boost引入中心化的Sequencer
      1. 链下的交易排序竞价（Sealed-price Bid Auction），Gas War转移到了链下完成
         1. 通过在tx内部直接支付ETH给Miner进行Bid
         2. 中心化的服务完成Auction，确定要包含的交易及其排序
         3. 失败交易不上链
      2. 提供了Private Mempool，防止了黑暗森林
      3. MEV-Boost使用现状：https://www.mevboost.org/
         1. 多个服务提供商
         2. 占20%+的出块
   3. Rollups引入了Layer2的FCFS，使用Rollup可以避免MEV的所有影响
4. 待实现的解决方案
   1. PBS：去中心化的Sequencer/Builder
   2. Single-slot Finality：避免reorg
   3. Fair Sequencing：确定性的交易排序
   4. MEV smoothing：在Miner之间平滑MEV的收益
   5. Guaranteed Decryption：交易加密后进Mempool，上链后再解开





