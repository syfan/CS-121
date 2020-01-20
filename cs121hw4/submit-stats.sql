-- [Problem 1]
DROP FUNCTION IF EXISTS min_submit_interval;
-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL.
DELIMITER !
-- Given a date value, returns TRUE if it is a weekend,
-- or FALSE if it is a weekday.
CREATE FUNCTION min_submit_interval(target_id INTEGER) RETURNS INTEGER
BEGIN
    -- start with max int value for comparison
    DECLARE smallest INTEGER DEFAULT 2147483647;
    DECLARE first_val BIGINT;
    DECLARE second_val BIGINT;
    DECLARE done INTEGER DEFAULT 0;
    -- make cursor for the list of target submission dates
    DECLARE cur CURSOR FOR
        SELECT DISTINCT UNIX_TIMESTAMP(sub_date)
            FROM fileset
            WHERE sub_id = target_id ORDER BY UNIX_TIMESTAMP(sub_date);
    -- When fetch is complete, handler sets flag
    -- 02000 is MySQL error for "zero rows fetched"
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    -- 42000 is for when more than one row is fetched
    DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
        SET done = 1;
    OPEN cur;
    FETCH cur INTO first_val;
    WHILE NOT done DO
        FETCH cur INTO second_val;
        IF NOT done THEN
            IF (second_val - first_val) < smallest THEN
                SET smallest = second_val - first_val;
            END IF;
            SET first_val = second_val;
        END IF;
    END WHILE;
    CLOSE cur;
    RETURN smallest;
END !
-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 2]
DROP FUNCTION IF EXISTS max_submit_interval;
-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL.
DELIMITER !
-- Given a date value, returns TRUE if it is a weekend,
-- or FALSE if it is a weekday.
CREATE FUNCTION max_submit_interval(target_id INTEGER) RETURNS INTEGER
BEGIN
    -- start with max int value for comparison
    DECLARE largest INTEGER DEFAULT 0;
    DECLARE first_val BIGINT;
    DECLARE second_val BIGINT;
    DECLARE done INTEGER DEFAULT 0;
    -- make cursor for the list of target submission dates
    DECLARE cur CURSOR FOR
        SELECT DISTINCT UNIX_TIMESTAMP(sub_date)
            FROM fileset
            WHERE sub_id = target_id ORDER BY UNIX_TIMESTAMP(sub_date);
    -- When fetch is complete, handler sets flag
    -- 02000 is MySQL error for "zero rows fetched"
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    -- 42000 is for when more than one row is fetched
    DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
        SET done = 1;
    OPEN cur;
    FETCH cur INTO first_val;
    WHILE NOT done DO
        FETCH cur INTO second_val;
        IF NOT done THEN
            IF (second_val - first_val) > largest THEN
                SET largest = second_val - first_val;
            END IF;
            SET first_val = second_val;
        END IF;
    END WHILE;
    CLOSE cur;
    RETURN largest;
END !
-- Back to the standard SQL delimiter
DELIMITER ;

-- [Problem 3]

DROP FUNCTION IF EXISTS avg_submit_interval;
-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL.
DELIMITER !
-- Given a date value, returns TRUE if it is a weekend,
-- or FALSE if it is a weekday.
CREATE FUNCTION avg_submit_interval(target_id INTEGER) RETURNS DOUBLE
BEGIN
    -- start with max int value for comparison
    DECLARE maximum DOUBLE;
    DECLARE minimum DOUBLE;
    DECLARE num_intervals BIGINT;
    DECLARE avg_result DOUBLE;

    SELECT DISTINCT MAX(UNIX_TIMESTAMP(sub_date))
        FROM fileset
        WHERE sub_id = target_id
        INTO maximum;
    SELECT DISTINCT MIN(UNIX_TIMESTAMP(sub_date))
        FROM fileset
        WHERE sub_id = target_id
        INTO minimum;
    SELECT COUNT(*) FROM fileset
        WHERE sub_id = target_id
        INTO num_intervals;
    SET avg_result = (maximum - minimum) / (num_intervals - 1.0);
    RETURN avg_result;
END !
-- Back to the standard SQL delimiter
DELIMITER ;

-- [Problem 4]
CREATE INDEX idx_sub_date ON fileset(sub_id, sub_date);

