// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./SocialFactory.sol";

import "../library/Events.sol";
import "../interface/ISocialRoom.sol";
import "../library/ErrorMessage.sol";

contract EmaxSocialRoomNFT is ISocialRoom {
    using Events for *;
    using ErrorMessage for *;


    SocialMediaFactory private socialFactory;
    uint private tokenIdCounter;
    address private owner;



    mapping(address => mapping(address => bool)) isFollowing;
    mapping(address => mapping(Role => bool)) hasRole;
    mapping(address => mapping(uint => bool)) hasCommented;
    mapping(address => mapping(uint => bool)) hasLiked;
    mapping(address => mapping(uint => MediaNFT)) userCreatedMedia;
    mapping(address => bool) public hasRegistered;
    mapping(address => User) public registerUsers;
    mapping(address => Group) userGroups;


    MediaNFT[] public allMedia;
    MediaNFT[] public verifiedMedia;
    User[] public usersArray;
    Group[] public groupArray;


    constructor(address addr) {
        owner = msg.sender;
        socialFactory = SocialMediaFactory(addr);
    }

    uint nftId;
    uint userId;
    uint groupId;
    uint commentId;


    function registerUser(string memory _username) external {
        require(bytes(_username).length > 0, "Username cannot be empty");

        ZERO_ADDRESS_CHECK(msg.sender);

        require(!hasRegistered[msg.sender], "Have already registered");

        uint _userId = userId + 1;
        User storage user = registerUsers[msg.sender];
        user.userId = _userId;
        user.username = _username;
        hasRegistered[msg.sender] = true;
        userId += 1;

        usersArray.push(user);
    }



    function createContent(string memory _title, MediaType _mediaType, string memory _mediaUrl) external {
        ZERO_ADDRESS_CHECK(msg.sender);

        require(hasRegistered[msg.sender], "Register to be able to create post");

        uint newTokenId = tokenIdCounter + 1;
        MediaNFT storage _newNft = userCreatedMedia[msg.sender][newTokenId];
        _newNft.mediaId = newTokenId;
        _newNft.creatorAdr = msg.sender;
        _newNft.title = _title;
        _newNft.createdTime = block.timestamp;
        _newNft.urlMedia = _mediaUrl;
        _newNft.mediaType = _mediaType;
        

        socialFactory.createNfts(msg.sender, _newNft.urlMedia);
        allMedia.push(_newNft);
        tokenIdCounter++;
        emit Events.ContentCreated(newTokenId, msg.sender, _newNft.urlMedia);
    }

    function verifyContent(uint _id, address _user) external {
        onlyModerator();
        MediaNFT storage post = userCreatedMedia[_user][_id];
        require(!post.isVerified, "already verified");

        post.isVerified = true;

        verifiedMedia.push(post);
    }

       function shareContent(uint _tokenId, address _recipient) external {
        require(hasRegistered[msg.sender], "you have to be registered");
        require(
            userCreatedMedia[msg.sender][_tokenId].mediaId != 0,
            "you dont have a media"
        );
        require(_tokenId <= tokenIdCounter, "Invalid tokenId");

        MediaNFT storage sharedNft = userCreatedMedia[msg.sender][_tokenId];

        require(
            sharedNft.creatorAdr == msg.sender,
            "Only the creator can share the content"
        );

        socialFactory.createNfts(_recipient, sharedNft.urlMedia);

        emit Events.ContentShared(_tokenId, msg.sender, _recipient);
    }


    function moderatorGetAllMediaNft() external view returns (MediaNFT[] memory){
        onlyModerator();
        return allMedia;
    }


    function UsersgetPosts() external view returns (MediaNFT[] memory) {
        return allMedia;
    }


    //only admin will be able to create groups
    function createGroup(string memory groupName,  string memory _mediaUrl ) external {


        onlyModerator();
        uint newId = groupId + 1;
        Group storage _newGroup = userGroups[msg.sender];
        _newGroup.groupId = newId;
        _newGroup.mediaUrl = _mediaUrl;
        _newGroup.name = groupName;
        groupArray.push(_newGroup);

        //mint nft for the person who create the group
        socialFactory.createNfts(msg.sender, _newGroup.mediaUrl);

        emit Events.GroupCreatedSuccessfully(msg.sender, _newGroup.groupId);
    }

    //only creator of media can access this function
    function searchMediaByOwner(
        uint _nftId
    ) external view returns (MediaNFT memory) {
        return userCreatedMedia[msg.sender][_nftId];
    }

    //only creator of media can access this function
    function deleteMediaByOwner(uint _nftId) external {
        require(hasRegistered[msg.sender], "you have to be registered");
        require(
            userCreatedMedia[msg.sender][_nftId].mediaId != 0,
            "you dont have a media"
        );
        delete userCreatedMedia[msg.sender][_nftId];
        emit Events.MediaDeletedSuccessful(msg.sender, _nftId);
    }

    //every one can comment on media
    function commentOnMedia(address _mediaOwner,uint _mediaId,string memory _content) external {
        require(hasRegistered[msg.sender],"Register to be able to comment on post");
        require(!hasCommented[msg.sender][_mediaId],"already  commented on media" );

        uint _commentId = commentId + 1;
        Comment memory _comment = Comment({
            commentId: _commentId,
            commenter: msg.sender,
            content: _content,
            commentedAt: block.timestamp
        });

        MediaNFT storage _foundMedia = userCreatedMedia[_mediaOwner][_mediaId];
        _foundMedia.comments.push(_comment);
    }

    function likePost(uint256 _postId, address _postOwner) external {
        require(hasRegistered[msg.sender], "Register to be able to like post");

        require(!hasLiked[msg.sender][_postId], "already liked post");

        MediaNFT storage post = userCreatedMedia[_postOwner][_postId];

        post.likes = post.likes + 1;

        hasLiked[msg.sender][_postId] = true;
    }

    function followUser(address _userToFollow) public {
        require(  bytes(registerUsers[_userToFollow].username).length > 0, "User not registered" );

        require(!isFollowing[msg.sender][_userToFollow], "Already following");

        registerUsers[msg.sender].following.push(_userToFollow);

        isFollowing[msg.sender][_userToFollow] = true;

        registerUsers[_userToFollow].followers.push(msg.sender);
    }

    //every one can call this function
    function searchMedia(  address _ownerAddres, uint _nftId ) external view returns (MediaNFT memory) {
        require(hasRegistered[msg.sender], "you have to be registered");

        return userCreatedMedia[_ownerAddres][_nftId];
    }

    // only the person who create this group can delete it
    function deleteGroup(uint _groupId) external {
        onlyModerator();
        Group storage _foundGroup = userGroups[msg.sender];
        require(_foundGroup.groupId == _groupId, "invalid group id");
        delete userGroups[msg.sender];
    }

    //any body can join group
    function joinGroup(address _groupCreator, uint _groupId) external {
        require(hasRegistered[msg.sender], "you have to be registered");
        Group storage _foundGroup = userGroups[_groupCreator];
        require(_foundGroup.groupId == _groupId, "invalid group created");
        _foundGroup.groupMembers.push(msg.sender);

        //for any body that joins group an nft will be minted for you
        socialFactory.createNfts(msg.sender, _foundGroup.mediaUrl);

        emit Events.GroupJoinedSuccessful(msg.sender, _foundGroup.groupId);
    }

 

    function onlyOwner(address _addr) private view {
        ZERO_ADDRESS_CHECK(_addr);

        require(_addr == owner, "not authorized");
    }

    function onlyAdmin() private view {
        require(
            hasRole[msg.sender][Role.Admin],
            "Restricted to content creators"
        );
    }

    // Only users with the Admin role can create groups
    function onlyModerator() private view {
        require(
            hasRole[msg.sender][Role.Moderator],
            "Restricted to moderators"
        );
    }
     function ZERO_ADDRESS_CHECK(address _sender) private pure {
        if (_sender == address(0)) {
            revert ErrorMessage.ZERO_ADDRESS_ERROR();
        }
    }

    function grantRole(Role _roleType, address _account) external {
        onlyOwner(msg.sender);

        require(hasRegistered[_account], "not a valid user address");

        if (_roleType == Role.Admin) {
            require(!hasRole[_account][Role.Admin], "already has a role");

            User storage newAdmin = registerUsers[_account];

            newAdmin.isAdmin = true;
            hasRole[_account][Role.Admin] = true;
        }
        if (_roleType == Role.Moderator) {
            require(!hasRole[_account][Role.Moderator], "already has a role");

            User storage newAdmin = registerUsers[_account];

            newAdmin.isModerator = true;
            hasRole[_account][Role.Moderator] = true;
        } else {
            revert("no role available");
        }
    }
}
