-- KEYS
PRIMARY KEY: 
1. The attribute being set as PRIMARY KEY can represent each row of data uniquely, like student_id, email, ...
2. Sometimes you have to set several attributes as an PTIMARY KEY to represent that row of data specifically.
3. CANNOT BE NULL

FOREIGN KEY:
1. The attribute that match PRIMARY KEY of "another data table" or "itself".
2. "Only" PRIMARY KEY, not others.

UNIQUE KEY:
1. Similar to PRIMARY KEY but can accept NULL
2. If the variable you are going to refer is not a PK, you must set is as an UNIQUE KEY!!!!!!!!

-- DATA TYPE
1. INTEGER -- integer
2. DECIMAL(total digits, decimal digits)
3. CHAR(total chars in it) -- string
4. VARCHAR(the max chars in it) -- CHAR stores a fixed string length as designated, whereas VARCHAR stores variable string length 
5. BLOB -- (Binary Large Object) -- for images, videos, files, ...
6. DATE -- 'YYYY-MM-DD'
7. TIMESTAMP -- 'YYYY-MM-DD HH:MM:SS'

----------------------------------------
----------------------------------------
-- ON DELETE 
ON DELETE CASCADE: if deleting a row from the users table, then the associated row from the user meta table will be removed too
ON DELETE RESTRICT: allows you to delete data referred to by a foreign key only if no other data relies on it
ON DELETE SET NULL: the data as FOREIGN KEY will be set as NULL after deletion of its referred data

----------------------------------------
----------------------------------------
-- DROP IF EXISTS BEFORE CREATING TO MAKE SURE ALL THE SETTINGS ARE CORRECT
DROP PROCEDURE / TABLE / VIEW IF EXISTS insert_enrollment;

-- CREATE DATABASE
CREATE DATABASE sql_tutorial; -- remember semicolon ";"
SHOW DATABASES;
DROP DATABASE sql_tutorial;

-- CREATE TABLE
CREATE TABLE student(
	student_id INTEGER PRIMARY KEY,
    student_name VARCHAR(20),
    student_major VARCHAR(20) -- don't need a comma in the last one
);
DESCRIBE student;
DROP TABLE student;

-- ADD OR DELETE ATTRIBUTES
ALTER TABLE student ADD gpa DECIMAL(3, 2); -- add a new attributes to the existing table
ALTER TABLE student DROP COLUMN gpa; -- delete the existing attributes of the table

-- SAVE DATA
INSERT INTO student VALUES(1, 'Yvonne', 'history'); -- save the values into the table
SELECT * FROM student; -- search all the data in the table where * represents "all"

----------------------------------------
----------------------------------------
-- CONSTRAINT
CREATE TABLE student_constraint(
	student_id INTEGER AUTO_INCREMENT,
    student_name VARCHAR(20) NOT NULL, 
    student_major VARCHAR(20) UNIQUE,
    student_age INTEGER DEFAULT 20,
    PRIMARY KEY(student_id) -- can also designate primary key through this way
    -- AUTO_INCREMENT: automatically assign the index to a key so that you don't have to key in by yourself; it must be a key
    -- NOT NULL: can't be null 
    -- UNIQUE: unique value for each row of data
    -- DEFAULT: set a default value
);
DESCRIBE student_constraint;

INSERT INTO student_constraint (`student_name`, `student_age`, `student_major`) VALUES('Yvonne', 22, 'math'); 
-- with AUTO_INCREMENT, you don't have to key in the index(student_id) by yourself
-- don't have to follow the order of attribut you've set up if writting in this way 
-- must write in this form if applying AUTO_INCREMENT, with names of attributes in front of VALUES 
INSERT INTO student_constraint (`student_name`, `student_age`, `student_major`) VALUES('JEAN', 23, 'history');

SELECT * FROM student_constraint;
DROP TABLE student_constraint;

----------------------------------------
----------------------------------------
-- REVISE OR DELETE DATA
SET SQL_SAFE_UPDATES = 0; -- just turn off the some default settings of SQL so that we can do our practice

