// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombiefeeding.sol";
import "./safemath.sol";

contract ZombieHelper is ZombieFeeding {

    using SafeMath32 for uint32;

    // 僵尸升级费用
    uint levelUpFee = 0.001 ether;

    // 函数修饰符：僵尸到达一定等级后才拥有的功能
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // 提取可用余额
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // 设置僵尸升级费用
    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    // 支付费用可升级僵尸等级
    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level = zombies[_zombieId].level.add(1);
    }

    // 更改名字
    function changeName(uint _zombieId, string memory _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
        zombies[_zombieId].name = _newName;
    }

    // 更改dna
    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId) {
        zombies[_zombieId].dna = _newDna;
    }

    // 获取某owner的僵尸军团
    function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
        uint[] memory result = new uint[] (ownerZombieCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

}