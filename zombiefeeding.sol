// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./zombiefactory.sol";

// CryptoKitties 接口
interface KittyInterface {
    function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {

    // 初始化kittycontract
    KittyInterface kittyContract;

    // 函数修饰符,确保僵尸军团的所有权
    modifier ownerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    // 获取kitty合约地址 外部调用，只能合约部署者才能调用
    function setKittyContract(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    // 传入僵尸对象，获取僵尸的冷却时间
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    // 判断冷却时间是否结束
    function _isReady(Zombie storage _zombie) view internal returns (bool) {
        return (_zombie.readyTime <= block.timestamp);
    }

    // 当一个僵尸猎食其他生物体时，它自身的DNA将与猎物生物的DNA结合在一起，形成一个新的僵尸DNA
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];

        // 判断僵尸是否已过冷却时间
        require(_isReady(myZombie));

        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;

        // 如果是猫，就有9条名，dna特征最后两位为99
        if (keccak256(abi.encode(_species)) == keccak256("kitty")) {
            newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName", newDna);

        // 触发新的冷却周期
        _triggerCooldown(myZombie);
    }

    // feedOnKitty 函数：从kitty合约中获取kitty基因
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}