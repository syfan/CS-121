-- [Problem 1a]
SELECT DISTINCT name FROM student NATURAL JOIN takes
    WHERE course_id LIKE '%CS%';

-- [Problem 1b]
SELECT dept_name, MAX(salary) AS max_salary FROM instructor
    GROUP BY dept_name;

-- [Problem 1c]
SELECT MIN(max_salary) AS min_max FROM (SELECT dept_name, MAX(salary)
    AS max_salary FROM instructor GROUP BY dept_name) AS max_salaries;

-- [Problem 1d]
WITH RECURSIVE max_salaries AS
    (SELECT dept_name, MAX(salary) AS max_salary FROM instructor
    GROUP BY dept_name) SELECT MIN(max_salary) FROM max_salaries;

-- [Problem 2a]
INSERT INTO course VALUES ('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);

-- [Problem 2b]
INSERT INTO section (course_id, sec_id, semester, year)
    VALUES ('CS-001', '1', 'Fall', 2009);

-- [Problem 2c]
INSERT INTO takes (ID, course_id, sec_id, semester, year)
    SELECT ID, course_id, sec_id, semester, year
    FROM student, section WHERE dept_name = 'Comp. Sci.'
    AND sec_id = '1' AND course_id = 'CS-001';
-- [Problem 2d]
DELETE FROM takes WHERE ID = (SELECT ID FROM student WHERE name = 'Chavez');

-- [Problem 2e]
-- Running this without first deleting the section deletes the section
-- automatically.
DELETE FROM course WHERE course_id = 'CS-001';

-- [Problem 2f]
DELETE FROM takes WHERE course_id =
    (SELECT course_id FROM course WHERE title LIKE '%database%');


-- [Problem 3a]
SELECT DISTINCT name FROM member NATURAL JOIN book NATURAL JOIN borrowed
    WHERE publisher = 'McGraw-Hill';


-- [Problem 3b]
SELECT name FROM member NATURAL JOIN (
    SELECT memb_no FROM borrowed WHERE isbn IN (SELECT isbn
    FROM (SELECT isbn FROM book WHERE publisher = 'McGraw-Hill') AS isbns)
        GROUP BY memb_no HAVING COUNT(*) = (SELECT COUNT(*) FROM(
        SELECT isbn FROM book WHERE publisher = 'McGraw-Hill'
    ) AS isbns
    )
) as all_mcgraw_borrowers;

-- [Problem 3c]
SELECT name FROM member NATURAL JOIN borrowed NATURAL JOIN book
    GROUP BY publisher, name HAVING COUNT(isbn) > 5;


-- [Problem 3d]
SELECT AVG(books_each) FROM (SELECT COUNT(isbn) AS books_each
    FROM member NATURAL LEFT JOIN borrowed GROUP BY memb_no) as alias;


-- [Problem 3e]
WITH RECURSIVE avg_books AS
    (SELECT COUNT(isbn) AS books_each
        FROM member NATURAL LEFT JOIN borrowed GROUP BY memb_no)
        SELECT AVG(books_each) FROM avg_books;
