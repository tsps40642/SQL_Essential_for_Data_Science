
-- ** BASIC SQL 

-- ====================================================================================================================
-- ====================================================================================================================
-- KEYS
PRIMARY KEY: 
1. The attribute being set as PRIMARY KEY can represent each row of data UNIQUELY, like id  
2. Sometimes you have to set several attributes as an PTIMARY KEY to represent that row of data specifically  
3. CANNOT BE NULL

FOREIGN KEY:
1. The attribute that match PRIMARY KEY of "another data table" or "itself".
2. "Only" PRIMARY KEY, not others.

UNIQUE KEY: 
1. Similar to PRIMARY KEY but can accept NULL
2. If the variable you are going to refer is not a PK, you must set is as an UNIQUE KEY 

-- ====================================================================================================================
-- ====================================================================================================================
-- DATA TYPE
1. INTEGER 
2. DECIMAL(total digits, decimal digits)
3. CHAR(total chars in it) -- string with fixed length 
4. VARCHAR(the max chars in it) -- string with variable length 
5. BLOB -- Binary Large Object, for images, videos, files, ...
6. DATE -- 'YYYY-MM-DD' 
7. TIMESTAMP -- 'YYYY-MM-DD HH:MM:SS'

-- ====================================================================================================================
-- ====================================================================================================================
-- ON DELETE 
ON DELETE CASCADE: if deleting a row from the users table, then the associated row from the user meta table will be removed too
ON DELETE RESTRICT: allows you to delete data referred to by a foreign key only if no other data relies on it
ON DELETE SET NULL: the data as foreign key will be set as NULL after deletion of its referred data 

-- will be used when setting foreign key 
FOREIGN KEY(manager_id) REFERENCES employee(emp_id) ON DELETE SET NULL 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- CREATE DATABASE
CREATE DATABASE table_name; -- remember semicolon ";"
SHOW DATABASES;
DROP DATABASE database_name;

-- CREATE TABLE
CREATE TABLE student(
	student_id INTEGER PRIMARY KEY,
    student_name VARCHAR(20),
    student_major VARCHAR(20) 
);

-- SHOW THE STRUCTURE OF THE TABLE 
DESCRIBE student; 

-- DROP THE TABLE 
DROP TABLE student;

-- ADD OR DELETE ATTRIBUTES 
ALTER TABLE student ADD gpa DECIMAL(3, 2); -- add a new attributes (column) to the existing table
ALTER TABLE student DROP COLUMN gpa; -- delete the existing attributes (column) of the table

-- SAVE DATA
INSERT INTO student VALUES(1, 'Yvonne', 'history'); -- save the values into the table
SELECT * FROM student; -- search all the data in the table where * represents "all"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- EXAMPLE: CREATE A TABLE AND INSERT VALUES 
CREATE TABLE student_constraint(
	student_id INTEGER AUTO_INCREMENT,
    student_name VARCHAR(20) NOT NULL, 
    student_major VARCHAR(20) UNIQUE,
    student_age INTEGER DEFAULT 20,
    PRIMARY KEY(student_id) -- attribute set using AUTO_INCREMENT must be defined as a key
    
	-- AUTO_INCREMENT: automatically assign the index to a key so that you don't have to key in by yourself; it must be a key
    -- NOT NULL: can't be null 
    -- UNIQUE: unique value for each row of data
    -- DEFAULT: set a default value
);

DESCRIBE student_constraint;

INSERT INTO student_constraint (`student_name`, `student_age`, `student_major`) VALUES('Yvonne', 22, 'math'); 
INSERT INTO student_constraint (`student_name`, `student_age`, `student_major`) VALUES('JEAN', 23, 'history');
-- with AUTO_INCREMENT, you don't have to key in the index(student_id) by yourself
-- don't necessarily have to follow the order of attribut you've set up if writting in this way 
-- INSERT INTO student_constraint VALUES('JEAN', 23, 'history'): this from won't work for AUTO_INCREMENT
-- that is, must write in this form if applying AUTO_INCREMENT, with names of attributes in front of VALUES 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- REVISE OR DELETE DATA
SET SQL_SAFE_UPDATES = 0; -- just turn off the some default settings of SQL so that we can do our practice

CREATE TABLE student_revise(
	`id` INTEGER AUTO_INCREMENT,
    `name` VARCHAR(20),
    `major` VARCHAR(20),
    `score` INTEGER,
    PRIMARY KEY(`id`) -- attribute set using AUTO_INCREMENT must be defined as a key
);

-- INSERT 
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Yvonne', 'math', 80);
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Jean', 'biology', 90); 
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Tony', 'math', 100);
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Eric', 'chemistry', 75);
INSERT INTO student_revise(`name`, `major`, `score`) VALUES('Emma', 'biology', 50);
-- note that INSERT INTO student_revise VALUES('Yvonne', 'art', 55) won't work when using AUTO_INCREMENT

-- UPDATE ATTRIBUTES 
UPDATE student_revise SET major = 'math science' WHERE major = 'math'; -- revise the content for one attributes
UPDATE student_revise SET major = 'biochemistry' WHERE major = 'biology' OR major = 'chemistry'; -- combine and revise content for one attributes
UPDATE student_revise SET `name` = 'Victor', major = 'language' WHERE `id` = 5; -- revise multuple attributes
UPDATE student_revise SET `score` = 85; -- if not designating, it will revise the whole column

