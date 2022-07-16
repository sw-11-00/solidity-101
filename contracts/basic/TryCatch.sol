// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
        1. try catch只能被用于external函数或者创建合约时constructor(被视为external函数)的调用
        2. try在调用成功下运行，catch在调用失败时运行
        3. 如果调用函数有返回值，那么必须在try之后声明returns(returnType val)，并且在try模块之后
           可以使用返回的变量；如果是创建合约，那么返回值是新创建的合约变量
           try externalContract.f() returns(returnType val){
           } catch {
           }
        4. catch模块支持捕获特殊的异常原因
           try externalContract.f() returns(returnType){
           } catch Error(string memory reason) {
               // 捕获失败的 revert() 和 require()
           } catch (bytes memory reason) {
               // 捕获失败的 assert()
           }
    */

contract OnlyEven {

    constructor(uint a) {
        require(a != 0, "invalid number");
        assert(a != 1);
    }

    function onlyEven(uint256 b) external pure returns (bool success) {
        require(b % 2 == 0, "Ups!Reverting!");
        success = true;
    }
}

contract TryCatch {

    event SuccessEvent();
    event CatchEvent(string message);
    event CatchByte(bytes data);

    OnlyEven even;

    constructor() {
        even = new OnlyEven(2);
    }

    function execute(uint amount) external returns (bool success) {

        try even.onlyEven(amount) returns (bool _success) {
            emit SuccessEvent();
            return _success;
        } catch Error(string memory reason) {
            emit CatchEvent(reason);
        }
    }

    function executeNew(uint a) external returns (bool success) {
        try new OnlyEven(a) returns (OnlyEven _even) {
            emit SuccessEvent();
            success = _even.onlyEven(a);
        } catch Error(string memory reason) {
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            emit CatchByte(reason);
        }
    }
}
