// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
    uint randNonce = 0;

    // 攻击方胜利概率70%
    uint attackVictoryProbability = 70;

    // 生成随机数
    function randMod(uint _modulus) internal returns (uint) {
        randNonce++;
        return uint(keccak256(abi.encode(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    // 攻击函数
    function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);

        // 我方僵尸胜利
        if (rand <= attackVictoryProbability) {
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {  // 我方僵尸失败后
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
        }
    }
}