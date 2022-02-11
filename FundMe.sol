//SPDX-License-Identifier:MIT

pragma solidity >= 0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{

    using SafeMathChainlink for uint256;

mapping (address => uint256) public addressToAmountFunded;

address public owner;
  

address [] public funders;

        constructor() public{

            owner = msg.sender;

        }



function fund() public payable{

    uint256 minimunUSD = 50 *10 *18;    

     require(getCoversionRate(msg.value)>= minimunUSD,"You need to spend more ETH");

    addressToAmountFunded[msg.sender]+= msg.value;
    funders.push(msg.sender);
}

      function getVersion() public view returns(uint256){
 AggregatorV3Interface priceFeed = AggregatorV3Interface(0x46112cA072ab0f392921429B87D2A21Eed199cBd);
    return priceFeed.version();

}

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x46112cA072ab0f392921429B87D2A21Eed199cBd);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000); 
    }

    function getCoversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount)/ 1000000000000000000;
        return ethAmountInUsd;
    }

    modifier onlyOwner{

 require(msg.sender == owner);
 _;


    }
    function withdraw() payable onlyOwner public{
       
        msg.sender.transfer(address(this).balance);
        for(uint256 fundIndex=0; fundIndex< funders.length; fundIndex++)
        {
            address funder = funders[fundIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}

