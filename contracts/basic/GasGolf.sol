//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/*
    init gas cost50011
    1，优先使用calldata 48421，用calldata不会复制参数，是直接引用的
    2，加载状态变量到内存变量 48210
    3，多个条件判断使用短路方式 47972
    4，在循环中使用++1，而不是i+=1,i++ 47647
    5，数组长度缓存到内存 47620
    6，缓存多次使用的数组元素到内存 47445
*/

contract GasGolf {

    uint public total;

    function sumIfEvenAndLessThan99(uint[] calldata nums) external {
        uint _total = total;
        uint len = nums.length;
        for (uint i = 0; i < len; ++i) {
            uint num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
        }

        total = _total;
    }
}
