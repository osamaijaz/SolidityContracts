// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract Gas{

        address public owner;
        uint public start;
        constructor()  {
                owner = msg.sender;
                start = gasleft();

        }

       modifier  ownable() {
            require(owner == msg.sender,"Not owner");
            _;

        }

        function changeOwner(address _newOwner) public ownable {
                owner = _newOwner;
        }

        function gasEstimation() public view returns (uint){
               // uint start = gasleft();
              uint j=1;
              for(uint i=0; i<30; i++){
                  j*=1;
              }
              return gasleft();
        }

        function GasR() view public returns(uint) {
                return gasleft();
              
        }


}