# Avalanche

### 共识协议

**Avalanche，是一种通用的共识引擎，通过不断反复的对网络中的节点进行抽样，收集他们对某个提议/交易的响应，达成最终共识。**

**简单概括：**

在房间里有n个人，在它们决定吃什么之前，

1. 会随机问k个人的偏好
2. 每次有大于等于a人数给与同一个回应的时候，本次询问结束，进入下一轮
3. 一直到连续b次询问轮次得到的结果一致，则最后吃什么也确定了

**协议进化历史：**

Slush -> Snowflake -> Snowball -> Avalanche

Avalanche引入了动态且仅限追加的DAG(有向无环图)结构和传递投票。

### 工程实现



### 代币经济

# Cosmos

**由独立并行区块链组成，Tendermint作为区块链共识引擎，提供Cosmos SDK模块化开发框架，支持IBC链间通信协议的区块链网络。**

目的是打通不同区块链的数据孤岛，形成区块链互联网。

### 原理

### Cosmos核心架构

##### Tendermint Consensus

Tendermint Consensus是一种基于BFT的POS共识算法，主要由共识引擎Tendermint Core和接口ABCI组成。

**Tendermint Core**

- 共识规则：BFT(Byzantine Fault Tolerance)拜占庭容错
- 参与网络的机制(挖矿机制)：POS(Proof Of Stake)
- 主要参数：节点上限100个，1/3节点故障可用，出块时间约1s
- 去中心化在区块链中应该是一种手段，而不应该成为目标本身

**Cosmos SDK**

**IBC**

**Cosmos Hub**

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

