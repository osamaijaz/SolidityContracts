// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract EtherWallet{

        address payable public owner;


        constructor(){
            owner = payable(msg.sender);
        }

        receive() external payable{}

        function withDraw(uint amount) external{
            require(owner == msg.sender,"worng owner");
            payable(msg.sender).transfer(amount);
        }

        function getBalance() external view returns(uint){
            return address(this).balance;

        }




}