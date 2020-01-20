-- [Problem a]
-- The query computes the number of loans each borrower has and lists them
-- by name, # of loans, in descending order by # of loans.
SELECT customer_name, COUNT(loan_number) AS num_loans
    FROM customer NATURAL LEFT JOIN borrower
    GROUP BY customer_name ORDER BY num_loans DESC;

-- [Problem b]
-- The query finds the names of the branches that have fewer assets than their
-- total loan amounts.

SELECT branch_name FROM (
    SELECT branch_name, assets, SUM(amount) as loan_sum FROM branch
    NATURAL LEFT JOIN loan GROUP BY branch_name
    HAVING assets < loan_sum) as branches;

-- [Problem c]
SELECT branch_name, num_accounts, num_loans FROM branch
    WHERE

SELECT branch_name, (SELECT COUNT(account_number) FROM branch b WHERE
    b.branch_name = )



-- [Problem d]
