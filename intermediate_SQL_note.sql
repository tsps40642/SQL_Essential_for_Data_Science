-- ** INTERMEDIATE SQL NOTES 

-- ====================================================================================================================
-- ====================================================================================================================
-- VIEWS 

-- 3-schema DB structure: external(views), conceptual(ERD), internal(physical) 
-- DB application sees the same view, and changes in conceptual and internal schemas do not affect DB application 
-- A view is a virtual or derived table; it is used in a query like a table, but DNE until derived from base tables
-- It is eaiser to query a view than base table 
-- Views provide enhanced security 
-- 3 types of views: single-table view, multiple-table view, and grouping view

-- Example: multiple-table view
-- Create a multiple-table view, named Comm_Emp_Cust_Ord,
-- showing customer name (first and last), balance, order dates, and employee names (first, last) 
-- for employees with commission of 0.04 or higher. (6 rows)
DROP VIEW IF EXISTS Comm_Emp_Cust_Ord;
CREATE VIEW Comm_Emp_Cust_Ord AS -- don't forget "AS"
	SELECT C.CustFirstName, C.CustLastName, C.CustBal, OT.OrdDate, E.EmpFirstName, E.EmpLastName
	FROM Customer C
		INNER JOIN OrderTbl OT ON C.CustNo = OT.CustNo
		INNER JOIN Employee E ON E.EmpNo = OT.EmpNo
	WHERE E.EmpCommRate >= 0.04;
-- SELECT * FROM order_entry.comm_emp_cust_ord; -- show the view 
-- Then create a query using this view to show customer 
-- names, balance and order dates for orders taken by Johnson. (2 rows)
SELECT CustFirstName, CustLastName, CustBal, OrdDate
FROM Comm_Emp_Cust_Ord
WHERE EmpLastName = 'Johnson'; -- it's just like the way we use query to select things from table 

-- Example: grouping view
-- Create a grouping view, named Product_Summary, showing total sales by product.
-- Include the product manufacturer and use the following names for the resulting three columns: 
-- ProductName, ManufName, and TotalSales. (10 rows)
CREATE VIEW Product_Summary (ProductName, ManufName, TotalSales) AS -- use renamed column
   SELECT ProdName, ProdMfg, SUM(Qty * ProdPrice)
   FROM OrderLine
	INNER JOIN Product ON OrderLine.ProdNo = Product.ProdNo
   GROUP BY ProdName;
-- SELECT * FROM order_entry.Product_Summary; -- show the view 
-- Then create a grouping query on this view to summarize the number of products and total sales by manufacturer,
-- sorted descending on total sales. (6 rows)
SELECT ManufName, COUNT(*) AS NumProd, SUM(TotalSales) AS TotalSales
FROM Product_Summary
GROUP BY ManufName -- "by manufacturer": so GROUP BY their names
ORDER BY TotalSales DESC; 

-- View modification 
-- (Skip) 

-- ====================================================================================================================
-- ====================================================================================================================
-- INDICES

-- Index is an ordered copy of one or more columns of a table 
-- Can be created on a single field or a combination of columns 
-- Can be unique or non-unique 
-- PK is automatically indexed 
-- It accelerate the process by going directly to that record number in the main table, instead of scanning the main table 

-- Use index when: 
-- Need to frequently locate a record based on a value in this field  
-- Field will be frequently used as a sort column 
-- However, it may slow down INSERT, UPDATE, and DELETE, 
-- and DBMS must update index when data is changed 

ALTER TABLE `table_name` ADD INDEX `idx_name`; -- add index 
ALTER TABLE `table_name` DROP INDEX `idx_name`; -- drop index 

-- ====================================================================================================================
-- ====================================================================================================================
-- REGULAR EXPRESSION 

-- use REGEXP keyword to match the regular expression 
select * from `table_name`
where `col_name1` regexp '(Ct|LN)$'; 

-- for other details, refer to RegEx_Cheatsheet.pdf

-- ====================================================================================================================
-- ====================================================================================================================
-- COMMON TABLE EXPRESSION (CTE)  

-- CTEs can refer to other CTEs and themselves, enabling recursive queries 
-- Recursive CTEs contain 4 main parts: 
-- 1. Anchor member: a query that forms the base for the CTE 
-- 2. Recursive member: a query that references the CTE joined with Anchor query with UNION ALL 
-- 3. Termination criteria: explicitly / implicitly ensure the recursion stops 
-- 4. Resulting query: a query that uses the recursive CTE to display results 

