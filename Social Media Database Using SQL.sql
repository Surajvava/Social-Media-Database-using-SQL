CREATE DATABASE social_media;
USE social_media;
show tables;
CREATE TABLE users (
    user_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    bio VARCHAR(255)
    );
   
ALTER TABLE users
ADD email VARCHAR(30) NOT NULL;

INSERT INTO users(username, bio,email) VALUES 
("sam","bike","suraj124@gmail.com"),
("ram","soon to be update","raj453@gmail.com"),
("surya","IT","santh987@gmail.com"),
("naveen","king","abhi427@gmail.com"),
("nambi","living life","johna@gmail.com");

SELECT username, bio,
    CASE username 
        WHEN 'sam' THEN 'sam kumar'
        WHEN 'surya' THEN 'surya karthik'
        ELSE 'unknown'
    END AS username_range
FROM users; 

select*from users
limit 2 offset 2;

select user_id, username 
from users
where username regexp '[^0-1]';

CREATE TABLE photos (
    photo_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    post_id	INTEGER NOT NULL,
    size FLOAT CHECK (size<5)
);
 
 INSERT INTO photos (photo_id, post_id, size) VALUES
(15, 1, 1.8), 
(21, 2, 2.3),
(7, 3, 0.9);

select photo_id, post_id
from photos
order by
case
when photo_id= 21 then 3
when photo_id= 7 then 1
else 2
end;

describe photos;

Set sql_safe_updates=0;

show create table photos;
alter table photos 
modify size varchar(10);


CREATE TABLE videos (
  video_id INTEGER AUTO_INCREMENT PRIMARY KEY,
  video_url VARCHAR(255) NOT NULL UNIQUE,
  post_id INTEGER NOT NULL,
  size FLOAT CHECK (size<10)
  );

INSERT INTO videos (video_id, video_url, post_id, size) VALUES
(47, 'http://example.com/video47.mp4', 1, 5.5),
(37, 'http://example.com/video37.mp4', 2, 7.1),
(22, 'http://example.com/video22.mp4', 3, 3.2);
 
 show indexes from videos;
CREATE TABLE post (
	post_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    photo_id INTEGER,
    video_id INTEGER,
    user_id INTEGER NOT NULL,
    caption VARCHAR(200), 
    location VARCHAR(50) ,
    FOREIGN KEY(user_id) REFERENCES users(user_id),
	FOREIGN KEY(photo_id) REFERENCES photos(photo_id),
    FOREIGN KEY(video_id) REFERENCES videos(video_id)
);

INSERT INTO post (post_id, photo_id, video_id, user_id, caption, location) VALUES
(1,15,47,1,"hey","coimbatore"),
(2,21,37,2,"live a good story","chennai"),
(3,7,22,3,"The best is yet to come.","ooty");

SELECT * FROM post
WHERE location IN ('coimbatore' ,'chennai');

SELECT user_id, caption FROM post
ORDER BY caption DESC;

SELECT user_id, caption FROM post
ORDER BY caption ASC;

CREATE TABLE comments (
    comment_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    comment_text VARCHAR(255) NOT NULL,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY(post_id) REFERENCES post(post_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

INSERT INTO COMMENTS(comment_text ,post_id,user_id) VALUES
('great man',1,1),
('looking great',2,2),
('nice place keep enjoying',3,3);

select*from COMMENTS;

select comment_text
from COMMENTS
where comment_text like 'g%%';

select comment_text
from COMMENTS
where comment_text LIKE 'n%%';

select comment_text
from COMMENTS
where comment_text LIKE 'n__';

CREATE TABLE post_likes (
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(user_id),
    FOREIGN KEY(post_id) REFERENCES post(post_id),
    PRIMARY KEY(user_id, post_id)
);

INSERT INTO POST_LIKES(user_id,post_id) VALUES 
(1,1),
(2,2),
(3,3);

SELECT
COUNT(post_likes.post_id) 
FROM post_likes
GROUP BY post_likes.post_id;

SELECT users.username, users.user_id -- or post_likes.user_id
FROM users
INNER JOIN post_likes ON users.user_id = post_likes.user_id;

SELECT users.username, users.user_id -- or post_likes.user_id
FROM users
left JOIN post_likes ON users.user_id = post_likes.user_id;
SELECT users.username, users.user_id -- or post_likes.user_id
FROM users
right JOIN post_likes ON users.user_id = post_likes.user_id;

select user_id, post_id
from POST_LIKES
where post_id = (SELECT MAX(post_id) FROM POST_LIKES);

CREATE TABLE comment_likes (
    user_id INTEGER NOT NULL,
    comment_id INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(user_id),
    FOREIGN KEY(comment_id) REFERENCES comments(comment_id),
    PRIMARY KEY(user_id, comment_id)
);

INSERT INTO COMMENT_LIKES(user_id,comment_id) VALUES
(1 , 1),
(2 , 2),
(3 , 3);

select distinct count(comment_id) from COMMENT_LIKES;

select  count(comment_id) from COMMENT_LIKES;

select user_id,comment_id,
case 
when comment_id>2 then"High"
else "low"
end as comment_id_range
from COMMENT;

CREATE TABLE follows (
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    FOREIGN KEY(follower_id) REFERENCES users(user_id),
    FOREIGN KEY(followee_id) REFERENCES users(user_id),
    PRIMARY KEY(follower_id, followee_id)
);

INSERT INTO follows(follower_id, followee_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

SELECT followee_id, COUNT(follower_id)
FROM follows
GROUP BY followee_id
HAVING COUNT(follower_id) > 1;

CREATE TABLE hashtags (
  hashtag_id INTEGER AUTO_INCREMENT PRIMARY KEY,
  hashtag_name VARCHAR(255) UNIQUE
);

INSERT INTO HASHTAGS(hashtag_name) VALUES 
(' #party'),
(' #followme'),
(' #christmas');

CREATE TABLE hashtag_follow (
	user_id INTEGER NOT NULL,
    hashtag_id INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(user_id),
    FOREIGN KEY(hashtag_id) REFERENCES hashtags(hashtag_id),
    PRIMARY KEY(user_id, hashtag_id)
);

insert into hashtag_follow (user_id,hashtag_id) values
(1,1),
(2,2),
(3,3);

CREATE TABLE post_tags (
    post_id INTEGER NOT NULL,
    hashtag_id INTEGER NOT NULL,
    FOREIGN KEY(post_id) REFERENCES post(post_id),
    FOREIGN KEY(hashtag_id) REFERENCES hashtags(hashtag_id),
    PRIMARY KEY(post_id, hashtag_id)
);

INSERT INTO post_tags(post_id, hashtag_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

CREATE TABLE bookmarks (
  post_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(post_id) REFERENCES post(post_id),
  FOREIGN KEY(user_id) REFERENCES users(user_id),
  PRIMARY KEY(user_id, post_id)
);

INSERT INTO bookmarks(post_id, user_id) VALUES
(1, 1),
(2,2),
(3, 3);

show indexes from bookmarks;

CREATE TABLE login (
  login_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INTEGER NOT NULL,
  ip VARCHAR(50) NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(user_id)
);

INSERT INTO LOGIN(user_id , ip) VALUES 
(1,'186.83.147.14'),
(2,'95.43.246.66'),
(3,'105.238.37.204');

select*from LOGIN
limit 2 offset 2;
show indexes from LOGIN;
