DROP DATABASE IF EXISTS EstuSozluk;
CREATE DATABASE IF NOT EXISTS EstuSozluk;

USE EstuSozluk;

CREATE TABLE IF NOT EXISTS Permissions(
	userroleid INT(1) unsigned NOT NULL PRIMARY KEY,
	rolename varchar(20) NOT NULL,
	canpost boolean NOT NULL, /* Users and moderators can post. */
	candelete boolean NOT NULL, /* Moderators can delete other's posts. */
	canban boolean NOT NULL /* Moderators can ban other people. */
);

CREATE TABLE IF NOT EXISTS Users(
	userid INT unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(30) NOT NULL UNIQUE,
	email VARCHAR(120) NOT NULL UNIQUE,
	password VARCHAR(255) NOT NULL,
	userroleid INT(1) unsigned NOT NULL,
	
	CONSTRAINT FK_UserRole FOREIGN KEY (userroleid)
	REFERENCES Permissions(userroleid)
);

INSERT INTO `Permissions` (`userroleid`, `rolename`, `canpost`, `candelete`, `canban`) 
VALUES (0, "BannedUser" , FALSE, FALSE, FALSE);

INSERT INTO `Permissions` (`userroleid`, `rolename`, `canpost`, `candelete`, `canban`) 
VALUES (1, "User" , TRUE, FALSE, FALSE);

INSERT INTO `Permissions` (`userroleid`, `rolename`, `canpost`, `candelete`, `canban`) 
VALUES (2, "Moderator", TRUE, FALSE, FALSE);


/*
* entryid can reach its limits quickly an alternative
* could be required.
*/
CREATE TABLE IF NOT EXISTS Entries(
	entryid INT unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
	userid int unsigned NOT NULL,
	titlename VARCHAR(50) NOT NULL,
	content TEXT(15000) NOT NULL,
	writedate DATETIME NOT NULL,
	editdate DATETIME NOT NULL,
	
	CONSTRAINT FK_EntryUser FOREIGN KEY (userid)
	REFERENCES Users(userid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS LikedEntries(
	likedentryid INT unsigned NOT NULL,
	userid int unsigned NOT NULL,
	
	PRIMARY KEY (likedentryid, userid),
	
	CONSTRAINT FK_LikedEntry FOREIGN KEY (likedentryid)
	REFERENCES Entries(entryid) ON DELETE CASCADE,
	
	CONSTRAINT FK_UserLiked FOREIGN KEY (userid)
	REFERENCES Users(userid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DislikedEntries(
	dislikedentryid INT unsigned NOT NULL,
	userid int unsigned NOT NULL,
	
	PRIMARY KEY (dislikedentryid, userid),
	
	CONSTRAINT FK_DislikedEntry FOREIGN KEY (dislikedentryid)
	REFERENCES Entries(entryid) ON DELETE CASCADE,
	
	CONSTRAINT FK_UserDisliked FOREIGN KEY (userid)
	REFERENCES Users(userid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Followships(
	follower int unsigned NOT NULL,
	followed int unsigned NOT NULL,
	PRIMARY KEY (follower, followed),
	
	CONSTRAINT FK_Follower FOREIGN KEY (follower)
	REFERENCES Users(userid) ON DELETE CASCADE,
	
	CONSTRAINT FK_Followed FOREIGN KEY (followed)
	REFERENCES Users(userid) ON DELETE CASCADE
);
