// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./Interfaces/IERC721.sol";


contract ERC721 is ERC165,IERC721 {

    mapping ( uint256=> address) _tokenOwner;
    mapping (address=>uint256) _OwnedTokensCount;
    mapping (uint256 => address) private _tokenApprovals;


  
       constructor(){
        _registerInterface(bytes4(keccak256("balanceOf(bytes4)")^keccak256("ownerOf(bytes4)")^keccak256("transferFrom(bytes4)")));
    }



    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }
    
  
    function balanceOf(address _owner) public view override returns(uint256) {
         require(_owner != address(0),"Address cannot be zero");
        return _OwnedTokensCount[_owner];
    }

    function ownerOf(uint256 tokenId) override public  view returns(address){
          address owner = _tokenOwner[tokenId];
          require(owner != address(0),"Address cannot be zero");
        return owner;
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0),"Address cannot be zero");
        require(!_exists(tokenId),"It already Minted");
        _tokenOwner[tokenId] = to;
        _OwnedTokensCount[to] += 1;
         emit Transfer(address(0), to, tokenId);   
    }

    


    function _transferFrom(address _from,address _to, uint256 _tokenId) internal  {
        require(_to != address(0),"Adress cannot be zero");
        require(ownerOf(_tokenId) == _from,"owner does not exist");
         _OwnedTokensCount[_from] -= 1;
         _OwnedTokensCount[_to] += 1;

         _tokenOwner[_tokenId] = _to;

         emit Transfer(_from,_to,_tokenId);



    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender,_tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 tokenId) public  {
        address owner = ownerOf(tokenId);
        require(_to != owner," Cannot approve to owner itself");
        require(msg.sender == owner,"Current caller is not the owner");
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId),"Token does not exist");
        address owner = ownerOf(tokenId);
        return (spender == owner );
    }




}