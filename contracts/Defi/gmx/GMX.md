# GMX



- 0滑点(GLP流动性池、Chainlink预言机)
- 双币系统：GMX、GLP
- 真实收益(Real Yield)



### GMX

- 治理投票
- 质押&Vesting机制
- 可赚取：
  - 30%的平台费
  - esGMX
    - 1 esGMX = GMX
    - 不能出售
    - 兑换成GMX
      - vest 1 year + 生成esGMX的GMX不能出售
      - vest期间GMX不能赚平台费，用来vest的GMX/GLP可以
  - MP(Multipiler Point，积分点)
    - 质押越久，累计越多(100%APR)
    - 提升平台费收益



# 交易

### 交易规则设置

- 开多，抵押品必须为非稳定币，WBTC、WETH、UNI、LINK，交易品种必须与抵押品一致，用户得到的利润也是WBTC、WETH、UNI、LINK
- 开空，抵押品必须为稳定币，USDC、USDT、DAI、MIM、FRAX，交易品种只能是WETH-USD、WBTC-USD，用户得到的利润也是USDC、USDT、DAI、MIM、FRAX
- 无论开多开空，盈亏的币种与抵押品币种一致
- 用稳定币开多为什么不行？用非稳定币开空为什么不行？



### GLP定价

![Screen Shot 2022-10-07 at 19.58.07](/Users/jiansui/Desktop/Screen Shot 2022-10-07 at 19.58.07.png)

#### GlpManager.getAum()

![Screen Shot 2022-10-07 at 20.00.55](/Users/jiansui/Desktop/Screen Shot 2022-10-07 at 20.00.55.png)



### 混币池Vault设计



# 风控机制

### 最大开仓限制

1. nextLeverage > minLeverage，开仓后的杠杆要大于最小杠杆数
2. Position.collateral >= fee，新仓位的抵押品价格大于手续费，含资金额，限制蚂蚁仓
3. 新仓位不能立马被清算
4. ReserverdAmounts[_token] <= poolAmounts[_token]，这里限制实际上就是对于新开仓位的最大开仓限制

### 开仓保证金计算逻辑，限仓，限杠杆

### 平仓盈亏计算：指数价格、标记价格、手续费



# 预言机

### Index Price

1. chainlink数据源
2. 项目方自己输入，fastPriceFeed

### Mark Price

1. 稳定币
   1. 从chainlink拿到稳定币的价格，如果该价格在0.95-1.05之间，则认为稳定币价格是1
   2. 如果不在，直接返回chainllink的价格
2. 非稳定币WBTC、WETH
   1. 从chainlink拿到WETH的价格refPrice
   2. 把refPrice传到fastPriceFeed合约里，进行如下计算
      1. 计算minPrice = refPrice * (1 - 2.5%)
      2. 计算maxPrice = refPrice * (1 + 2.5%)
      3. 从fastPriceFeed里面拿到最新的updated的价格：fastPrice
      4. 如果fastPrice在[minPrice，maxPrice]之间，则返回fastPrice
      5. 如果fastPrice < minPrice，
3. 非稳定币Uni、Link
   1. 计算逻辑基本与WETH、WBTC一致，只是在返回的price上乘以一个系数：正负0.07%

# Staking
