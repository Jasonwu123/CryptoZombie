// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    // 函数修饰符：僵尸到达一定等级后才拥有的功能
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // 更改名字
    function changeName(uint _zombieId, string memory _newName) external aboveLevel(2, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

    // 更改dna
    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
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