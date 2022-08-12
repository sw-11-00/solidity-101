## CosmosSDK

### 概述

1. baseApp：定义基本的ABCI应用模版，与Tendermint通信，开发者可以根据自己的需求重写
2. Staking：POS相关的实现，包含：绑定、解绑、通货膨胀、费用等操作
3. ibc：跨链协议IBC的实现，是Cosmos支持跨链的主要插件
4. Governance：治理相关的实现，如提议、投票等
5. Auth：定义了一个标准的多资产账户结构(BaseAccount)，开发者可以直接嵌入到自己的账户体系中
6. Bank：定义资产的转移



