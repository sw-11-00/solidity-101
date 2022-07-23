## Compound

### 原理

每种借贷资产都会开设一个资金池，存取借还都是从资金池里流入流出。

**核心概念**

- 标的资产(Underlying Token)：即借贷资产，ETH、USDC、WBTC等。

- cToken：生息代币，是用户在Compound上存入资产的凭证，如ETH对应cETH，当用户向Compound存入ETH会返回cETH，取消时可以用cToken换回标的资产。

- 兑换率(Exchange Token)：cToken与标的资产的兑换比例，比如cETH的兑换率为0.02，即一个cETH可以兑换0.02个ETH。兑换率会随着时间而不断上涨，因此持有cToken就会不断生息，所以叫生息代币。计算公式为$$exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply$$。

- 抵押因子：每种标的资产都有一个抵押因子，代表用户抵押的资产价值对应可得到的借款的比率，即用来衡量可借额度的。取值范围是0 - 1，当为0时，表示该类资产不能作为抵押品去借贷其他资产。一般最高设置为0.75。

当用户存入**标的资产**后，Compound 会根据**兑换率**返回与标的资产相对应的 **cToken** 给到用户，作为一种存款凭证。

**清算**

当用户的借款价值已经超过借款额度，既会被清算。Compound的清算模式属于代还款清算，即清算人会帮借款人进行部分还款，并得到与还款资产价值同等的抵押资产，同时加上一定比例的清算激励，清算激励也是抵押资产。

### Compound利率模型

- https://medium.com/steaker-com/defi-%E7%9A%84%E4%B8%96%E7%95%8C-compound-%E5%AE%8C%E5%85%A8%E8%A7%A3%E6%9E%90-%E5%88%A9%E7%8E%87%E6%A8%A1%E5%9E%8B%E7%AF%87-95e9b303c284
- https://zhuanlan.zhihu.com/p/126503548

Compound有两种利率模型，一种是直线型，一种是拐点型。

### borrowIndex指数计算

#### 技术架构



### 

