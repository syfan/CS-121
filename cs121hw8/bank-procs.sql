-- [Problem 1]
DROP PROCEDURE IF EXISTS sp_deposit;
-- procedure for enabling deposits to accounts
DELIMITER !
CREATE PROCEDURE sp_deposit(account_number VARCHAR(15), amount NUMERIC(12,2),
                                                            OUT status INTEGER)
BEGIN
    -- does not try to do transaction unless account and amount are valid
    IF (amount < 0) THEN SET status = -1;
    ELSEIF EXISTS(SELECT * FROM account
        WHERE account.account_number = account_number) = 0
        THEN SET status = -2;
    ELSE BEGIN
        START TRANSACTION;
        UPDATE account SET balance = balance + amount
            WHERE account.account_number = account_number;
        COMMIT;
        SET status = 0;
        END;
    END IF;
END !
DELIMITER ;


-- [Problem 2]
DROP PROCEDURE IF EXISTS sp_withdraw;
-- procedure for enabling deposits to accounts
DELIMITER !
CREATE PROCEDURE sp_withdraw(account_number VARCHAR(15), amount NUMERIC(12,2),
                                                            OUT status INTEGER)
BEGIN
    -- does not try to do transaction unless account and amount are valid
    IF (amount < 0) THEN SET status = -1;
    ELSEIF EXISTS(SELECT * FROM account
        WHERE account.account_number = account_number) = 0
        THEN SET status = -2;
    ELSE BEGIN
        START TRANSACTION;
        UPDATE account SET balance = balance - amount
            WHERE account.account_number = account_number;
        IF EXISTS(SELECT * FROM account
                WHERE account.account_number = account_number
                HAVING  balance < 0) THEN BEGIN
            ROLLBACK;
            SET status = -3;
        END;
        ELSE COMMIT;
        END IF;

        SET status = 0;
        END;
    END IF;
END !
DELIMITER ;

-- [Problem 3]
DROP PROCEDURE IF EXISTS sp_transfer;
-- procedure for enabling deposits to accounts
DELIMITER !
CREATE PROCEDURE sp_transfer(account_1_number VARCHAR(15), amount NUMERIC(12,2),
                            account_2_number VARCHAR(15), OUT status INTEGER)
BEGIN
    -- does not try to do transaction unless account and amount are valid
    IF (amount < 0) THEN SET status = -1;
    ELSEIF EXISTS(SELECT * FROM account
        WHERE account.account_number = account_number) = 0
        THEN SET status = -2;
    ELSE BEGIN
        START TRANSACTION;
        CALL sp_withdraw(account_1_number, amount, status);
        CALL sp_deposit(account_2_number, amount, status);
        IF EXISTS(SELECT * FROM account
                WHERE account.account_number = account_1_number
                HAVING  balance < 0) OR
                EXISTS(SELECT * FROM account
                    WHERE account.account_number = account_2_number
                    HAVING  balance < 0)THEN BEGIN
            ROLLBACK;
            SET status = -3;
        END;
        ELSE COMMIT;
        END IF;

        SET status = 0;
        END;
    END IF;
END !
DELIMITER ;
