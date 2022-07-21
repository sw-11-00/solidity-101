# Curve Finance's Automated Market Maker (AMM) Principle

https://zhuanlan.zhihu.com/p/461398413
Curve定位是稳定币之间 or 等价币之间(如ETH和sETH、BTC和wBTC)的交易，代币相对价格稳定，波动区间小。
* Features:
  1. Sufficient depth with little or no slippage and Low handling fee (minimum 0.04%).
  2. Avoid a certain token in the pool from being fully exchanged, and increase the price when a certain token is rare.
  3. 100 - 1000 times higher market depth than Uniswap or Balancer for the same total value locked.

* Accomplish：
  1. 交易价格稳定为1，恒等式采用斜率为-1的直线，x + y = const
  2. 实际市场中，稳定币也会出现价格波动，需要考虑价格自调整能力，像Uni等，是通过乘积恒等式来调整 x * y = const
  3. 需要找到两种AMM中一个恒等式，在预期的稳定价格附近有比较小的滑点，在某一种代币余额产生较大偏离时，交易价格会发生比较大的变化，
     促使流动性提供者或者套利者通过市场行为恢复流动性池中的代币余额的均衡。
  4. 
