// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {SimpleStorageContract} from "../src/SimpleStorageContract.sol";


//Test for the SimpleStorageContract.sol
contract SimpleStorageContractTest is Test {

    uint256 mainnetFork;
    uint256 sepoliaFork;

    function setUp() public {
        mainnetFork = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/ZQdKORYAIJfSwtXt4pm1S5k5slGjXNki");
        sepoliaFork = vm.createFork("https://eth-sepolia.g.alchemy.com/v2/Tqg0mY345xQSJihMD4ar4S11E1GMUhvQ");
    }

    function testCreateContract() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
        SimpleStorageContract simplestorage = new SimpleStorageContract();
        simplestorage.set(100);
        console.log(simplestorage.value());
        assertEq(simplestorage.value(),100);
    }

    function testCreateContractOnSepolia() public {
        vm.selectFork(sepoliaFork);
        assertEq(vm.activeFork(), sepoliaFork);
        SimpleStorageContract simplestorage = new SimpleStorageContract();
        simplestorage.set(123);
        console.log(simplestorage.value());
        assertEq(simplestorage.value(),123);
    }
}