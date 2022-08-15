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



### Round-based协议

在Tendermint中一共有三种类型的投票：prevote、precommit和commit，当一个block被全网络commit的话，意味着这个block已经被全网超过2/3的Validator签名并广播了。

Vote包含Height、Round、Type、Block Hash、Signature。当链运行到一个新的Height的时候，系统会运行一个round-based协议来决定下一个block。Round-based协议由以下三个步骤构成：proposal、prevote、precommit，以及两个特殊步骤：commit、NewHeight。其中propose、prevote和precommit会分别占用整个round1/3时间，每一个round的时间会比上一个round的时间长一点，这就是为了让网络在部分同步的情况下最终达成一致性。

Round-based协议是一个状态机，主要有NewHeight -> Propose -> Prevote -> Precommit -> Commit一共5个状态，上述每一个状态都称为一个step，首尾的NewHeight和Commit这两个Step被称为特殊的Step，而中间循环的三个Step则被称为一个round，是共识阶段，是算法的核心原理所在。一个块的最终提交(Commit)可能要需要多个Round过程，是因为有许多原因会导致当前Round不成功(比如出块节点Offline、提出的块是无效块、收到的Prevote或者Precommit票数不够+2/3等，出现这种情况，解决方案就是移步到下一轮，或者增加timeout时间)。

当区块链达到一个新的高度时进入到NewHeight阶段，接下来Proposal阶段会提交一个Proposal，Prevote阶段会对收到的Proposal进行Prevote投票，在Precommit阶段收集到+2/3投票后对Block进行Precommit投票，如果收集到+2/3Precommit投票后进入Commit阶段，如果没有收集到+2/3Precommit投票会再次进入到Propose阶段。在共识期间，如果收到+2/3commit投票那么直接进入commit阶段。

#### Proposal

在每一轮开始前都会通过Round-robin方式选出一个Propose，选出的Proposer会提交这一轮的proposal。在propose开始阶段，被选中的Proposer会给全网络广播一个proposal，如果Proposer锁定在上一轮中的block上，那么proposer在本轮中发起的proposal会是锁定的block，并且在proposal中加上一个Proof-of-lock字段。

#### Prevote

在Prevote阶段，每个Validator会判断自己是否锁定在上一轮的Proposed区块上，如果锁定在之前的Proposal区块中，那么在本轮中继续为之前锁定的Proposal区块签名并广播Prevote投票，否则为当前轮次中接收到的Proposal区块签名并广播Prevote投票。如果由于某些原因当前Validator并没有收到任何Proposal区块，那么签名并广播一个空的Prevote投票。

#### Precommit

在precommit开始阶段，每个Validator会判断，如果收集到了超过2/3 prevote投票，那么为这个区块签名并广播precommit投票，并且当前Validator会锁定在这个区块上，同时释放之前锁定的区块，一个Validator一次只能锁定在一个区块上。如果一个Validator收集到超过2/3空区块（nil)的prevote投票，那么释放之前锁定的区块。处于锁定状态的Validator会为锁定的区块收集prevote投票，并把这些投票打成包放入proof-of-lock中，proof-of-lock会在之后的propose阶段用到。如果一个Validator没有收集到超过2/3的prevote投票，那么它不会锁定在任何区块上。这里，介绍一个重要概念：PoLC，全称为 Proof of Lock Change，表示在某个特定的高度和轮数(height, round)，对某个块或 nil (空块)超过总结点 2/3 的Prevote投票集合，简单来说 PoLC 就是 Prevote 的投票集。

在precommit阶段后期，如果Validator收集到超过2/3的precommit投票，那么Validator进入到commit阶段。否则进入下一轮的propose阶段。

#### Commit

commit阶段分为两个并行的步骤：

1. Validator收到了被全网commit的区块，Validator会为这个区块广播一个commit投票。
2. Validator需要为被全网络precommit的区块，收集到超过2/3commit投票。

一旦两个条件全部满足了，节点会将commitTime设置到当前时间上，并且会进入NewHeight阶段。在整个共识过程的任何阶段，一旦节点收到超过2/3commit投票，那么它会立刻进入到commit阶段。

### 为什么不会分叉

如果小于1/3节点是拜占庭节点(如果大于等于1/3，共识就没法达成了)。当Validator commit了区块B，那么表示有大于2/3的节点在R轮投了pre commit，这表示至少有大于1/3节点被lock在了R' > R(为什么是大于1/3节点，因为就是大于2/3减去小于1/3)。如果这个时候有针对同一区块高度的投票，由于+1/3节点被lock在了R'轮，所以不会有+2/3的节点投prevote，也就不会在同一高度达成一个新的共识区块，所以就不会分叉。

所以Tendermint不分叉是基于它是BFT共识，然后加上LockedBlock共同完成。