CREATE TABLE student_revise(
	`id` INTEGER AUTO_INCREMENT,
    `name` VARCHAR(20),
    `major` VARCHAR(20),
    `score` INTEGER,
    PRIMARY KEY(`id`) -- what set to be AUTO_INCREMENT must be defined as a key
);

DROP TABLE student_revise;

-- INSERT INTO student_revise VALUES('Jean', 'biology', 90); this from won't work for AUTO_INCREMENT
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Yvonne', 'math', 80);
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Jean', 'biology', 90); 
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Tony', 'math', 100);
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Eric', 'chemistry', 75);
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Emma', 'biology', 50);

SELECT * FROM student_revise;

-- UPDATE
UPDATE student_revise SET major = 'math science' WHERE major = 'math'; -- revise the content for one attributes
UPDATE student_revise SET major = 'biochemistry' WHERE major = 'biology' OR major = 'chemistry'; -- combine and revise content for one attributes
UPDATE student_revise SET `name` = 'Victor', major = 'language' WHERE `id` = 5; -- revise multuple attributes
UPDATE student_revise SET `score` = 85; -- if not designating, it will revise the whole column

-- DELETE
DELETE FROM student_revise WHERE `id` = 1;
DELETE FROM student_revise WHERE `name` = 'Eric' OR `major` = 'math science'; -- union
DELETE FROM student_revise WHERE `name` = 'ERIC' AND `major` = 'math science'; -- intersection
DELETE FROM student_revise WHERE score < 90; -- can use <>, >=, <=, ...
DELETE FROM student_revise; -- delete all the data in the table yet with the attributes remained
DROP TABLE student_revise; -- delete the whole table, including attributes

----------------------------------------
----------------------------------------
-- SELECT
SELECT `name` FROM student_revise; -- select a specific attribute
SELECT `major`, `id` FROM student_revise; -- select multiple attributes
SELECT * FROM student_revise ORDER BY id; -- ascending
SELECT * FROM student_revise ORDER BY `id` DESC, score; -- descending, select data ordered by multiple attributes
SELECT * FROM student_revise LIMIT 3; -- reture only limited rows of data
SELECT * FROM student_revise ORDER BY score LIMIT 3; -- reture data in full attributes with the three lowest scores
SELECT * FROM student_revise WHERE major = 'math'; -- select data under a specific attribute requirement
SELECT * FROM student_revise WHERE major IN('math', 'biology'); -- select if meet just one of them 

----------------------------------------
----------------------------------------
-- EXERCISE TO CREATE COMPANY DATABASE
CREATE TABLE employee(
	`emp_id` INTEGER,
    `name` VARCHAR(20),
    `birth_date` DATE,
    `sex` VARCHAR(1),
    `salary` INTEGER,
    `branch_id` INTEGER,
    `sup_id` INTEGER,
    PRIMARY KEY(emp_id)
);

CREATE TABLE branch(
	branch_id INTEGER,
    branch_name VARCHAR(20),
    manager_id INTEGER, 
    PRIMARY KEY(branch_id), 
    FOREIGN KEY(manager_id) REFERENCES employee(emp_id) ON DELETE SET NULL
    -- FOREIGN KEY(say, manager_id) should be set to match PRIMARY KEY(say, emp_id) of another table(say, employee)
);

-- you can add some FOREIGN KEY after creating a table 
ALTER TABLE employee ADD FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL;
ALTER TABLE employee ADD FOREIGN KEY(sup_id) REFERENCES employee(emp_id) ON DELETE SET NULL; -- can refer the table itself; just remind that the key referred must be a primary key

CREATE TABLE `client`(
	client_id INTEGER PRIMARY KEY,
    client_name VARCHAR(20), 
    phone VARCHAR(20)
);

-- or simply write add them when creating table
CREATE TABLE works_with(
	emp_id INT,
    client_id INT,
    total_sales INT,
    
    -- Instuctor use the following syntax:
    CONSTRAINT PK_works_with PRIMARY KEY(emp_id, client_id),
    CONSTRAINT FK_works_with FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    CONSTRAINT FK_work_with FOREIGN KEY(client_id) REFERENCES `client`(client_id) ON DELETE CASCADE
    
    -- PRIMARY KEY(emp_id, client_id),
    -- FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    -- FOREIGN KEY (client_id) REFERENCES `client`(client_id) ON DELETE CASCADE
);

