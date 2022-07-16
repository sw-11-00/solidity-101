pragma solidity ^0.8.0;

library MerkleProof {

    /*
        当通过proof和leaf重建出的root与给定的root相等时，返回true，数据有效
        在重建时，叶子节点对和元素对都是排序过的
    */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computeHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computeHash = _hashPair(computeHash, proof[i]);
        }
        return computeHash;
    }

    // Sorted Pair Hash
    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a,b)) : keccak256(abi.encodePacked(b,a));
    }
}
