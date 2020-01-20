-- [Problem 1a]
DROP TABLE IF EXISTS user_info;
-- has data for users, including username, salt value, and hash for password
CREATE TABLE user_info(
    username VARCHAR(20) NOT NULL,
    salt CHAR(10) NOT NULL,
    password_hash CHAR(64) NOT NULL,

    PRIMARY KEY (username)
);


-- [Problem 1b]
DROP PROCEDURE IF EXISTS sp_add_user;
DELIMITER !
CREATE PROCEDURE sp_add_user(new_username VARCHAR(20), password VARCHAR(20))
BEGIN
    DECLARE salt_val CHAR(10) DEFAULT '';
    DECLARE salted_pw CHAR(64) DEFAULT '';
    SET salt_val = make_salt(10);
    -- concatenate the salt and password
    SET salted_pw = CONCAT(salt_val, password);
    -- generate the 256-bit hash for security
    SET salted_pw = SHA2(salted_pw, 256);
    -- now put the entry in the user_info table
    INSERT INTO user_info (username, salt, password_hash)
        VALUES (new_username, salt_val, salted_pw);
END !
DELIMITER ;

-- [Problem 1c]
DROP PROCEDURE IF EXISTS sp_change_password;
DELIMITER !
CREATE PROCEDURE sp_change_password(curr_username VARCHAR(20), password VARCHAR(20))
BEGIN
    DECLARE salt_val CHAR(10) DEFAULT '';
    DECLARE salted_pw CHAR(64) DEFAULT '';
    SET salt_val = make_salt(10);
    -- concatenate the salt and password
    SET salted_pw = CONCAT(salt_val, password);
    -- generate the 256-bit hash for security
    SET salted_pw = SHA2(salted_pw, 256);
    -- update the table entry with the correct username
    UPDATE user_info
        SET salt = salt_val,
            password_hash = salted_pw
        WHERE username = curr_username;
END !
DELIMITER ;


-- [Problem 1d]
DROP FUNCTION IF EXISTS authenticate;
DELIMITER !
CREATE FUNCTION authenticate(user_name VARCHAR(20), password VARCHAR(20))
RETURNS BOOLEAN
BEGIN
    DECLARE salt_val CHAR(10) DEFAULT '';
    DECLARE salted_pw CHAR(64) DEFAULT '';
    SET salt_val = make_salt(10);
    -- concatenate the salt and password
    SET salted_pw = CONCAT(salt_val, password);
    -- generate the 256-bit hash for security
    SET salted_pw = SHA2(salted_pw, 256);
    IF (EXISTS(SELECT * FROM user_info WHERE username = user_name)) = 0
        THEN RETURN FALSE;
    ELSEIF ((STRCMP(salted_pw, (SELECT password_hash FROM user_info WHERE username = user_name))) <> 0)
        THEN RETURN FALSE;
    ELSE RETURN TRUE;
    END IF;
END !
DELIMITER ;
