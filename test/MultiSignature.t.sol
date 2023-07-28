// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from"../lib/forge-std/src/Test.sol";
import  {console} from "../lib/forge-std/src/console.sol";
import "../src/MultiSignatureWallet.sol";

contract testingMultiSig is Test {
    address TestAddr = makeAddr("TestAddr");

    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );

    event ConfirmTransaction(address indexed owner, uint indexed txIndex);


    MultiSigWallet wallet;

    function setUp() public {

        address[] memory addressArray = new address[](5);
        addressArray[0] = address(1);
        addressArray[1] = address(2);
        addressArray[2] = address(3);
        addressArray[3] = address(4);
        addressArray[4] = address(5);

        wallet = new MultiSigWallet(addressArray,3);
    }

    function testOwners() public{

        assertEq(wallet.owners(0),address(1));
        assertEq(wallet.owners(1),address(2));
        assertEq(wallet.owners(2),address(3));
        assertEq(wallet.owners(3),address(4));
        assertEq(wallet.owners(4),address(5));
        assertEq(wallet.getarraylenght(),5);

    }

    function testFailtmapping() public{
        assertEq(wallet.isOwner(address(1)),true);
        assertEq(wallet.isOwner(address(100)),true);
    }

    function testStructs() public {
        vm.startPrank(address(1));
        vm.expectEmit(true,true,true,true);
        emit SubmitTransaction(address(1),0,address(100),100,"0x00");
        wallet.submitTransaction(address(100),100,"0x00");

        vm.stopPrank();
       (address _to,uint256 _value,,,) = wallet.transactions(0);
        assertEq(_value,100);
        assertEq(_to,address(100));
        assertEq(wallet.Transactionslenght(),1);
        
    }

    function testConfirmTransaction() public {
        vm.startPrank(address(1));
        wallet.submitTransaction(TestAddr,100,"0x00");
        //wallet.confirmTransaction(0);
        vm.stopPrank();
    
        (address _to,uint _value,,,) = wallet.transactions(0);
        assertEq(_to,TestAddr);
        assertEq(_value,100);

        //Now lets test the confirmation process
        vm.startPrank(address(1));
        vm.expectEmit(true,true,false,false);
        emit ConfirmTransaction(address(1),0);
        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.startPrank(address(2));
        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.startPrank(address(3));
        wallet.confirmTransaction(0);
        vm.stopPrank();


        (,,,,uint _numConfirmations) = wallet.transactions(0);
        //assertEq(_numConfirmations,1);
        console.log("number of confirmations are : ",_numConfirmations);

        vm.startPrank(address(5));
        wallet.executeTransaction(0);
        vm.stopPrank();
        (,,,bool _executed,) = wallet.transactions(0);
        assertEq(_executed,true);

    }





}
