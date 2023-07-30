// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract MultiSigTest is Test {
    uint256 mainnetFork;
    uint256 optimismFork;

    //vm.createFork() cheatcode is used to create a fork for a mainnet or any other network.abi
    //vm.selectFork() cheatcode is used to select a fork for the current test.
    function setUp() public {

        mainnetFork = vm.createFork('https://eth-mainnet.g.alchemy.com/v2/ZQdKORYAIJfSwtXt4pm1S5k5slGjXNki');
        optimismFork = vm.createFork('https://eth-sepolia.g.alchemy.com/v2/Tqg0mY345xQSJihMD4ar4S11E1GMUhvQ');
    }

    function testForkIdDiffer() public {
        assert(mainnetFork != optimismFork);
        console.log(mainnetFork, optimismFork);
    }

    function testCanSelectFork() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
    }

    function testCanSwitchForks() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);

        vm.selectFork(optimismFork);
        assertEq(vm.activeFork(), optimismFork);
    }

    function testCanCreateAndSelectForkInOneStep() public {
        uint256 anotherFork = vm.createSelectFork('https://eth-mainnet.g.alchemy.com/v2/ZQdKORYAIJfSwtXt4pm1S5k5slGjXNki');
        assertEq(vm.activeFork(), anotherFork);
    }

    function testCanSetForkBlockNumber() public {
        vm.selectFork(mainnetFork);
        vm.rollFork(1_337_000);
    }
}
