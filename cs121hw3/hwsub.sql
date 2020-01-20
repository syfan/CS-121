-- [Problem 1a]
SELECT SUM(perfectscore) FROM assignment;

-- [Problem 1b]
SELECT sec_name, COUNT(username) AS num_students
    FROM section NATURAL JOIN student
    GROUP BY sec_name;


-- [Problem 1c]
CREATE VIEW totalscores AS
    SELECT username, SUM(score) as score_total FROM submission
    WHERE graded = 1 GROUP BY username;

-- [Problem 1d]
CREATE VIEW passing AS
    SELECT username, score_total FROM totalscores
    WHERE score_total >= 40;

-- [Problem 1e]
CREATE VIEW failing AS
    SELECT username, score_total FROM totalscores
    WHERE score_total < 40;


-- [Problem 1f]



-- [Problem 1g]



-- [Problem 2a]
SELECT DISTINCT username FROM
    submission NATURAL JOIN assignment NATURAL JOIN fileset
    WHERE shortname = 'midterm' AND sub_date > due;


-- [Problem 2b]
SELECT EXTRACT(HOUR FROM sub_date) AS hr, COUNT(sub_id) AS num_submits
    FROM fileset GROUP BY hr;


-- [Problem 2c]
-- UNIX_TIMESTAMP converts dates to seconds. 1800 is 30 mins in secs.
SELECT COUNT(sub_id) FROM fileset NATURAL JOIN assignment
    WHERE
    UNIX_TIMESTAMP(due) - UNIX_TIMESTAMP(sub_date) < 1800
    AND shortname = 'final';

-- [Problem 3a]
ALTER TABLE student
    ADD email VARCHAR(200);

UPDATE student
    SET email = username || '@school.edu';

ALTER TABLE student
    CHANGE COLUMN email email VARCHAR(200) NOT NULL;

-- [Problem 3b]
ALTER TABLE assignment
    ADD submit_files BOOLEAN DEFAULT TRUE;

UPDATE assignment
    SET submit_files = FALSE WHERE shortname = 'dq';


-- [Problem 3c]
CREATE TABLE gradescheme (
    scheme_id INT,
    scheme_desc VARCHAR(100) NOT NULL,
    PRIMARY KEY (scheme_id)
);

INSERT INTO gradescheme (scheme_id, scheme_desc)
    VALUES (0, 'Lab assignment with min-grading.');
INSERT INTO gradescheme (scheme_id, scheme_desc)
    VALUES (1, 'Daily quiz.');
INSERT INTO gradescheme (scheme_id, scheme_desc)
    VALUES (2, 'Midterm of final exam.');

ALTER TABLE assignment
    CHANGE COLUMN gradescheme scheme_id INT NOT NULL;

ALTER TABLE assignment
    ADD FOREIGN KEY (scheme_id) REFERENCES gradescheme(scheme_id);


-- [Problem 4a]

-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL.
DELIMITER !
-- Given a date value, returns TRUE if it is a weekend,
-- or FALSE if it is a weekday.
CREATE FUNCTION is_weekend(d DATE) RETURNS BOOLEAN
BEGIN
    IF DAYNAME(d) = 'Saturday' OR DAYNAME(d) = 'Sunday'
        THEN RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END !
-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 4b]
-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL.
DELIMITER !
-- Given a date, returns the holiday, or NULL if not a
-- holiday.
CREATE FUNCTION is_holiday(d DATE) RETURNS VARCHAR(20)
BEGIN
    CASE
        WHEN EXTRACT(DAY FROM d) = 1 AND EXTRACT(MONTH FROM d) = 1
            THEN RETURN 'New Year\'s Day';
        WHEN DAYNAME(d) = 'Monday' AND EXTRACT(MONTH FROM d) = 5
            AND (EXTRACT(DAY FROM d) >= 25 AND
                EXTRACT(DAY FROM d) <= 31)
            THEN RETURN 'Memorial Day';
        WHEN EXTRACT(DAY FROM d) = 4 AND EXTRACT(MONTH FROM d) = 7
            THEN RETURN 'Independence Day';
        WHEN DAYNAME(d) = 'Monday' AND EXTRACT(MONTH FROM d) = 9
            AND (EXTRACT(DAY FROM d) >= 1 AND
                EXTRACT(DAY FROM d) <= 7)
            THEN RETURN 'Labor Day';
        WHEN DAYNAME(d) = 'Thursday' AND EXTRACT(MONTH FROM d) = 11
            AND (EXTRACT(DAY FROM d) >= 20 AND
                EXTRACT(DAY FROM d) <= 29)
            THEN RETURN 'Thanksgiving';
        ELSE RETURN NULL;
    END CASE;
END !
-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 5a]
SELECT is_holiday(sub_date) AS holiday,
    COUNT(is_holiday(sub_date)) AS subs
    FROM fileset GROUP BY is_holiday(sub_date);

-- [Problem 5b]
