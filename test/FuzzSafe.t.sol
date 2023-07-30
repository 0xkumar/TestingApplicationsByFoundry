// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Safe} from "../src/Safe.sol";

contract FuzzSimpleStorage is Test {
    Safe safe;


    function setUp() public{
        safe = new Safe();
    }

    receive() external payable {}

    //UNIT TEST
    function testWithdraw() public {
        //vm.deal(address(this),100 ether);
        uint256 balanceBefore = address(this).balance;
        console.log(address(this).balance);
        payable(address(safe)).transfer(1 ether);
        console.log("balance after transfer to safe contract",address(this).balance);
        safe.withdraw();
        console.log("balance After Withdraw",address(this).balance);
        assertEq(address(this).balance ,balanceBefore);

    }

    // FUNZZING THE WITHDRAW FUNCTION
    function testFuzz_Withdraw(uint256 amount) public {
        vm.assume(amount < 0.1 ether);
        payable(address(safe)).transfer(amount);
        uint256 preBalance = address(this).balance;
        safe.withdraw();
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + amount,postBalance);
    }
}
