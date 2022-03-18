// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./ownable.sol";
import "./safemath.sol";

contract ZombieFactory is Ownable {
    using SafeMath16 for uint16;
    using SafeMath32 for uint32;
    using SafeMath for uint256;

    // 事件，每当新生成一个僵尸都能监听到
    event NewZombie(uint zombieId, string name, uint dna);

    // 保证僵尸dna为16位数
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    // 僵尸结构体
    struct Zombie {
        string name;
        uint dna;
        uint32 level; // 僵尸等级
        uint32 readyTime; // 僵尸冷却时间
        uint16 winCount; // 僵尸战斗胜利次数
        uint16 lossCount; // 僵尸战斗失败次数
    }

    // 僵尸数组
    Zombie[] public zombies;

    // 存储僵尸所有权
    mapping (uint => address) public zombieToOwner; // 记录僵尸拥有者的地址
    mapping (address => uint) ownerZombieCount; // 记录某个地址所拥有的僵尸数量

    // 僵尸生成函数，私有函数，然后存放到僵尸数组中
    function _createZombie(string memory _name, uint _dna) internal {
        // 当新生成僵尸并存入到数组时，触发事件 NewZombie
        zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0)); 
        
        // 数组下标当id
        uint id = zombies.length - 1;

        // 得到僵尸新id后，更新zombieToOwner
        zombieToOwner[id] = msg.sender;

        // 并且为该msg.sender名下的ownerZombieCount +1
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);

        // 触发事件
        emit NewZombie(id, _name, _dna);
    }

    // dna数据生成函数，根据字符串随机生成,私有函数，只读不能修改
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }

    // zombie僵尸生成函数，公共函数
    // 每个玩家只能调用一次
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}