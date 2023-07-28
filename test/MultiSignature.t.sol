// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import "../src/MultiSignatureWallet.sol";

contract testingMultiSig is Test {
    address TestAddr = makeAddr("TestAddr");
    //vm.deal(TestAddr,100 ether);

    event SubmitTransaction(
        address indexed owner, uint256 indexed txIndex, address indexed to, uint256 value, bytes data
    );

    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);

    event Deposit(address indexed sender, uint256 amount, uint256 balance);

    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);

    MultiSigWallet wallet;

    fallback() external payable {}

    receive() external payable {}

    function setUp() public {
        address[] memory addressArray = new address[](5);
        addressArray[0] = address(1);
        addressArray[1] = address(2);
        addressArray[2] = address(3);
        addressArray[3] = address(4);
        addressArray[4] = address(5);

        wallet = new MultiSigWallet(addressArray,3);
        hoax(TestAddr, 100 ether);
        payable(address(wallet)).transfer(10 ether);
        
    }

    // function testReveive() public {

    //     console.log("Balance of MultiSigWallet is :",address(wallet).balance);
    // }


    function testOwners() public {
        assertEq(wallet.owners(0), address(1));
        assertEq(wallet.owners(1), address(2));
        assertEq(wallet.owners(2), address(3));
        assertEq(wallet.owners(3), address(4));
        assertEq(wallet.owners(4), address(5));
        assertEq(wallet.getarraylenght(), 5);
    }

    function testFailtmapping() public {
        assertEq(wallet.isOwner(address(1)), true);
        assertEq(wallet.isOwner(address(100)), true);
    }

    function testStructs() public {
        vm.startPrank(address(1));
        vm.expectEmit(true, true, true, true);
        emit SubmitTransaction(address(1), 0, address(100), 100, "0x00");
        wallet.submitTransaction(address(100), 100, "0x00");

        vm.stopPrank();
        (address _to, uint256 _value,,,) = wallet.transactions(0);
        assertEq(_value, 100);
        assertEq(_to, address(100));
        assertEq(wallet.Transactionslenght(), 1);
    }

    function testConfirmTransaction() public {
        vm.startPrank(address(1));
        wallet.submitTransaction(address(this), 100,"somedata");
        //wallet.confirmTransaction(0);
        vm.stopPrank();

        (address _to, uint256 _value,,,) = wallet.transactions(0);
        assertEq(_to, address(this));
        assertEq(_value, 100);

        //Now lets test the confirmation process
        vm.startPrank(address(1));
        vm.expectEmit(true, true, false, false);
        emit ConfirmTransaction(address(1), 0);
        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.startPrank(address(2));
        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.startPrank(address(3));
        wallet.confirmTransaction(0);
        vm.stopPrank();

        (,,,, uint256 _numConfirmations) = wallet.transactions(0);
        //assertEq(_numConfirmations,1);
        console.log("number of confirmations are : ", _numConfirmations);

        vm.startPrank(address(5));
        vm.expectEmit(true,true,false,false);
        emit ExecuteTransaction(address(5),0);
        wallet.executeTransaction(0);
        vm.stopPrank();
        (,,, bool _executed,) = wallet.transactions(0);
        assertEq(_executed, true);
        (address to,uint value,bytes memory data, bool executed,uint numConfirmations) = wallet.getTransaction(0);
        console.log(to,value,executed,numConfirmations);
     

    }

    function testRevokeTransaction() public {
        //vm.deal(address(1),100 ether);
        vm.startPrank(address(1));
        wallet.submitTransaction(address(100),100,"0x00");

        wallet.confirmTransaction(0);
        (,,,,uint _numConfirmations) = wallet.transactions(0);
        console.log("number of confirmations Before Revoke are :",_numConfirmations);

        wallet.revokeConfirmation(0);
        vm.stopPrank();

        (,,,, uint256 numConfirmations) = wallet.transactions(0);
        console.log("Number of confirmations After Revoke are  : ", numConfirmations);


    }
    function testTransactionCount() public {
        console.log("Total Transactions are : ", wallet.getTransactionCount());
    }

    // function testGetTransaction() public  view returns (address to, uint256 value, bytes memory data, bool executed, uint256 numConfirmations){
    //     (to,value, data,executed,numConfirmations) = wallet.getTransaction(0);
    //     return (to,value,data,executed,numConfirmations);
    // }



}
