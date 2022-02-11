// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";


contract Cryptobird is ERC721Connector {

    string[] public CryptoBird;
    mapping(string => bool) _CryptobirdExists;
    uint counter = 0;
    uint public numberOfVotes = 0;
    mapping(address => bool) voters;
    address[] votersAddresses ;

    constructor() ERC721Connector("Cryptobird","CRB" ){}
    
   function mint(string memory _Cryptobird) public  {
                require(!_CryptobirdExists[_Cryptobird],"It already Exists");
              CryptoBird.push(_Cryptobird);
              uint _id = CryptoBird.length -1;  
              _mint(msg.sender, _id);

    }

    function voting(address voter) public {
           uint check = balanceOf(voter);
           require(voters[voter]== false,"You have already voted");
           require(check > 2,"balance amount is less");
           voters[voter] = true;
           votersAddresses.push(voter);
           numberOfVotes++; 
    }
   
    function DeleteAddress(address TobeDeleted) public {
       require(numberOfVotes > 50,"Votes are not enough");
       removeUser(TobeDeleted);
    }


    function resetVoting() public  {
          numberOfVotes = 0;
          for(uint index= 0; index <= votersAddresses.length; index++){
             voters[votersAddresses[index]] = false; 
          }
          for(uint index= 0; index <= votersAddresses.length; index++){
                     votersAddresses.pop(); 
          }
    }


}

