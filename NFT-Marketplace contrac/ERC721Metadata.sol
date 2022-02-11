// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interfaces/IERC721Metadata.sol";
import "./ERC165.sol";
contract ERC721Metadata is IERC721Metadata, ERC165 {
    
    string private _name;

    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _registerInterface(bytes4(keccak256("name(bytes4)")^keccak256("symbol(bytes4)")));
    
        _name = name_;
        _symbol = symbol_;
    }
   
    function name() public view override returns  (string memory) {
        return _name;
    }


    function symbol() public view override returns (string memory) {
        return _symbol;
    }
}