----------------------------------------
----------------------------------------
-- IMPORT DATA
LOAD DATA INFILE 'path, where \ should be /' 
INTO TABLE `table_name` 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- since the first row is title of the column

----------------------------------------
----------------------------------------
-- WHERE CLAUSE
-- suppose we're going to add a new column in the table representing discount of 10% off and also select other columns to export as an excle file
SELECT column_1, column_2, ROUND(column_3*0.9, 2) AS coulumn_3_modified, column_3
FROM `table_name` WHERE "you could set your condition";

-- LIKE OPERATOR
-- suppose we're going to select rows whose element in its column `column_name` starts with 'BIKE...'
SELECT * FROM `table_name` WHERE `column_name` LIKE 'Bike%';

-- DATE 
-- suppose we're going to select rows based on the date
SELECT * FROM `table_name` WHERE `column_in_date` BETWEEN '2016-01-01' AND '2017-12-31';

-- we can convert the date into year using YEAR()
SELECT FacFirstName, FacLastName, FacCity, FacSalary, 
	1.1 * FacSalary AS NewSalary
FROM Faculty
WHERE YEAR(FacHireDate) > 2018; 

-- TEST NULL
-- suppose we're going to select rows where some attributes of them are required to be NULL
SELECT * FROM `table_name` WHERE `column_name` IS NULL;

-- suppose we have a complex requirement
SELECT * FROM `table_name` WHERE (`column_name_1` = 'name_a' AND `column_name_2` = 'name_b') OR (`column_name_3` = 'name_c' AND `column_name_4` <> 'name_d');
-- note that "<>" represents "not equal to"

----------------------------------------
----------------------------------------
-- JOIN OPERATION
-- note that the INNER JOIN keyword selects records that have matching values in both tables
-- join in WHERE clause
SELECT * FROM `table_name_1`, `table_name_2`
	WHERE `table_name_1`.`column_name_1` = `table_name_2`.`column_name_2`
    AND other conditions...;
    
-- join in FROM clause (more common)
SELECT * FROM `table_name_1` INNER JOIN `table_name_2`
	ON `table_name_1`.`column_name_1` = `table_name_2`.`column_name_2`
    WHERE other conditions...;

-- JOIN USING() is useful when both tables share a column of the exact same name on which they join
-- JOIN ON is the more general of the two. One can join tables ON a column, a set of columns and even a condition
-- if some tables share exactly the same names, then we can first join them into a big table, 
-- and then INNER JOIN that on another table which doesn't have exactly the same column names yet still having the information we want

----------------------------------------
----------------------------------------
-- ORDER BY CLAUSE
SELECT * FROM `table_name` WHERE conditions...
	ORDER BY `Age(just an example)`; -- will be sorted in ascending order (default)

-- sorted by `Age` first, and then `Salary`
SELECT * FROM `table_name` WHERE conditions...
	ORDER BY `Age`, `Salary` DESC; -- need to add an command of descending order

-- use DISTINC keyword to remove duplicates in a column
SELECT DISTINCT `column_name` FROM `table_name`;

-- when sorting based on numbers of sth
ORDER BY apg.country, ap.name, COUNT(*) DESC 

-- select the sum of total
SELECT OT.OrdNo, C.CustFirstName, C.CustLastName, (P.ProdPrice*OL.Qty) AS LineItemTotal
FROM Product P 
	INNER JOIN OrderLine OL ON P.ProdNo = OL.ProdNo
	INNER JOIN OrderTbl OT ON OL.OrdNo = OT.OrdNo
    INNER JOIN Customer C ON OT. CustNo = C.CustNo
WHERE DATE_FORMAT(OT.OrdDate, '%Y-%m-%d') = '2030-01-23'
ORDER BY LineItemTotal DESC; -- can write the new column name


-- TIME FORMATS
%Y-%m-%d     %H:%i:%s.%f

