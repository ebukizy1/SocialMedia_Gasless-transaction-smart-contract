// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

interface ISocialRoom{



    struct Group {
        uint groupId;
        string name;
        string mediaUrl;
        address[] groupMembers;
    }

    enum MediaType{
        Video, Music, Image
    }

    struct MediaNFT {
        uint mediaId;
        address creatorAdr;
        string title;
        uint createdTime;
        string urlMedia;
         bool isVerified;
         uint likes;
        MediaType mediaType;
        Comment[] comments; // Storing the IDs of comments associated with the media
    }   

    struct Comment {
        uint commentId;
        address commenter;
        string content;
        uint commentedAt;
    }

      enum Role {
        Admin,
        Moderator
    }



    struct User{
        uint userId;
        string username;
        address[] followers;
        address[] following;
        bool isAdmin;
        bool isModerator;
    }



}