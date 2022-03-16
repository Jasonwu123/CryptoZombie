# CryptoZombie
### 以太坊智能合约开发实战教程 

### 状态变量是被永久地保存在合约中。也就是说它们被写入以太币区块链中. 想象成写入一个数据库。

### 事件是合约和区块链通讯的一种机制。你的前端应用“监听”某些事件，并做出反应。   
### Addresses （地址）   
以太坊区块链由 _ account _ (账户)组成，你可以把它想象成银行账户。一个帐户的余额是 _以太_ （在以太坊区块链上使用的币种），你可以和其他帐户之间支付和接受以太币，就像你的银行帐户可以电汇资金到其他银行帐户一样。   

每个帐户都有一个“地址”，你可以把它想象成银行账号。这是账户唯一的标识符，它看起来长这样：   

0x0cE446255506E92DF41614C46F1d6df9Cc969183   

我们将在后面的课程中介绍地址的细节，现在你只需要了解地址属于特定用户（或智能合约）的。    

所以我们可以指定“地址”作为僵尸主人的 ID。当用户通过与我们的应用程序交互来创建新的僵尸时，新僵尸的所有权被设置到调用者的以太坊地址下。    

### Mapping（映射）
//对于金融应用程序，将用户的余额保存在一个 uint类型的变量中：  
mapping (address => uint) public accountBalance;   

//或者可以用来通过userId 存储/查找的用户名   
mapping (uint => string) userIdToName;   

映射本质上是存储和查找数据所用的键-值对。   

### msg.sender

在 Solidity 中，有一些全局变量可以被所有函数调用。 其中一个就是 msg.sender，它指的是当前调用者（或智能合约）的 address。  

注意：在 Solidity 中，功能执行始终需要从外部调用者开始。 一个合约只会在区块链上什么也不做，除非有人调用其中的函数。所以 msg.sender总是存在的。   

### require

### import 

### 继承

### internal 和 external   

public 和 private 属性之外，Solidity 还使用了另外两个描述函数可见性的修饰词：internal（内部） 和 external（外部）。    

internal 和 private 类似，不过， 如果某个合约继承自其父合约，这个合约即可以访问父合约中定义的“内部”函数。（嘿，这听起来正是我们想要的那样！）。   

external 与public 类似，只不过这些函数只能在合约之外调用 - 它们不能被合约内的其他函数调用。稍后我们将讨论什么时候使用 external 和 public。   

### 与其他合约的交互

如果我们的合约需要和区块链上的其他的合约会话，则需先定义一个 interface (接口)。