-- OTHERS TO NOTE
-- EXCEPT: need to use NOT IN (SELECT...)
SELECT E.first_name, E.last_name, E.birth_date, E.hire_date FROM employees E
-- WHERE (SELECT emp_no FROM dept_manager) NOT IN E.emp_no AND
WHERE E.emp_no NOT IN (SELECT emp_no FROM dept_manager) AND -- col1 NOT IN col2: must be the same column names
	YEAR(DATE_FORMAT(E.birth_date, '%Y-%m-%d')) = '1963' AND 
	(DATE_FORMAT(E.hire_date, '%Y-%m-%d') BETWEEN '1992-02-03' AND '1992-02-07') AND 
	E.first_name <> '%Oscar%' AND 
	E.last_name <> '%Oscar%'
ORDER BY E.first_name;

-- DATE_FORMAT(): need to use this func. first then select whether you want YEAR or MONTH or DAY or...
SELECT E.emp_no, E.first_name, E.last_name, E.birth_date, E.hire_date, T.title
FROM employees E
	INNER JOIN titles T ON E.emp_no = T.emp_no
	INNER JOIN dept_emp DE ON DE.emp_no = E.emp_no
    INNER JOIN salaries S ON S.emp_no = E.emp_no
WHERE YEAR(DATE_FORMAT(E.birth_date, '%Y-%m-%d')) = '1965' AND 
	YEAR(DATE_FORMAT(E.hire_date, '%Y-%m-%d')) = '1985' AND
	(MONTH(DATE_FORMAT(E.hire_date, '%Y-%m-%d')) = '6' OR
    MONTH(DATE_FORMAT(E.hire_date, '%Y-%m-%d')) = '7' OR
    MONTH(DATE_FORMAT(E.hire_date, '%Y-%m-%d')) = '8') AND
	YEAR(DATE_FORMAT(S.to_date, '%Y-%m-%d')) > '2023' AND 
	YEAR(DATE_FORMAT(T.to_date, '%Y-%m-%d')) > '2023' AND 
	YEAR(DATE_FORMAT(DE.to_date, '%Y-%m-%d')) > '2023'
ORDER BY E.last_name;

----------------------------------------
----------------------------------------
-- INNER QUERY
-- Type I: will not reference the table from outer query
SELECT E.emp_no, E.first_name, E.last_name, E.birth_date, E.hire_date, T.title
FROM employees E
	INNER JOIN titles T ON E.emp_no = T.emp_no
	INNER JOIN dept_emp DE ON DE.emp_no = E.emp_no
WHERE YEAR(DATE_FORMAT(E.birth_date, '%Y-%m-%d')) = '1965' AND 
	(SELECT salary FROM salaries S WHERE S.State = 'MN');

-- another inner query sample
-- list customer info for customers age 30 and over and order for 5 or more quantities of hockey gear products
-- will not print the table in inner queries at the end
SELECT DISTINCT FirstName, LastName, City, Age
FROM Customer INNER JOIN Orders ON Customer.CustomerID = Orders.CustomerID
WHERE Age >= 30
	AND Orders.OrderID IN
		(SELECT OrderID FROM OrderDetail
			WHERE Quantity >= 5 AND OrderDetail.ProductID IN
				(SELECT ProductID FROM Product
					WHERE ProdGroup = 'Hockey Gear'));

-- Type II: will reference the table from outer query
SELECT EmployeeID, FirstName, LastName
FROM Employee_Temp
WHERE NOT EXISTS
	(SELECT * FROM Custommer C
		WHERE C.CustomerID = Employee_Temp.EmployeeID);

----------------------------------------
----------------------------------------
-- IN 
SELECT F1.FacFirstName, F1.FacLastName
FROM Faculty F1 
WHERE F1.FacNo IN 
  (SELECT O2.FacNo FROM Offering O2 -- col1 IN col2: must be the same column names
	WHERE O2.CourseNo Like 'FIN%')
ORDER BY F1.FacLastName;

-- NOT IN
SELECT E.first_name, E.last_name, E.birth_date, E.hire_date
FROM employees E
WHERE E.emp_no NOT IN 
	(SELECT emp_no FROM dept_manager);-- col1 NOT IN col2: must be the same column names

-- GROUP BY
-- when encountering 'Find...by...', it means GROUP BY...
SELECT Gender, ROUND(AVG(Age), 1) AS AvgAge
FROM Customer
Group BY Gender;

