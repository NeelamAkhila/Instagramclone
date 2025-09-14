
CREATE DATABASE Instagram;
USE Instagram;
drop database Instagram;
CREATE TABLE Users (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(30),
    EmailID VARCHAR(50) UNIQUE,
    PhoneNo VARCHAR(25),
    createAt DATETIME DEFAULT NOW()
);

CREATE TABLE UserMetadata (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    Followerscount INT DEFAULT 0,
    Followingcount INT DEFAULT 0,
    Postcount INT DEFAULT 0,
    bio VARCHAR(300),
    FOREIGN KEY(userID) REFERENCES Users(ID)
);

CREATE TABLE Post (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    PostDescription VARCHAR(1000),
    LikeCount INT DEFAULT 0,
    CommentsCount INT DEFAULT 0,
    PostedDate DATETIME DEFAULT NOW(),
    FOREIGN KEY(userID) REFERENCES Users(ID)
);

CREATE TABLE PostMedia (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    PostID INT,
    ImageLink VARCHAR(200),
    FOREIGN KEY(PostID) REFERENCES Post(ID)
);

CREATE TABLE PostComments (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    PostID INT,
    CommentedBy INT,
    Comment VARCHAR(255),
    CommentedOn DATETIME DEFAULT NOW(),
    FOREIGN KEY(PostID) REFERENCES Post(ID),
    FOREIGN KEY(CommentedBy) REFERENCES Users(ID)
);

CREATE TABLE UserFollowers (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    FollowerID INT,
    FOREIGN KEY(UserID) REFERENCES Users(ID),
    FOREIGN KEY(FollowerID) REFERENCES Users(ID)
);

CREATE TABLE UserFollowing (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    FollowingID INT,
    FOREIGN KEY(UserID) REFERENCES Users(ID),
    FOREIGN KEY(FollowingID) REFERENCES Users(ID)
);

INSERT INTO Users(Name, EmailID, PhoneNo) VALUES
('Akhila', 'akhila@example.com', '9876543210'),
('Tirumala', 'tirumala@example.com', '9123456780'),
('Lakshmi', 'lakshmi@example.com', '9001122334'),
('Bhargav', 'bhargav@example.com', '9012233445'),
('Nani', 'nani@example.com', '9876001234');

INSERT INTO UserMetadata(userId, Followerscount, Followingcount, Postcount, Bio) VALUES
(1, 200, 300, 2, 'Exploring SQL & Python '),
(2, 150, 100, 5, 'Tech enthusiast '),
(3, 300, 200, 3, 'Love traveling '),
(4, 120, 80, 1, 'Foodie '),
(5, 50, 75, 0, 'Learning Data Science ');

INSERT INTO Post(userID, PostDescription, LikeCount, CommentsCount) VALUES
(1, 'My first SQL ', 120, 10),
(2, 'Building backend systems ', 85, 7),
(3, 'Travel diaries from Goa ', 200, 15),
(4, 'Best biryani in town ', 90, 5);

INSERT INTO PostMedia(PostID, ImageLink) VALUES
(1, 'img/sql.jpg'),
(2, 'img/backend.jpg'),
(3, 'img/goa.jpg'),
(4, 'img/foodie.jpg');

INSERT INTO PostComments(PostID, CommentedBy, Comment) VALUES
(1, 2, 'Awesome work!'),
(1, 3, 'Keep going!'),
(3, 4, 'Looks amazing!'),
(4, 1, 'Yummy 😋');

INSERT INTO UserFollowers(UserID, FollowerID) VALUES
(1, 2), (1, 3), (2, 1), (3, 4), (4, 5);

INSERT INTO UserFollowing(UserID, FollowingID) VALUES
(2, 1), (3, 1), (1, 4), (5, 2);
-- select all users
select * from Users;
-- Get all posts with usernames
select u.name,p.postDescription,p.likecount,p.commentscount
from Users u
join post p on u.ID=p.userID;
-- all comment line with commenter names
select u.name As CommentedBy,p.postDescription,c.comment
from postcomments c
join Users u on c.commentedBy=u.ID
join post p on c.postID=p.ID;
-- counting total posts by users
select u.name, count(p.ID) AS Totalposts
from users u
left join post p on u.ID=p.userID
group by u.name;
-- most liked post
select postDescription,likecount
from post
order by likecount desc
limit 1;
-- most followerd user
SELECT U.Name, COUNT(F.FollowerID) AS Followers
FROM Users U
JOIN UserFollowers F ON U.ID = F.UserID
GROUP BY U.ID
ORDER BY Followers DESC
LIMIT 1;
-- find who followed by a particular user
SELECT U1.Name AS User, U2.Name AS Following
FROM UserFollowing F
JOIN Users U1 ON F.UserID = U1.ID
JOIN Users U2 ON F.FollowingID = U2.ID
WHERE U1.Name = 'Akhila';
-- find who follows a particular user
SELECT U1.Name AS User, U2.Name AS Follower
FROM UserFollowers F
JOIN Users U1 ON F.UserID = U1.ID
JOIN Users U2 ON F.FollowerID = U2.ID
WHERE U1.Name = 'Akhila';
-- 3 users with most posts
SELECT U.Name, COUNT(P.ID) AS TotalPosts
FROM Users U
JOIN Post P ON U.ID = P.UserID
GROUP BY U.ID
ORDER BY TotalPosts DESC
LIMIT 3;





