// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interface/ISocialNft.sol";
// import "./SocialNft.sol";

contract SocialMediaFactory{
     address private socialNft;


    constructor(address _addr) {
        socialNft =_addr;
    }


    
    
    function createNfts(address _to, string memory metaData) external{
       ISocialNft(socialNft).safeMint(_to,  metaData);
    }

}

