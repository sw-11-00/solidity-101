# 合约升级

原理是代理合约通过delegatecall调用逻辑合约，此时逻辑合约的上下文以及数据都来自于代理合约。在升级合约时，不能更改已有的状态变量的顺序，如果需要新添加变量，需要放在当前所有变量之后，不能在中间插入，否则会改变插槽对应关系，使变量内容混乱。

https://mirror.xyz/xyyme.eth/VSyU0JfmVrcqN-F28tX5mzYjxFFAosl8tDAQX3vB5Dg