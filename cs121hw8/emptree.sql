-- [Problem 1]
DROP FUNCTION IF EXISTS total_salaries_adjlist;
DELIMITER !
-- finds the total salaries of employees associated with the given emp_id
CREATE FUNCTION total_salaries_adjlist(emp_id INTEGER)
RETURNS INTEGER
BEGIN
    DECLARE tot INTEGER;
    DROP TEMPORARY TABLE IF EXISTS temp;
    -- temporary table for holding the emp_ids and salaries
    CREATE TEMPORARY TABLE temp
        (emp_id INTEGER, salary INTEGER);
    -- putting the first value, for the purpose of searching
    INSERT INTO temp
        SELECT emp_id, salary FROM employee_adjlist
        WHERE employee_adjlist.emp_id = emp_id;
    -- continue adding to the temp table until no rows are added
    WHILE ROW_COUNT() <> 0 DO
        INSERT INTO temp SELECT emp_id, salary FROM employee_adjlist
            WHERE manager_id IN (SELECT emp_id FROM temp)
            AND employee_adjlist.emp_id NOT IN (SELECT emp_id FROM temp);
    END WHILE;
    -- sum up all of the retreived salaries, then return it
    SELECT SUM(salary) INTO tot FROM temp;

    RETURN tot;
END !
DELIMITER ;

-- [Problem 2]
DROP FUNCTION IF EXISTS total_salaries_nestset;
DELIMITER !
-- finds the total salaries of employees associated with the given emp_id
CREATE FUNCTION total_salaries_nestset(emp_id INTEGER)
RETURNS INTEGER
BEGIN
    DECLARE tot INTEGER;
    DECLARE target_low INTEGER;
    DECLARE target_high INTEGER;

    DROP TEMPORARY TABLE IF EXISTS temp;
    -- temporary table for holding the emp_ids and salaries
    CREATE TEMPORARY TABLE temp
        (emp_id INTEGER, salary INTEGER);
    -- set the parameters to be used for checking
    SELECT low INTO target_low FROM employee_nestset
        WHERE employee_nestset.emp_id = emp_id;
    SELECT high INTO target_high FROM employee_nestset
        WHERE employee_nestset.emp_id = emp_id;
    -- add all rows where the highs and lows are in range
    INSERT INTO temp SELECT emp_id, salary FROM employee_nestset
        WHERE employee_nestset.low >= target_low
        AND employee_nestset.high <= target_high;
    -- sum up all of the retreived salaries, then return it
    SELECT SUM(salary) INTO tot FROM temp;

    RETURN tot;
END !
DELIMITER ;

-- [Problem 3]
-- if the emp_id not a manager_id, then the associated node must be a leaf
SELECT emp_id, name, salary FROM employee_adjlist WHERE
    emp_id NOT IN (SELECT manager_id FROM employee_adjlist
                    WHERE manager_id IS NOT NULL);

-- [Problem 4]
-- 5 appears to be the minimum difference between low and high, so the leaves
-- are the nodes where low + 5 = high
SELECT emp_id, name, salary FROM employee_nestset WHERE low + 5 = high;


-- [Problem 5]
DROP FUNCTION IF EXISTS tree_depth;
DELIMITER !
-- finds the max depth of a tree specified with an emp_id uses the adjacent list
-- representation; I found it easier to select elements for the temporary table
-- with it because it works in layers
CREATE FUNCTION tree_depth(emp_id INTEGER)
RETURNS INTEGER
BEGIN
    DECLARE greatest_depth INTEGER;
    DECLARE i INTEGER DEFAULT 2;
    DROP TEMPORARY TABLE IF EXISTS temp;
    -- temporary table for holding the emp_ids and salaries
    CREATE TEMPORARY TABLE temp
        (emp_id INTEGER, salary INTEGER, depth INTEGER);
    -- putting the first value, for the purpose of searching
    INSERT INTO temp
        VALUES (emp_id, (SELECT salary FROM employee_adjlist
        WHERE employee_adjlist.emp_id = emp_id), 1);
    -- continue adding to the temp table until no rows are added
    WHILE ROW_COUNT() <> 0 DO
        INSERT INTO temp SELECT emp_id, salary, i FROM employee_adjlist
            WHERE manager_id IN (SELECT emp_id FROM temp)
            AND employee_adjlist.emp_id NOT IN (SELECT emp_id FROM temp);
        SET i = i + 1;
    END WHILE;

    SELECT MAX(depth) INTO greatest_depth FROM temp;
    RETURN greatest_depth;
END !
DELIMITER ;


-- [Problem 6]
DROP FUNCTION IF EXISTS employee_adjlist;
DELIMITER !
-- finds the immediate children of the node associated with the given emp_id
CREATE FUNCTION employee_adjlist(emp_id INTEGER)
RETURNS INTEGER
BEGIN
    DECLARE target_low INTEGER;
    DECLARE temp_high INTEGER; 
    
    DECLARE child_counter INTEGER DEFAULT 0;
    -- used for checking if there are nodes between the target low and temp
    -- high
    DECLARE checker INTEGER DEFAULT 0;
    
    SELECT COUNT(*) INTO checker FROM employee_nestset
        WHERE high < temp_high AND low > target_low;
    -- while there are some children to count, we keep counting
    WHILE checker > 0 DO
        -- search for nodes under the temp high but above the target_low. 
        -- Find the node with a high that's closest to the temp_high and 
        -- add it to the count and move on
        SET child_counter = child_counter + 1;
        SELECT low INTO temp_high FROM employee_nestset 
            WHERE high < temp_high ORDER BY high DESC LIMIT 1;
        -- update the checker variable
        SELECT COUNT(*) INTO checker FROM employee_nestset
            WHERE high < temp_high AND low > target_low;
    END WHILE;
    RETURN child_counter;
END !
DELIMITER ;