-- HVING
-- can only be used after GROUP BY
SELECT ProdGroup, ROUND(AVG(RetailPrice), 2) AS AVGPrice
FROM Product
WHERE ProdType = 'Iventory Item'
GROUP BY ProdGroup
HAVING AvgPrice > 100;

-- COUNT(*)
-- summarize number of selected items based on the GROUP BY query
SELECT Type, COUNT(*) AS NumCustomers
FROM Customer
GROUP BY Type;
-- summarize number of customers by type(retail vs. wholesale)

-- COUNT(c)
-- counts all the non-null rows in column c
SELECT ProdType, COUNT(ProdGroup) AS NumProducts
FROM Product
GROUP BY ProdType;

-- REALLY IMPORTANT!!!!!!!!!!
-- use COUNT(*) carefully when not counting row numbers!!!!!!!!!!!!!!
SUM(OL.Qty) AS total_qty_ordered: can get the real quantity
COUNT(*) total_qty_ordered: can only count the 'row number' rather than real quantity

----------------------------------------
----------------------------------------
-- note the date
WHERE DATE_FORMAT(T.from_date, '%Y-%m-%d') <= '2000-01-01'
	AND DATE_FORMAT(T.to_date, '%Y-%m-%d') >= '2000-01-01'

----------------------------------------
----------------------------------------
-- VIEWS

-- Single-table view
-- Multiple-table view
-- Grouping view

----------------------------------------
----------------------------------------
-- DISTINGUISH THESE 
WHERE col1 NOT IN (SELECT...): Type I subquery
WHERE NOT EXISTS (SELECT * ...): Type II subquery

----------------------------------------
----------------------------------------
-- REGULAR EXPRESSION
SELECT * FROM Course WHERE CourseNo REGEXP '^IS'; -- use REGEXP operator

----------------------------------------
----------------------------------------
-- COMMON TABLE EXPRESSION
-- the same writing method as in subquery but more clear since can be listed before main query

-- example: the way we select from CTE is the same from Type I and II query
WITH Course_Enroll AS (
  SELECT C.CrsDesc, COUNT(*) AS CrsEnroll
  FROM Course C 
	INNER JOIN Offering O ON C.CourseNo = O.CourseNo
	INNER JOIN Enrollment E ON O.OfferNo = E.OfferNo
  GROUP BY C.CrsDesc
) 
SELECT * FROM Course_Enroll CE 
  WHERE CE.CrsEnroll >= 0.9 * 
	(SELECT MAX(CE2.CrsEnroll) -- if WHERE clause indicates a specific column, then SELECT can only performed on that column 
		FROM Course_Enroll CE2) 
			AND CE.CrsEnroll != -- if WHERE clause indicates a specific column, then SELECT can only performed on that column 
				(SELECT MAX(CE2.CrsEnroll) FROM Course_Enroll CE2);

-- another example: the way we select from CTE is the same from Type I and II query, also when select from another CTE
WITH Faculty_Load AS (
  SELECT F.FacNo, F.FacFirstName, F.FacLastName, 
    F.FacDept, C.CourseNo, C.CrsUnits * COUNT(*) AS Facload
  FROM Faculty F
	INNER JOIN Offering O ON F.FacNo = O.FacNo
    INNER JOIN Enrollment E ON E.OfferNo = O.OfferNo
	INNER JOIN Course C ON C.CourseNo = O.CourseNo
  GROUP BY F.FacNo, C.CourseNo
),
Dept_Load AS(  
  SELECT FL.FacDept, COUNT(DISTINCT FL.FacNo) AS NumFac, SUM(FL.Facload) AS TotDeotLoad
  FROM Faculty_Load FL
  GROUP BY FL.FacDept)
SELECT FL.FacNo, FL.FacFirstName, FL.FacLastName, FL.FacDept, SUM(FL.Facload) AS TotFacLoad
FROM Faculty_Load FL
WHERE FL.CourseNo LIKE 'IS%'
GROUP BY FL.FacNo 
HAVING TotFacLoad > (
  SELECT TotDeotLoad / NumFac FROM Dept_Load
  WHERE FacDept = 'FIN')
ORDER BY TotFacLoad DESC;
