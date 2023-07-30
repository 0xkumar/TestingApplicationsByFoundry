// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Safe {
    receive() external payable {}
    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
