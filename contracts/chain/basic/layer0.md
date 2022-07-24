# Avalanche

## 共识协议

**Avalanche，是一种通用的共识引擎，通过不断反复的对网络中的节点进行抽样，收集他们对某个提议/交易的响应，达成最终共识。**

##### **简单概括：**

在房间里有n个人，在它们决定吃什么之前，

1. 会随机问k个人的偏好
2. 每次有大于等于a人数给与同一个回应的时候，本次询问结束，进入下一轮
3. 一直到连续b次询问轮次得到的结果一致，则最后吃什么也确定了

##### **协议进化历史：**

Slush -> Snowflake -> Snowball -> Avalanche

Avalanche引入了动态且仅限追加的DAG(有向无环图)结构和传递投票。

## 工程实现



## 代币经济



# Cosmos

**由独立并行区块链组成，Tendermint作为区块链共识引擎，提供Cosmos SDK模块化开发框架，支持IBC链间通信协议的区块链网络。**

目的是打通不同区块链的数据孤岛，形成区块链互联网。

## 原理

## Cosmos核心架构

### Tendermint Consensus

Tendermint Consensus是一种基于BFT的POS共识算法，主要由共识引擎Tendermint Core和接口ABCI组成。Tendermint consensus是首个互联网级别可用的BFT的共识协议，相比较于PBFT等经典的共识协议简化了View-Change等复杂的切换过程，更适合公链上使用。

**Tendermint Core**

- 共识规则：BFT(Byzantine Fault Tolerance)拜占庭容错
- 参与网络的机制(挖矿机制)：POS(Proof Of Stake)
- 主要参数：节点上限100个，1/3节点故障可用，出块时间约1s
- 去中心化在区块链中应该是一种手段，而不应该成为目标本身

**ABCI**

ABCI(Application Blockchian Interface)是一种Socket协议调用接口，可以使开发者无需使用特定语言开发应用层。

### **Cosmos SDK**

Cosmos SDK是一个通用框架，简化了在Tendermint BFT上构建安全区块链应用程序的过程，提供了应用层的模块化组合。

**功能**

- Staking模块：代币质押
- Slashing模块：惩罚策略
- Governance模块：链上治理
- IBC模块：桥接IBC

Cosmos SDK模块并不强制要求绑定到Tendermint的共识机制，也不强制接入IBC，开发者可以根据自己需要进行开发。使用Cosmos SDK开发的每条链都有主权(Soveriginty)，就是可以在自己的区块链世界制定规则。Cosmos SDK就是联邦宪法，架构在上面的每一条链都是自治区，每个自治区高度自主却遵守同一部宪法。

### **IBC**

IBC为Cosmos SDK中的一个模块，是一个标准化的链间通信协议，其打造的区块链的TCP/IP协议使得多链数据互通成为可能。

**IBC架构**

- Handshake
- Port ID
- Channel ID

**IBC通信实例**

1. 轻客户端验证资产是否合法有效
2. A链发送证明ATOM已被锁定
3. B链发送A链的证明
4. B链创建100个ATOM的Voucher抵用券，可以流通使用直到返回A链后用来解锁原来的100个ATOM

**IBC主要特性**

- 互操作性：资产跨链，信息跨链
- 安全性：IBC假设不同的链互不信任，IBC协议的安全来自Tendermint共识的最终性，没有再引入其他的可信任假设
- 通用性：IBC不一定是最好的跨链协议，但随着越来越多的区块链使用IBC的标准，IBC成为真正的跨链标准的可能性就越大
- 兼容性：必须具有提供最终确定性的共识机制才能直接通信，目前POW的比特币和以太坊可以通过Peg Zone解决通信问题

**IBC异构链通信**

- 区块链分类：1. 提供最终确定性的链(Deterministic)如Tendermint共识 2. 基于概率出块的链(Probabilistic chain)如POW共识
- Cosmos提供Gravity Bridge桥接以太坊的原生代币，这是一个独立于Cosmos生态的区块链，拥有自己独立的验证者负责网络的维护和安全，且支持Cosmos Hub共享安全

### **Cosmos Hub**

IBC协议把跨链的信息标准化，让Cosmos的网络中的区块链也可以交流，而在这个经济一体化的网络中，Cosmos Hub就是这个网络的价值枢纽。

Hub记录着连接其的每一条Zone(连接到Hub的区块链)的账本的余额交易和记录，Hub和Zone没有严格的区分，是一种对等的关系，每个人都可以运行自己的Hub。

### 链间共享安全

- 保证Hub的极简主义
- 降低开发和运行公链的门槛
- 保证Cosmos网络的安全：Cosmos的网络安全取决于最弱的分区
- 提供Hub的价值捕获渠道
- Hub代币价格的升值会增加作恶成本上给Cosmos的网络安全提供了一定的安全保障



# Polkadot







|          | Avalanche                                                 | Polkadot                                   | Cosmos                                                   |
| -------- | --------------------------------------------------------- | ------------------------------------------ | -------------------------------------------------------- |
| 分片结构 | 本身没有分片概念，采用DAG结构 + 重复投票子采样            | Parachains - Relay Chain的共享状态分片模型 | Hub - Zones的非共享状态分片模型                          |
| 质押     | 主网是没有slash惩罚的PoS，但是会剥夺节点资格              | 中继链NPOS，N是提名的意思                  | Hub用的BPOS，B是bonded                                   |
| 共识     | 概率最终性的avalanche                                     | BABE(出块) + GRANDPA意思                   | Tendermint(出块就是经过最终确认了，PBFT是经典的共识算法) |
| 消息传递 | 消息传递/跨链理论上是可以做到无缝衔接的，本身的subnet结构 | XCMP                                       | IBC                                                      |
| 治理升级 | 主网无需分叉治理升级，子网自定义                          | 无需分叉治理升级                           | 常规升级，硬分叉                                         |
| 开发     | 可以直接做应用，也可以用p链的API做subnet                  | Substrate框架                              | Cosmos SDK                                               |
| 安全性   | 共享节点，不是不共享状态，也不共享安全性                  | 共享安全性                                 | 不共享安全性                                             |

