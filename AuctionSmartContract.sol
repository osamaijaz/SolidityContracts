//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;


contract auctionCreater{

        Auction[] public auctions;

        function createAuction() public {
            Auction newAuction = new Auction(msg.sender);
            auctions.push(newAuction);
        }


}



contract Auction{

    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;


    enum State{Started,Running,Ended,Canceled}
    State public auctionState;

    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;
    uint Bidincrement;


    constructor(address EOA ){
        owner = payable(EOA);
        auctionState = State.Running;
        ipfsHash = "";
        startBlock = block.number;
        endBlock = startBlock + 40320;
        Bidincrement = 100; 
    }

    modifier Owner(){
            require(msg.sender == owner,"You are not owner");
            _;
    }  
    modifier notOwner(){
            require(msg.sender != owner,"Owner cannot call");
            _;
    }
      modifier afterStart(){
           require(block.number >= startBlock);
            _;
        
    }
      modifier beforeEnd{
          require(block.number <= endBlock);
            _;
    }

    function min(uint a, uint b) pure internal returns(uint){
            if(a <= b){
              return a;
            }
            else{
                return b;
            }
    }

    function cancelAuction() public Owner{
        auctionState = State.Canceled;
    }


    function placeBid() public payable notOwner afterStart beforeEnd{
        require(auctionState == State.Running);
        require(msg.value > 100);

        uint currentBid = bids[msg.sender] + msg.value;
        bids[msg.sender] = currentBid;

        if(currentBid <= bids[highestBidder]){
        highestBindingBid = min(currentBid + Bidincrement, bids[highestBidder]);
        }
        else{
        highestBindingBid = min(currentBid , bids[highestBidder] + Bidincrement);
        highestBidder = payable(msg.sender);

        }
    }

    
     function finalizeAuction() public {
       require(auctionState == State.Canceled || block.number > endBlock);
       require (msg.sender == owner || bids[msg.sender] > 0);

        address payable recipient;
        uint value;

        if(auctionState == State.Canceled){
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        }      
        else{
                if(msg.sender == owner){
                recipient = owner;
                value = highestBindingBid;
                }
                else{
                    if(msg.sender == highestBidder){
                        recipient = highestBidder;
                        value = bids[highestBidder] - highestBindingBid;
                    }else{
                        recipient = payable(msg.sender);
                        value = bids[msg.sender];
                    }
                }    
            }
            bids[recipient] = 0;
            recipient.transfer(value);
     }
 
     
}