pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockApe is ERC721 {

    uint public MAX_APES = 1000;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {

    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    function mint(address to, uint tokenId) external {
        require(tokenId > 0 && tokenId < MAX_APES, "tokenId out of range");
        _mint(to, tokenId);
    }
}
