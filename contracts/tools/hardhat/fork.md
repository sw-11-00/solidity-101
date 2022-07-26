Hardhat fork可以将主网的区块fork到本地，从而在本地与真实的链上数据交互，同时可以**模拟任意账户**，方便测试、速度快，且不用花gas。

Hardhat fork 在平时的测试中非常方便，例如我们想要测试闪电贷，套利合约等，如果在主网测试，一是很慢，二是会花费 Gas。不过这个功能也不是 Hardhat 的专属，Ganache 和 Foundry 也有 fork 功能。

https://mirror.xyz/xyyme.eth/Z2qjTJJtaQHcwLc-9yHOGpXbeE7RHGdm5EafGjq7qhw