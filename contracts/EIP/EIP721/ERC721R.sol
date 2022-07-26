pragma solidity ^0.8.0;

contract ERC721G {
    // 可以给用户退款，防止 rug

    // 退款时间区间
    uint256 public constant refundPeriod;
    // 退款结束时间
    uint256 public refundEndTime;
    // 退款接收地址
    address public refundAddress;

    // 当用户在退款期内想要退款时，可以调用 refund 函数，传入想要退款的 tokenId 列表，就可以将 NFT 换成币。

    // 管理员在退款期内，不能转出币（以实现用户可以刚兑）。到期后可以转出。
}
