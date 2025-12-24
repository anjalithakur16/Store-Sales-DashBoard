create database S_project;
use S_project;

--step 1 create table --
create table sales(
transaction_id varchar(20),
customer_id varchar(20),
customer_name varchar(20),
customer_age int ,
gender varchar(10),
product_id varchar(20),
product_name varchar(50),
product_category varchar(30),
quantiy int,
prce Float,
payment_mode varchar(15),
purchase_date Date,
time_of_purchase Time,	
status varchar(20) 
);

select * from sales;

SET DATEFORMAT  dmy 
--yyyy-mm-dd--

--step 2 insert values --

BULK INSERT sales
FROM'C:\Users\Anjali\Downloads\sales_dataset.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
);

--Step 3 Data Cleaning --

/*take copy of table -- 
select * into sales_cp from sales;
select * from sales_cp;
select * from sales;*/

--Step 1 of  data cleaning : to check duplicates --

SELECT transaction_id,COUNT(*)
from sales
GROUP BY transaction_id
HAVING COUNT(transaction_id)>1

/*TXN240646
TXN342128
TXN855235
TXN981773*/
GO
--Window function to check all duplicates details --
--here CTE is a common  table expression 

With CTE AS (
SELECT * ,
	ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id ) AS rn 
from sales	
)
/*SELECT * FROM CTE
where rn > 1*/
/*SELECT * FROM CTE
WHERE transaction_id IN('TXN240646','TXN342128','TXN855235','TXN981773')*/
DELETE FROM CTE
WHERE RN=2;

--2.Correction of headers spelling 
exec sp_rename'sales.quantiy','quantity','COLUMN'
exec sp_rename'sales.prce','price','COLUMN'
select * from sales;

--3.To check datatypes
select COLUMN_NAME , DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales';

-- EXEC sp_help sales; --it will give all info

--4.To check NULL values one by one[treating null values ]
select * 
from sales 
WHERE transaction_id is NULL
OR
customer_id is NULL
OR
customer_name is NULL
OR
customer_age is NULL
OR
gender is NULL
OR
product_id is NULL
OR
product_name is NULL
OR
product_category is NULL
OR
quantity is NULL
OR
price is NULL
OR
payment_mode is NULL
OR
purchase_date is NULL
OR
time_of_purchase is NULL
OR
status IS NULL

