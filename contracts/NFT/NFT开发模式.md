## 常见开发模式

1. 使用计数器替代`ERC721Enumerable`，节省Gas

   - 部分ERC721实现由ERC721Enumerable组成，ERC721Enumerable非常消耗Gas同时浪费存储空间。
   - ERC721Enumerable中唯一需要函数是totalSupply，可以使用计数器记录NFT铸造数量，同时合约将不再有tokenID -> owner映射，可以使用graph追踪此信息
   - Azuki、Crypto Coven

2. 使用ERC721A批量铸造

   - ERC721优点
     - 摆脱ERC721Enumerable
     - 每批只更新一次数据，而不是在每次铸币后更新数据
     - 使用更有效的存储布局：连续NFT有相同所有者，不存储所有者冗余信息(只为第一个拥有的NFT存储一次)。这个数据可以在运行时，通过向左读直到找到所有者信息来判断
     - 每批只触发一个转移事件
   - Azuki、goblintown、wagdie、Moonbirds

3. 使用SafeMint替代Mint

   - SafeMint的目的是为了防止NFT丢失到合约中，如果NFT接收者是合约，而它没有转移方法，NFT将永远停留在合约内。
   - 如果接收方是普通账户，而不是合约，就不需要使用SafeMint，如果确定接收方合约可以处理NFT，不需要使用SafeMint。
   - 通过使用Mint替代SafeMint可以节省Gas，使用Transfer替代Transfer是同样的原理。
   - Crypto Coven

4. 使用Merkle树实现白名单机制

   - Merkle树是一种高效的数据结构，允许以单个地址的代价存储一堆地址，查找时间是O(1)，可以节省存储和Gas。
   - Crypto Coven、OKPC

5. 可升级/可交换的元数据

   - 未来升级NFT展现和链上链下的渲染之间切换，应该让元数据可以被替换

   - ```solidity
     function setMetadataAddress(address addr) external onlyOwner {
     	metadataAddress = addr;
     }
     ```

   - OKPC、Watchfaces

6. 防范机器人

   - 限制钱包的铸币量
   - 检查`msg.sender == tx.origin`，当一个合约调用铸币功能时，msg.sender将是合约地址，但tx.origin将是调用该合约的人的地址

7. 防止NFT狙击手(针对性铸造稀有NFT)

   - 暴露代币元数据(让狙击手推断出代币的稀有性)
     - 代币铸造后才披露元数据
     - 分批渐进式披露
     - 所有链上的数据都会被读取和利用，铸币开始前不要验证合约
   - 以确定的顺序铸造代币(让狙击手推断铸造稀有代币的正确时间)
     - 随机化铸币顺序，很难创造真正的随机性，可以添加白名单机制

8. 其他模式

   1. 使合约可以提取ERC-721和ERC-20
   2. 使数据不可改变：创建链上NFT/使用链外渲染
   3. 预先授权OpenSea，以便0费用上架