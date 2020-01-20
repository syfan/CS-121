-- [Problem 1a]
SELECT DISTINCT loan_number, amount FROM borrower NATURAL JOIN loan
    WHERE amount > 1000 AND amount < 2000;


-- [Problem 1b]
SELECT DISTINCT loan_number, amount FROM borrower NATURAL JOIN loan
    ORDER BY loan_number ASC;


-- [Problem 1c]
SELECT branch_city FROM branch NATURAL JOIN account
    WHERE account_number = 'A-446';


-- [Problem 1d]
SELECT customer_name, account_number, branch_name, balance
    FROM customer NATURAL JOIN account NATURAL JOIN branch
    WHERE customer_name LIKE 'J%' ORDER BY customer_name ASC;


-- [Problem 1e]

SELECT customer_name FROM customer NATURAL JOIN depositor GROUP BY
    customer_name HAVING COUNT(account_number) >= 6;

-- [Problem 2a]
CREATE VIEW pownal_customers AS
    SELECT account_number, customer_name
    FROM account NATURAL JOIN depositor
    WHERE branch_name = 'Pownal';


-- [Problem 2b]

CREATE VIEW onlyacct_customers AS
    SELECT customer_name, customer_street, customer_city
    FROM customer NATURAL JOIN borrower NATURAL JOIN depositor
    WHERE loan_number IS NULL;


-- [Problem 2c]
CREATE VIEW branch_deposits AS
    SELECT branch_name,
    IFNULL(SUM(balance), 0) as tot_bal,
    IFNULL(SUM(balance), 0) / COUNT(account_number) AS avg_bal
    FROM branch NATURAL JOIN account GROUP BY branch_name;

-- [Problem 3a]
SELECT DISTINCT customer_city FROM branch RIGHT JOIN customer
    ON branch.branch_city = customer.customer_city WHERE branch_city IS NULL
    ORDER BY customer_city ASC;


-- [Problem 3b]
SELECT DISTINCT customer_name
    FROM borrower NATURAL JOIN customer NATURAL JOIN depositor
    WHERE depositor.account_number IS NULL AND borrower.loan_number;


-- [Problem 3c]
UPDATE account
    SET balance = balance + 50 WHERE branch_name IN (
    SELECT branch_name FROM branch WHERE branch_city = 'Horseneck'
);


-- [Problem 3d]
UPDATE account, branch
    SET balance = balance + 50 WHERE branch.branch_city = 'Horseneck'
    AND account.branch_name = branch.branch_name;



-- [Problem 3e]
SELECT * FROM (SELECT DISTINCT MAX(balance) AS max_bal FROM account
    GROUP BY branch_name) AS alias INNER JOIN account
    ON alias.max_bal = balance;


-- [Problem 3f]
SELECT * FROM account WHERE (branch_name, balance)
    IN (SELECT branch_name, MAX(balance) FROM account
    GROUP BY branch_name);


-- [Problem 4]
SELECT branch1.branch_name, branch1.assets, COUNT(branch2. branch) + 1
    AS ranking FROM branch branch1 LEFT JOIN branch branch2
    ON branch1.assets < branch2.assets
    GROUP BY branch1.branch_name, branch1.assets
    ORDER BY ranking, branch1.branch_name;
