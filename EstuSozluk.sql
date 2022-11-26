DROP DATABASE IF EXISTS EstuSozluk;
CREATE DATABASE IF NOT EXISTS EstuSozluk;


USE EstuSozluk;


CREATE TABLE IF NOT EXISTS Permissions(
	userrole INT(1) NOT NULL PRIMARY KEY,
	rolename varchar(20) NOT NULL
);


CREATE TABLE IF NOT EXISTS Users(
	username VARCHAR(30) NOT NULL PRIMARY KEY,
	email VARCHAR(255) NOT NULL UNIQUE,
	password VARCHAR(255) NOT NULL,
	userrole INT(1) NOT NULL,

	CONSTRAINT FK_UserRole FOREIGN KEY(userrole)
	REFERENCES Permissions(userrole)
);



INSERT INTO `Permissions` (`userrole`, `rolename`) 
VALUES (0, "BannedUser");

INSERT INTO `Permissions` (`userrole`, `rolename`) 
VALUES (1, "User");

INSERT INTO `Permissions` (`userrole`, `rolename`) 
VALUES (2, "Moderator");


/*
* entryid can reach its limits quickly an alternative
* could be required.
*/
CREATE TABLE IF NOT EXISTS Entries(
	entryid INT unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
	entryuser VARCHAR(20) NOT NULL,
	titlename VARCHAR(50) NOT NULL,
	content TEXT(15000) NOT NULL,
	writedate DATETIME NOT NULL,
	editdate DATETIME NOT NULL,
	
	CONSTRAINT FK_EntryUser FOREIGN KEY (entryuser)
	REFERENCES Users(username) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS LikedEntries(
	likedentryid INT unsigned NOT NULL,
	userliked VARCHAR(20) NOT NULL,
	
	PRIMARY KEY (likedentryid, userliked),
	
	CONSTRAINT FK_LikedEntry FOREIGN KEY (likedentryid)
	REFERENCES Entries(entryid) ON DELETE CASCADE,
	
	CONSTRAINT FK_UserLiked FOREIGN KEY (userliked)
	REFERENCES Users(username) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Followships(
	follower VARCHAR(20) NOT NULL,
	followed VARCHAR(20) NOT NULL,
	PRIMARY KEY (follower, followed),
	
	CONSTRAINT FK_Follower FOREIGN KEY (follower)
	REFERENCES Users(username) ON DELETE CASCADE,
	
	CONSTRAINT FK_Followed FOREIGN KEY (followed)
	REFERENCES Users(username) ON DELETE CASCADE
);

