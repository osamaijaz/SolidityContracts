// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC721 {
   
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

  
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

   
    function balanceOf(address _owner) external view returns (uint256);


    function ownerOf(uint256 _tokenId) external view returns (address owner);

    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

   
   // function approve(address to, uint256 tokenId) external;

   
   // function getApproved(uint256 tokenId) external view returns (address operator);

    
   // function setApprovalForAll(address operator, bool _approved) external;

   
   // function isApprovedForAll(address owner, address operator) external view returns (bool);

   
//    function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId,
//         bytes calldata data
//     ) external;
}