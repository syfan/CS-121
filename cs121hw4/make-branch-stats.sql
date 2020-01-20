-- [Problem 1]
CREATE INDEX idx_account ON account(branch_name, balance);

-- [Problem 2]
DROP TABLE IF EXISTS mv_branch_account_stats;
CREATE TABLE mv_branch_account_stats (
    branch_name	    VARCHAR(15)	NOT NULL,
    num_accounts    INTEGER NOT NULL,
    total_deposits  NUMERIC(12, 2) NOT NULL,
    avg_balance     DOUBLE NOT NULL,
    min_balance     NUMERIC(12,2) NOT NULL,
    max_balance     NUMERIC(12,2) NOT NULL,
    PRIMARY KEY (branch_name)
);


-- [Problem 3]
INSERT INTO mv_branch_account_stats
    SELECT branch_name,
    COUNT(*) AS num_accounts,
    SUM(balance) AS total_deposits,
    AVG(balance) AS avg_balance,
    MIN(balance) AS min_balance,
    MAX(balance) AS max_balance
    FROM account GROUP BY branch_name;


-- [Problem 4]
DROP VIEW IF EXISTS branch_account_stats;
CREATE VIEW branch_account_stats AS
    SELECT * FROM mv_branch_account_stats
    WITH CHECK OPTION;


-- [Problem 5]
-- Note that this occurs before we switch the delimiter.
DROP TRIGGER IF EXISTS trg_insert;
DELIMITER !

CREATE TRIGGER trg_insert AFTER INSERT ON account
FOR EACH ROW
BEGIN
    -- Want to insert the row if the branch name doesn't already exist
    -- Update otherwise
    INSERT INTO mv_branch_account_stats
    VALUES
    (NEW.branch_name, 1, NEW.balance,
    NEW.balance, NEW.balance, NEW.balance)
        ON DUPLICATE KEY UPDATE
        num_accounts = num_accounts + 1,
        total_deposits = total_deposits + NEW.balance,
        avg_balance = total_deposits / num_accounts,
        min_balance = LEAST(min_balance, NEW.balance),
        max_balance = GREATEST(max_balance, NEW.balance);
END; !
DELIMITER ;


-- [Problem 6]
-- Note that this occurs before we switch the delimiter.
DROP TRIGGER IF EXISTS trg_delete;
DELIMITER !
CREATE TRIGGER trg_delete AFTER DELETE ON account
FOR EACH ROW
BEGIN
    -- keep track of number of entries, current min, abd current max
    DECLARE nums INTEGER;
    DECLARE curr_min NUMERIC(12,2);
    DECLARE curr_max NUMERIC(12,2);
    SELECT num_accounts
        INTO nums
        FROM mv_branch_account_stats
        WHERE branch_name = OLD.branch_name;
    -- obtain value for min
    SELECT MIN(balance)
        INTO curr_min
        FROM account
        WHERE branch_name = OLD.branch_name;
    -- obtain value for max
    SELECT MAX(balance)
        INTO curr_max
        FROM account
        WHERE branch_name = OLD.branch_name;

    -- if it's the last element of the branch, delete the entry
    IF nums = 1 THEN
        DELETE FROM mv_branch_account_stats
        WHERE branch_name = OLD.branch_name;
    ELSE
        -- otherwise update
        UPDATE mv_branch_account_stats
            SET
            num_accounts = num_accounts - 1,
            total_deposits = total_deposits - OLD.balance,
            avg_balance = total_deposits / num_accounts,
            min_balance = curr_min,
            max_balance = curr_max
            WHERE branch_name = OLD.branch_name;
    END IF;
END; !
DELIMITER ;

-- [Problem 7]
DROP TRIGGER IF EXISTS trg_update;
DELIMITER !
CREATE TRIGGER trg_update AFTER UPDATE ON account
FOR EACH ROW
BEGIN
    DECLARE nums INTEGER;
    DECLARE curr_min NUMERIC(12,2);
    DECLARE curr_max NUMERIC(12,2);
    SELECT num_accounts
        INTO nums
        FROM mv_branch_account_stats
        WHERE branch_name = OLD.branch_name;

    SELECT MIN(balance)
        INTO curr_min
        FROM account
        WHERE branch_name = OLD.branch_name;

    SELECT MAX(balance)
        INTO curr_max
        FROM account
        WHERE branch_name = OLD.branch_name;


    IF nums = 1 THEN
        DELETE FROM mv_branch_account_stats
        WHERE branch_name = OLD.branch_name;
    ELSE
        UPDATE mv_branch_account_stats
            SET
            num_accounts = num_accounts - 1,
            total_deposits = total_deposits - OLD.balance,
            avg_balance = total_deposits / num_accounts,
            min_balance = curr_min,
            max_balance = curr_max
            WHERE branch_name = OLD.branch_name;
    END IF;

    INSERT INTO mv_branch_account_stats (branch_name, num_accounts,
    total_deposits, avg_balance, min_balance, max_balance)
    VALUES
    (NEW.branch_name, 1, NEW.balance,
    NEW.balance, NEW.balance, NEW.balance)
        ON DUPLICATE KEY UPDATE
        num_accounts = num_accounts + 1,
        total_deposits = total_deposits + NEW.balance,
        avg_balance = total_deposits / num_accounts,
        min_balance = LEAST(min_balance, NEW.balance),
        max_balance = GREATEST(max_balance, NEW.balance);
END; !
DELIMITER ;
