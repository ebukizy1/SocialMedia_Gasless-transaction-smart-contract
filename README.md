
# EmaxSocialRoomNFT Contract README
# Overview
This README provides information about the EmaxSocialRoomNFT contract, which is a Solidity smart contract written for managing social media content creation, moderation, and interaction with NFTs. The contract is designed to work with the Emax ecosystem, incorporating features like user registration, content creation, moderation, and group management.

# Contract Addresses
Make sure to replace the placeholder values below with the actual contract addresses deployed on the Ethereum blockchain.

# NFT Token Contract Address: 0x7a2b674a87375d00c250772A311FB027f0366C14
# Factory Contract Address: 0xc2b9E8eC0eB83aCBA2Df9472bEC66284Bc6D87cd
# Social Media Contract Address: 0x4F1d3d148696d361671cCF2F435683758e992926
Contract Structure
# Main Features
# User Registration:

Users can register with a unique username.
The contract ensures that usernames are not empty and are unique.
# Content Creation:

Registered users can create content, including specifying the title, media type, and media URL.
The created content is associated with an NFT, and the NFT is minted using the SocialMediaFactory.
# Content Verification:

Moderators can verify content created by users.
# Content Sharing:

Users can share their created content with others.
# Group Creation:

Moderators can create groups, defining a group name and associated media URL.
NFTs are minted for the creator of the group using the SocialMediaFactory.
# Group Joining:

Users can join existing groups.
# Moderator Functions:

Moderators have special privileges, including viewing all media NFTs and creating groups.
# Like and Comment:

Users can like posts, and everyone can comment on media.
# Role Management:

The contract supports the assignment of roles such as Admin and Moderator.
# Admins can grant roles to users.
Contract Addresses Initialization
When deploying the contract, ensure to set the addresses of the NFT token, factory, and social media contracts in the constructor.
Functions
# User Management
registerUser(string memory _username) external: Allows users to register with a unique username.
# Content Creation and Interaction
# createContent(string memory _title, MediaType _mediaType, string memory _mediaUrl) external: Enables registered users to create content.
# verifyContent(uint _id, address _user) external: Allows moderators to verify content.
# shareContent(uint _tokenId, address _recipient) external: Permits users to share their content with others.
# likePost(uint256 _postId, address _postOwner) external: Allows users to like posts.
commentOnMedia(address _mediaOwner,uint _mediaId,string memory _content) external: Allows everyone to comment on media.
# Group Management
# createGroup(string memory groupName, string memory _mediaUrl) external: Allows moderators to create groups.
# deleteGroup(uint _groupId) external: Allows the creator of a group to delete it.
# joinGroup(address _groupCreator, uint _groupId) external: Allows users to join groups.
#Moderation and Information Retrieval
moderatorGetAllMediaNft() external view returns (MediaNFT[] memory): Allows moderators to view all media NFTs.
UsersgetPosts() external view returns (MediaNFT[] memory): Allows users to view their own posts.
searchMediaByOwner(uint _nftId) external view returns (MediaNFT memory): Allows content creators to search for media by ID.
searchMedia(address _ownerAddres, uint _nftId) external view returns (MediaNFT memory): Allows users to search for media by owner and ID.
Role Management
grantRole(Role _roleType, address _account) external: Allows Admins to grant roles to users.
Important Notes
Replace placeholder contract addresses with actual addresses when deploying.
Ensure that the contracts are deployed in the specified order: NFT Token, Factory, and Social Media contracts.
The contract assumes the presence of the SocialMediaFactory contract at the specified address for NFT minting.