-- To check NULL count
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql + 
'SELECT ''' + COLUMN_NAME + ''' AS Column_Name,
        COUNT(*) AS Null_Count
 FROM sales
 WHERE ' + COLUMN_NAME + ' IS NULL
 UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales';

-- Remove last UNION ALL
SET @sql = LEFT(@sql, LEN(@sql) - 10);

EXEC (@sql);

--5.Deleting the outlier which is 1st row (After looking at the output 
DELETE FROM sales 
WHERE transaction_id IS NULL

--6.Fill NULL values 
SELECT * FROM sales
WHERE customer_name = 'Ehsaan Ram'
UPDATE sales
SET customer_id ='CUST9494'
WHERE transaction_id ='TXN977900';

SELECT * FROM sales
WHERE customer_name = 'Damini Raju'
UPDATE sales
SET customer_id ='CUST1401'
WHERE transaction_id ='TXN985663';

SELECT * FROM sales
WHERE customer_id = 'CUST1003'
UPDATE sales
SET customer_name ='Mahika Saini',customer_age ='35',gender = 'Male'
WHERE transaction_id ='TXN432798';

-- step 7 :Data cleaning(Gender)
SELECT DISTINCT gender
from sales

UPDATE sales
SET gender='Male'
WHERE gender='M';


UPDATE sales
SET gender='Female'
WHERE gender='F';

-- step 7 :Data cleaning(payment_mode)
SELECT DISTINCT payment_mode
from sales

UPDATE sales
SET payment_mode = 'Credit Card'
WHERE payment_mode = 'CC';

-------------------Data Analysis------------------------------------------
select * from sales; 
--ques1. What are the top most selling products by quantity ??
SELECT TOP 5  product_name , SUM(quantity) AS total_quantity_sold
from sales
WHERE status ='delivered'
GROUP BY product_name
ORDER BY total_quantity_sold DESC  ;

---------------------------------------------------------------------------
--Ques 2 Which products are most frequently cancelled??----------------------
SELECT * FROM sales;
SELECT TOP 5 product_name,COUNT(*) AS total_cancelled 
from sales
where status = 'cancelled'
GROUP BY product_name
ORDER BY total_cancelled desc ; 
-------------------------------------------------------------------------
--Ques 3 . What time of the day has the highest number of purchases ?
SELECT
	CASE
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18AND 23 THEN 'EVENING'
	END AS time_of_day,
	COUNT(*) AS total_orders
from sales
GROUP BY 
	CASE
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18AND 23 THEN 'EVENING'
	END
ORDER BY total_orders desc;
--------------------------------------------------------------------------------
--Ques4: Who are the top 5 highest spending customers ??
SELECT TOP 5  customer_name ,
	FORMAT(SUM(price*quantity),'C0','en-IN') AS total_spend  --N Means number format , C for currency and 0 means no decimal places 
FROM SALES
GROUP BY customer_name
ORDER BY SUM(price*quantity) desc;
-------------------------------------------------------------------------------
---Ques 5 : Which product categories generate the highest revenue??
SELECT product_category ,
	FORMAT(SUM(price*quantity),'C0','en-IN') AS total_revenue
from sales
GROUP BY product_category
ORDER BY SUM(price*quantity) desc ;
----------------------------------------------------------------------------------
--Ques 6 What is the return/cancellation rate per product category?
--cancellation
SELECT product_category,
	FORMAT(COUNT(
		CASE WHEN status = 'cancelled' THEN 1 END)*100.0/COUNT(*),'N3')+ '%' AS cancelled_rate
	FROM sales
	GROUP BY product_category
	ORDER BY cancelled_rate desc;
--return
SELECT product_category,
	FORMAT(COUNT(
		CASE WHEN status = 'returned' THEN 1 END)*100.0/COUNT(*),'N3')+ '%' AS returned_rate
	FROM sales
	GROUP BY product_category
	ORDER BY returned_rate desc;
-----------------------------------------------------------------------------------
--Ques 7 . What is the most preferred payment mode??
SELECT payment_mode,COUNT(*) AS total_paymode
FROM sales
GROUP BY payment_mode
ORDER BY total_paymode desc;
---------------------------------------------------------------------------------
--Ques 8 How does age group affect purchasing behaviour??
SELECT MIN(customer_age) ,MAX(customer_age) FROM sales

SELECT
	CASE
		WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
		ELSE '51+'
	END AS customer_age,
	FORMAT(SUM(price*quantity),'C0','en-IN') AS total_purchase
FROM sales
GROUP BY 
		CASE
			WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
			WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
			WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
			ELSE '51+'
		END
ORDER BY total_purchase DESC;
-------------------------------------------------------------------------------------------
--Ques 9. What is the monthly sales trend ??
--Method 1 
SELECT 
	FORMAT(purchase_date,'yyyy-MM') AS Month_year,
	FORMAT(SUM(price*quantity),'C0','en-IN') AS total_sales,
	SUM(quantity) AS total_quantity
FROM sales
GROUP BY FORMAT(purchase_date,'yyyy-MM')
ORDER BY total_sales DESC;
---METHOD 2-----
SELECT
	YEAR(purchase_date) AS Years,
	MONTH(purchase_date) AS Months,
	FORMAT(SUM(price*quantity),'C0','en-IN') AS total_sales,
	SUM(quantity) AS total_quantity

FROM sales
GROUP BY YEAR(purchase_date),MONTH(purchase_date)
ORDER BY Months DESC;

----------------------------------------------------------------------------------
--ques 10 Are Certain genders buying more specific product categories ??
SELECT * from sales ;
--Method 1 ---
SELECT gender , product_category , COUNT(product_category) AS total_gender_purchase
FROM sales 
GROUP BY gender, product_category
ORDER BY gender desc ;

-- Method 2 PIVOT table --
SELECT *
FROM (
	SELECT gender ,product_category
	FROM sales 
	) AS source_table
PIVOT (
	COUNT(gender)
	FOR gender IN ([Male],[Female])
	) As pivot_table
ORDER by product_category ;

