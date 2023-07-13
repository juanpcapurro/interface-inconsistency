// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";

interface IFoo {
    function foo(uint256 a, uint256 b) external returns (uint256);
}

contract Foo is IFoo {
    function foo(uint256 b, uint256 a) external returns (uint256) {
        b;
        return a;
    }
}

contract ContractUser {
    Foo private foo;

    constructor(Foo c) {
        foo = c;
    }

    function use() external returns (uint256) {
        return foo.foo({a: 1, b: 2});
    }
}

contract InterfaceUser {
    IFoo private generic;

    constructor(IFoo c) {
        generic = c;
    }

    function use() external returns (uint256) {
        return generic.foo({a: 1, b: 2});
    }
}

contract CounterTest is Test {
    function testInterface() public {
        Foo foo = new Foo();
        InterfaceUser c = new InterfaceUser(foo);
        assertEq(c.use(), 2);
    }

    function testContract() public {
        Foo foo = new Foo();
        ContractUser c = new ContractUser(foo);
        assertEq(c.use(), 1);
    }
}
