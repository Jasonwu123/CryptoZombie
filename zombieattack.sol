// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombiehelper.sol";
import "./safemath.sol";

contract ZombieAttack is ZombieHelper {

    using SafeMath for uint256;
    using SafeMath16 for uint16;
    using SafeMath32 for uint32;
    uint randNonce = 0;

    // 攻击方胜利概率70%
    uint attackVictoryProbability = 70;

    // 生成随机数
    function randMod(uint _modulus) internal returns (uint) {
        randNonce = randNonce.add(1);
        return uint(keccak256(abi.encode(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    // 攻击函数
    function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);

        // 我方僵尸胜利
        if (rand <= attackVictoryProbability) {
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {  // 我方僵尸失败后
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
            _triggerCooldown(myZombie);
        }
    }
}