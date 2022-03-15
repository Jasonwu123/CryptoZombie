pragma solidity ^0.8.12;

contract ZombieFactory {

    // 事件，每当新生成一个僵尸都能监听到
    event NewZombie(uint zombieId, string name, uint dna);

    // 保证僵尸dna为16位数
    uint dnaDigits = 16;
    uint dnaModules = 10 ** dnaDigits;

    // 僵尸结构体
    struct Zombie {
        string name;
        uint dna;
    }

    // 僵尸数组
    Zombie[] public zombies;

    // 僵尸生成函数，私有函数，然后存放到僵尸数组中
    function _createZombie(string _name, uint _dna) private {
        // 当新生成僵尸并存入到数组时，触发事件 NewZombie
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        NewZombie(id, _name, _dna);
    }

    // dna数据生成函数，根据字符串随机生成,私有函数，只读不能修改
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModules;
    }

    // zombie僵尸生成函数，公共函数
    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}