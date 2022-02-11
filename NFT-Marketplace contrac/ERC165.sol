// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interfaces/IERC165.sol";

contract ERC165 is IERC165{

    mapping(bytes4 => bool) private _supportedInterfaces;


    constructor(){
        _registerInterface(bytes4(keccak256("supportsInterface(bytes4)")));
    }

     function supportsInterface(bytes4 interfaceId) external  view override returns (bool){
         return _supportedInterfaces[interfaceId];
     }

     function _registerInterface(bytes4 interfaceId) internal {
         require(interfaceId != 0xffffffff,"Invalid Interface Request");
         _supportedInterfaces[interfaceId] = true;
     }
}