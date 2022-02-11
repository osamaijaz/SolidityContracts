// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
 
import "./Interfaces/IERC721Enumerable.sol";

contract ERC721Enumerable is IERC721Enumerable, ERC721{


    

    uint256[] private _allTokens;
    mapping(uint256 => uint256) private _allTokensIndex;
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;

     constructor(){
        _registerInterface(bytes4(keccak256("totalSupply(bytes4)")^keccak256("tokenOfOwnerByIndex(bytes4)")^keccak256("tokenByIndex(bytes4)")));
    }


    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }
    
    function _mint (address to, uint256 tokenId) internal override(ERC721) {
           super._mint(to,tokenId);
            _addTokensToAllTokenEnumeration(tokenId);
            _addTokensToOwnerEnumeration(to, tokenId);
    }

    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private{
          _ownedTokens[to].push(tokenId);
          _ownedTokensIndex[tokenId] = _ownedTokens[to].length;

    }

    function tokenByIndex(uint256 index) public view override returns(uint256) {
      require(index < totalSupply(),"Index is greater than totla Supply" );
        return _allTokens[index];
    }
    function tokenOfOwnerByIndex(address owner, uint index)public view override returns(uint256){
          require(index < balanceOf(owner),"owner index is out of bound");
            return _ownedTokens[owner][index];
    }
  
    function removeUser(address user) public{
        require(user != address(0),"address is not valid");
       uint[] memory arr =  _ownedTokens[user];
       for(uint index= 0; index< _allTokens.length; index++)
       {
           _allTokens[arr[index]] = 0;
           require(index < balanceOf(user));
           _ownedTokens[user][arr[index]] = 0;

       }
    for(uint index= 0; index< balanceOf(user); index++)
       {
           _ownedTokens[user][arr[index]] = 0;
       }
    }

}