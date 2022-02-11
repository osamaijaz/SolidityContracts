//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;


contract Lottery{
     

    address payable[] players;
    address public immutable owner;

    
        constructor(){
            owner = msg.sender;
        
        }
function getCount() public view returns(uint count) {
    return players.length;
}

 receive() external payable{
        
             players.push(payable(msg.sender));
     }


    modifier isOwner(){
        require(owner == msg.sender,"You are not owner");
        _;
    }

    function checkBalance() view public isOwner returns(uint){
        return address(this).balance;
    }

    function openLottery()  public isOwner {
        if(players.length >= 3){
        uint y= uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % players.length ;
        address payable Winner = players[y];
        players = new address payable[](0);
        Winner.transfer(address(this).balance);

        }

    } 
}