// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

    // 当一个僵尸猎食其他生物体时，它自身的DNA将与猎物生物的DNA结合在一起，形成一个新的僵尸DNA
    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]); // 不希望别人用我们的僵尸去捕猎,确保对自己僵尸的所有权
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        _createZombie("NoName", newDna);
    }
}