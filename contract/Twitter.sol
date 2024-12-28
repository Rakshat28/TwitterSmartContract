//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Twitter{
    struct Tweet{
        uint id;
        address author;
        string content;
        uint timestamp;
        uint likes;
    }

    uint16 public MAX_TWEET_LENGTH = 280;

    mapping(address => Tweet[]) public tweets;

    address public owner;

    event TweetCreated(uint id,address author,string content,uint timestamp);
    event TweetLiked(address liker, address author , uint tweetId, uint newLikeCount);
    event TweetUnLiked(address unliker, address author, uint tweetId, uint newLikeCount);

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner , "You are not the owner");
        _;
    }

    function createTweet(string memory _tweet) public{
        require(bytes(_tweet).length<=MAX_TWEET_LENGTH,"the tweet should be less than 280 characters");
        Tweet memory newTweet = Tweet({
            id : tweets[msg.sender].length,
            author : msg.sender,
            content : _tweet,
            timestamp : block.timestamp,
            likes : 0
        });
        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.author,newTweet.content,newTweet.timestamp);
    }

    function likeTweet(uint _id , address _author) external{
        require(tweets[_author][_id].id == _id , "Tweet does not exist" );
        tweets[_author][_id].likes++;
        emit TweetLiked(msg.sender , _author, _id , tweets[_author][_id].likes);
    }
    function unlikeTweet(uint _id , address _author) external{
        require(tweets[_author][_id].id == _id,"Tweet does not exist");
        require(tweets[_author][_id].likes>0 , "The tweet has no likes");
        tweets[_author][_id].likes--;
        emit TweetUnLiked(msg.sender,_author,_id,tweets[_author][_id].likes);

    }

    function changeMaxTweetLength(uint16 _newTweetMaxLength) public onlyOwner{
        MAX_TWEET_LENGTH = _newTweetMaxLength;
    }

    function getTweet(uint _i) public view returns(Tweet memory){
        return tweets[msg.sender][_i];
    }

    function getAllTweets() public view returns(Tweet[] memory){
        return tweets[msg.sender];
    }


}