-- DELETE
DELETE FROM student_revise WHERE `id` = 1;
DELETE FROM student_revise WHERE `name` = 'Eric' OR `major` = 'math science'; -- union
DELETE FROM student_revise WHERE `name` = 'ERIC' AND `major` = 'math science'; -- intersection
DELETE FROM student_revise WHERE score < 90; -- can use <>, >=, <=, ...
DELETE FROM student_revise; -- delete all the data in the table, yet with the attributes remained
DROP TABLE student_revise; -- delete the whole table, including attributes

-- SELECT
SELECT `major`, `id` FROM student_revise; -- select multiple attributes
SELECT * FROM student_revise ORDER BY `id` DESC, score; -- descending, select data ordered by multiple attributes
SELECT * FROM student_revise LIMIT 3; -- reture only limited rows of data
SELECT * FROM student_revise ORDER BY score LIMIT 3; -- reture data in full attributes with the three lowest scores
SELECT * FROM student_revise WHERE major = 'math'; -- select data under a specific attribute requirement
SELECT * FROM student_revise WHERE major IN('math', 'biology'); -- select if meet just one of them 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- EXERCISE: CREATE COMPANY DATABASE
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
);

-- can also add some FOREIGN KEY after creating a table 
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
	
	-- use CONSTRAINT keyword to name the keys 
	-- If omitting CONSTRAINT PK_works_with from the statement, SQL server will generate a name for your PRIMARY KEY constraint for you (the PRIMARY KEY is a type of constraint)
	-- By specifically putting CONSTRAINT in the query, you are specifying a name for your key constraint
    CONSTRAINT PK_works_with PRIMARY KEY(emp_id, client_id),
    CONSTRAINT FK_works_with FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    CONSTRAINT FK_work_with FOREIGN KEY(client_id) REFERENCES `client`(client_id) ON DELETE CASCADE
); 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- IMPORT DATA FROM A FILE PATH 
LOAD DATA INFILE 'path, where \ should be /' 
INTO TABLE `table_name` 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- since the first row is title of the column

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- MORE SQL NOTES 

-- "<>" represents "not equal to" 
SELECT * FROM `table_name` WHERE (`column_name_1` = 'name_a' AND `column_name_2` = 'name_b') OR (`column_name_3` = 'name_c' AND `column_name_4` <> 'name_d');

-- can use select method after having clause
group by `col_name` having ... >=< (select ...)

-- CONCAT 
where concat(`col_name1`, `col_name2`) = `col_name_combined` -- find the combined column name

-- REGULAR EXPRESSION 
where `col_name` regexp '(a|b)$' -- use "regexp" for regular expression 

-- REMAINDER
7%2 

-- DATE 
where `date` between '2030-01-01' and '2030-01-31' -- use the string type 
where date_format(`date`, '%Y-%m-%d') <= '2000-01-31' -- use the string type  
where year(`date`) = 1963 -- use integer after using function year() 

-- LIKE / NOT LIKE 
where `col_name` like '(%)target_str'
where `col_name` not like '(%)target_str'

-- IS NULL / IS NOT NULL 
where `col_name` is null -- remember to add "is"
where `col_name` is not null -- remember to add "is"

-- IN / NOT IN 
where `col_name` in (select `col_name` from ...) -- need column name ahead and after 
where `col_name` not in (select `col_name` from ...) -- need column name ahead and after

-- EXISTS / NOT EXISTS
where exists (select * from ...) -- need to use select *
where not exists (select * from ...) -- need to use select * 

-- CASE, WHEN 
case 
when A then 'A'
when B then 'B'
else 'C'
end as '`col_name1`'

-- SELECT IF()
select if(condition, 'yes', 'no')

-- DELETE FROM TABLE 
delete from `table` 
where ...(condition)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- JOIN OPERATION

-- either use "on" or "using" 
B join A on B.`col_name` = A.`col_name`
B join A using (`col_name`)

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

-- TIME FORMATS
%Y-%m-%d     %H:%i:%s.%f

-- OTHERS TO NOTE
-- EXCEPT: need to use NOT IN (SELECT...)
SELECT E.first_name, E.last_name, E.birth_date, E.hire_date FROM employees E
-- WHERE (SELECT emp_no FROM dept_manager) NOT IN E.emp_no AND
WHERE E.emp_no NOT IN (SELECT emp_no FROM dept_manager) AND
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
-- it will not use the table from outer query
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

----------------------------------------
----------------------------------------
-- IN 
SELECT F1.FacFirstName, F1.FacLastName
FROM Faculty F1 
WHERE F1.FacNo IN 
  (SELECT O2.FacNo FROM Offering O2
	WHERE O2.CourseNo Like 'FIN%')
ORDER BY F1.FacLastName;

-- NOT IN
SELECT E.first_name, E.last_name, E.birth_date, E.hire_date
FROM employees E
WHERE E.emp_no NOT IN 
	(SELECT emp_no FROM dept_manager);

-- GROUP BY
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

----------------------------------------
----------------------------------------
