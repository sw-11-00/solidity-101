## 什么是IBC

https://zhuanlan.zhihu.com/p/523778488

#### **IBC可以被认为是Comos生态各个链之间的高速公路**

IBC是Inter-Blockchain Communication(跨链通信)的缩写。IBC是一个端到端的、面向连接的、有状态的协议，用于可靠、有序和认证的分布式账本的模块之间的通信。IBC采用分层设计，主要分为2层：

1. IBC/TAO(传输层)：TAO指的是：transport、authorization、organization，该协议处理分布式账本之间的数据之间的传输、认证和排序
2. IBC/APP(应用层)：基于TAO构建的上层应用层，定义了从传输层发送过来的数据的处理方式，如可分割代币转移(ICS-20)、NFT代币转移(ICS-721)，interchain accounts(链间账户，ICS-27)

实现IBC协议的大多数工作集中在TAO层，一旦TAO实现，则很容易在TAO层之上实现不同的APP协议。和TCP/IP类似，IBC的特殊性在于它可以将应用层(Application layer)从传输层和网络层(TAO，transport、authorization、organization)中剥离出来。这意味着IBC定义了数据是如何跨链被发送和接收的，但是它没有明确具体的数据以及这些数据如何组织的。

#### **IBC工作流程：**

1. 链之间依赖relayer通信，relayer相当于IBC协议中的物理层连接，relayer会扫描运行IBC协议的链，并负责向其他链报告最新的状态
2. 多个relayer可为多个channel传输数据
3. relayer使用每个链上的light client来交易发送过来的消息



#### **IBC/TAO 网络传输层**

IBC/TAO层的主要作用为：在两链之间以reliable、ordered and authenticated方式传递数据包。

- Reliable：是指源链仅发送一个packet，目标链仅接收一次，二者无需信任第三方
- Ordered：是指目标链接收packet的顺序与源链发送packet的顺序一致
- Authenticated：每个channel分配给特定的智能合约，只有分配到channel的智能合约可以通过channel发送packet，任何其他智能合约无法使用该channel发送packet

IBC/TAO主要包含三个模块：

- 链上轻客户端(on-chain light client)
- 连接(connection)
- 通道(channel)

#### LightClient

轻客户端是IBC/TAO的基础，轻客户端用client ID作为标识，light client会追踪其他区块链的共识状态，并且会基于共识状态验证对方区块链发送过来数据的合法性。relayer只负责消息的传递，消息的合法性依赖于轻客户端做验证，所以IBC的安全性不依赖于第三方服务比如relayer。

#### Connection

有了light client，就可以在light client间建立connection，connection是建立一个连接两个分布式账本的通道，一个light client可以接受任意数量的connection。connection通过四次握手完成，所有操作都是由relayer发起交易来触发，A链发起连接到B链的过程如下：

1. `connOpenInit`：在`A`链上会创建并存储`INIT`状态。
2. `connOpenTry`：`B`链若验证`A`链上该`connection`状态为`INIT`，则在`B`链上创建并存储`TRYOPEN`状态。
3. `connOpenAck`：`A`链若验证`B`链上该`connection`状态为`TRYOPEN`，则将`A`链上该`connection`的状态由`INIT`更新为`OPEN`。
4. `connOpenConfirm`：`B`链若验证`A`链上该`connection`状态已由`INIT`更新为`OPEN`，则将B链上该`connection`状态由`TRYOPEN`更新为`OPEN`。

#### Channel

connection和ligth client构成了IBC中传输层的主要组件，但是IBC中的应用程序之间的通信是通过channel进行的。channel在应用程序模块与另一条链上的相应应用程序模块之间进行路由，这些应用程序由端口标识符命名，例如 `ICS-20 token`传输的`transfer`。

channel通过四次握手完成，所有的操作都是由relayer发起交易来触发，A链发起连接到B链的过程如下：

1. `chanOpenInit`：在`A`链上会创建并存储`INIT`状态。
2. `chanOpenTry`：`B`链若验证`A`链上该`channel`为`INIT`状态，则在`B`链上创建并存储`TRYOPEN`状态。
3. `chanOpenAck`：`A`链若验证`B`链上该`channel`为`TRYOPEN`状态，则将`A`链上该`channel`的状态由INIT更新为`OPEN`。
4. `chanOpenConfirm`：`B`链若验证`A`链上该`channel`状态已由`INIT`更新为`OPEN`，则将`B`链上该`channel`状态由`TRYOPEN`更新为`OPEN`。

#### **IBC/APP 应用层**

#### **interchain account**

跨链账户允许区块链使用`IBC`安全地控制另一个区块链上的账户。跨链账户最重要的两个特点如下：

1. 通过`IBC`在另一个链上创建一个新的跨链账户
2. 通过`IBC`可以控制远程的跨链账户

`Host Chain`：跨链账户在`Host Chain`上注册生成。`Host Chain`监听来自`controller chain`的 IBC 数据包（创建`interchain account`的数据包）。

`controller chain`：该链可以在`Host Chain`上注册跨链账户，完成后可以控制跨链账户（通过发送IBC packet给`Host Chain`来控制）。`controller chain`必须具有至少一个跨链帐户身份验证模块（`Authentication Module`）才能充当`controller chain`。

`Authentication Module`（身份验证模块）：`controller chain`上的自定义`IBC`应用程序模块，使用跨链账户模块 API 构建自定义逻辑，用于创建和管理跨链账户。`controller chain`需要身份验证模块才能利用链间帐户模块功能。

跨链账户（`ICA`）：`Host Chain`上的账户。跨链账户具有普通账户的所有功能。但是，`controller chain`的身份验证模块不会使用私钥对交易进行签名，而是将`IBC`数据包发送到`Host Chain`，以指示跨链帐户应该执行哪些交易。



## 总结

IBC协议分为四层：

- 应用层
  - 应用层处理来自channel的数据包，并将处理完成后的数据交给channel发送给对方链，目前用的比较多的应用是跨链token转移和链间账户
- channel
  - channel建立在connection上，一个connection上可以拥有多个channel，每个channel的Id都是自增的，channel和模块绑定
- connection
  - connection建立在light client基础上，一个light client上可以有多个connetion，connection的id也是自增的
- light client
  - 每条链都会拥有另外一条链的light client，light client跟踪其他链的共识状态，以及根据对方链的light client的共识状态验证对方的数据包的合法性

relayer不对数据包进行任何形式验证，因此不需要被信任，relayer除了提交数据包以保持IBC网络的活跃性，负责提交init消息以创建新的light client，并在每个链上保持light client状态的更新，以确保light client可以验证传递过来的数据包的合法性。relayer还负责发送connection和channel握手数据包，在链之间建立connection和channel。此外，如果连接另一端的链尝试分叉或者尝试其他类型的恶意行为，relayer可以提交不当行为的证据。



