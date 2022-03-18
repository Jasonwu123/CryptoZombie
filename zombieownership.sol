// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

abstract contract ZombieOwnership is ZombieAttack, ERC721 {

    using SafeMath for uint256;

    // 映射快速查找谁被批准获取代币
    mapping (uint => address) zombieApprovals;

    // 重装erc721函数，获取拥有者的僵尸数量
    function balanceOf(address _owner) public view  override returns (uint256 _balance) {
        return ownerZombieCount[_owner];
    }

    // 重载erc721函数，根据僵尸id或者拥有者地址
    function ownerOf(uint256 _tokenId) public view override returns (address _owner) {
        return zombieToOwner[_tokenId];
    }

    // 僵尸转移
    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public override {
        require(msg.sender == zombieApprovals[_tokenId]);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }


}