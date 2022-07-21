// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RandomNumberConsumer is VRFConsumerBase {

    bytes32 internal keyHash; // VRF unique identifier
    uint256 internal fee;

    uint256 public randomResult;

    constructor()
    VRFConsumerBase(
        0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, 0x01BE23585060835E02B77ef475b0Cc51aA1e0709
    ) {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18;
    }

    // Apply for random numbers
    function getRandomNumber() public returns (bytes32) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        return requestRandomness(keyHash, fee);
    }

    // Consuming random number logic
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        requestId;
        randomResult = randomness;
    }
}
