// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

library Events {
    
   event ContentCreated( uint newTokenId, address indexed _addrs,  string timestamp);
    event ContentShared(uint _tokenId, address indexed _addr, address _recipient);
    event GroupCreatedSuccessfully(address indexed _addr, uint _groupId);
    event GroupJoinedSuccessful(address indexed _addr, uint _groupId );
    event MediaDeletedSuccessful(address indexed _addr, uint _nftId);



}