-- Example: non-recursive CTE 
with distinct_request as (
    select distinct sender_id, send_to_id, request_date, count(distinct sender_id, send_to_id) as request_num
	-- so here we count distinct dates
    from FriendRequest
), distinct_accept as (
    select distinct requester_id, accepter_id -- so here not counting distinct date
    from RequestAccepted
) -- there are 2 CTEs in this example 
select 
case 
when round(sum(if(accepter_id is not null, 1, 0))/request_num, 2) is null then 0
else round(sum(if(accepter_id is not null, 1, 0))/request_num, 2) end as accept_rate
from distinct_request, distinct_accept

-- Example: non-recursive CTE 
-- the way we select from CTE is the same from Type I and II query 
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

-- Example: recursive CTE 
-- Use a recursive CTE to reconstruct the employee supervisory hierarchy
-- Use employee numbers, first and last name, supervisor number, and employee level
-- The end result must show the employee's full name, level, and supervisor's full name 
WITH RECURSIVE Employee_Supervisor(EmpNo, FName, LName, SupNo, EmpLvl) AS ( -- remember to add RECURSIVE 
	-- Anchor member: retrieves top-level supervisors
	SELECT EmpNo, EmpFirstName, EmpLastName, SupEmpNo, 1 -- 1 is the employee level
	FROM Employee 
	WHERE SupEmpNo IS NULL -- no supervisor, indicating the anchor member (top employee) 
	
	UNION ALL
	
	-- Recursive member: 
	-- retrieves next level employees who's supervisors (E.SupEmpNo) are the employees (ES.EmpNo) one level higher,
	-- starting with the top-level in the anchor query 
	SELECT E.EmpNo, E.EmpFirstName, E.EmpLastName, E.SupEmpNo, (ES.EmpLvl + 1) 
	FROM Employee E
		INNER JOIN Employee_Supervisor ES ON E.SupEmpNo = ES.EmpNo 
)
SELECT CONCAT(FName, ' ', LName) AS EmpName, EmpLvl, 
  (SELECT CONCAT(EmpFirstName, ' ', EmpLastName) FROM Employee
	  WHERE EmpNo = Employee_Supervisor.SupNo) AS SupName
FROM Employee_Supervisor
ORDER BY EmpLvl, SupNo;

-- ====================================================================================================================
-- ====================================================================================================================
-- WINDOW FUNCTIONS 

-- WINDOW FUNCTIONS maintain the number of rows in the result set 
-- One row of input will generate one row of output 
-- follow this structure when using window functions: 

select `col_name1`, `col_name2`, 
	-- all follow this format: 
	-- `aggregate_function_name(arguments if needed)` over `window_name` as `col_name3`
	
	-- ranking of a window frame 
	ROW_NUMBER() OVER `window_name` AS RowNo, -- ROW_NUMBER(): numbers all rows sequentially (for example 1, 2, 3, 4, 5)
	RANK() OVER `window_name` AS StdClassRank, -- RANK(): provides the same numeric value for ties (for example 1, 2, 2, 4, 5), no 3rd
	DENSE_RANK() OVER(PARTITION BY StoreID ORDER BY NumRentals) AS CustDenseRank -- consecutive order (for example 1, 2, 2, 3, 4)
	PERCENT_RANK
	
	-- first / last row of a window frame 
	FIRST_VALUE(CONCAT(StdFirstName, ' ', StdLastName)) OVER `window_name` AS FirstStudent, -- gives the first row of a window frame 
	LAST_VALUE(CONCAT(StdFirstName, ' ', StdLastName)) OVER `window_name` AS LastStudent, -- gives the last row of a window frame 
	
	-- row before / after the current row 
	LAG(`col_name1`, 2, `default_value`) OVER `window_name` AS Previous2Row, -- returns the previous 2nd row, if there's no then use `default_value` to fill 
	LEAD(col_name1`, 5, `default_value`) OVER `window_name` AS After5Row, -- returns the value of the cell in `col_name` with specified number of rows after the current row 
	
	-- count the number of rows 
	COUNT(*) OVER `window_name` AS CumulCount,
	
	-- average 
	ROUND(AVG(StdGPA) OVER `window_name`, 2) AS AvgGPA
	
from `table_name` 
-- define a window frame 
window `window_name` as 
	-- if need to group, use this line 
	(partition by `want_to_group_col` order by `want_to_rank_col` desc)
	-- if no need to group, use this line  
	(order by `want_to_rank_col` desc)
