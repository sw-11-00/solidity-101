### Tendermint 发展史

1. 2014年，Jae Kwon与Ethan Buchman、Zarko Milosevic联合创建了Tendermint
2. 2014年，Jae Kwon 发表了《Tendermint：无挖矿的共识》白皮书。Tendermint 的基本思想是允许大量分布式节点就共识达成一致，而无需中本聪共识依赖的PoW 工作量证明挖矿
3. 2014年，成立的跨链项目Cosmos
4. 2016年6月，为解决跨链问题而发起的Cosmos项目发布第一版白皮书
5. 2017年 4月6日 ，Tendermint团队，在不到半个小时的时间筹集了 1600 多万美元，完成募资不到两个星期，Tendermint 团队就开始建立COSMOS中国社区
6. 2018年 2 月，上线 Cosmos 软件开发工具包（SDK）
7. 2018年3月，币安公链 Binance Chain 宣布将构建在 Cosmos 的 Tendermint 协议之上，采用 DPoS 和 BFT 共识，其去中心化交易所 DEX 也将基于 Cosmos 的跨链协议
8. 2019年3 月14 日 7 时 08 分（UTC+8），Cosmos 主网成功上线



### 出块节点选择

Tendermint是BFT + POS，在BFT之前需要先通过POS方法选出proposer进行提案，proposer是从validator节点中选出的，Validator是在创世区块配置的。

- Validator：所有参与共识验证的节点
- Proposer：Validator中选出来的出块节点

#### Proposer选择规则

Tendermint采用round-robin的策略选取proposer。当Validator初始化完成之后，全网每个节点会存储一份Validator副本，放在一个循环数据中，当链上区块达到一个新高度后，就会进行一次Proposer选举，一般一个区块高度(height)大部分情况下只需要一轮(round)就能产生，网络不好的时候可能要多轮才能出一个块。

proposer的选择顺序与Validator的votingPower(投票力)有关，为了防止一直都是VotingPower大的Validator被选中，Tendermint提供了VotingPower更新算法，算法如下：

1. Validator的初始VotingPower是与其stake相等的，stake是POS算法中的权重，用来衡量节点权重。如果Validator A在创世块中的stake是1，那么它的VotingPower也是1
2. 每一轮结束会对Validator的VotingPower进行更新
   1. 如果一个Validator在当前轮次没有被选中为proposer，那么它的VotingPower将增加，增加的值为它的初始stake，例如Validator A的初始化stake为1，如果A没有被选中为proposer，那么它的votingPower=pre_votingPower+stake
   2. 如果一个Validator在当前轮次被选中为proposer，那么它的VotingPower将减少，减少的值为数组中其他Validator的stake之和，例如：Validator集合={A:1,B:2,C:3}，如果C被选中为proposer，那么C的votingPower=pre_votingPower-(stake_a+stake_b)

#### 优缺点

- 优点：Proposer的选择方式是与stake相关的，所以应用层可以实现自己的共识(DPOS)，在应用层将计算好Validator的权重传递给Tendermint，Tendermint就会按照应用层需要的方式选择Proposer
- 缺点：Round-robin策略相对简单，容易被预测下一个Validator是谁，于是可以提前布局发起DDOS攻击，Tendermint的解决办法是把Validator节点全部放在Sentry Node后面，对外不暴露IP地址



