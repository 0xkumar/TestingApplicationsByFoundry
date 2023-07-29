// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import "../src/MultiSignatureWallet.sol";

contract MultiSigTest is Test {
    uint256 mainnetFork;
    uint256 optimismFork;

    function setUp() public {

        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        optimismFork = vm.createFork(OPTIMISM_RPC_URL);
    }

    function testForkIdDiffer() public {
        assert(mainnetFork != optimismFork);
        // console.log(MAINNET_RPC_URL);
    }

    function testCanSelectFork() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
    }

    function testCanSwitchForks() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), optimismFork);
    }

    function testCanCreateAndSelectForkInOneStep() public {
        uint256 anotherFork = vm.createSelectFork(MAINNET_RPC_URL);
        assertEq(vm.activeFork(), anotherFork);
    }

    function testCanSetForkBlockNumber() public {
        vm.selectFork(mainnetFork);
        vm.rollFork(1_337_000);
    }
}
