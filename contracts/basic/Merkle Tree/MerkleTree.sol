pragma solidity ^0.8.0;

import "./MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MerkleTree is ERC721 {

    bytes32 immutable public root; // Merkle树根
    mapping(address => bool) public mintedAddress; // 记录已经mint得地址

    // 构造函数
    constructor(
        string memory name,
        string memory symbol,
        bytes32 merkleroot) ERC721(name, symbol) {
        root = merkleroot;
    }

    function mint(address account, uint256 tokenId, bytes32[] calldata proof) external {
        require(_verify(_leaf(account), proot), "Invalid merkle proof");
        require(!mintedAddress[account], "Already minted!");
        _mint(account, tokenId);
        mintedAddress[account] = true;
    }

    function _leaf(address account) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(account));
    }

    function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
        return MerkleProof.verify(proof, root, leaf);
    }
}
