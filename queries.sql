-- SELECT * : select all the columns
-- FROM : table
SELECT * FROM employees;

-- SELECT some specific columns from the table
SELECT firstName, lastName, email FROM employees;

-- SELECT some specific columns from the table
-- and rename the columns
SELECT firstName AS "First Name", 
   lastName AS "Last Name",
   email AS "Email" FROM employees;

-- SELECT can be thought as a FUNCTION
-- that returns a new table
-- SELECT * or SELECT [col] 
-- TO FILTER BY ROWS use WHERE
-- display the first name, last name and email from employees in office code 2
SELECT email, firstName, lastName FROM employees WHERE officeCode = 2;

-- display all columns from the customers table where their country is USA
select * from customers where country = "USA";

-- we can use LIKE and wildcards %
-- partial string matches
SELECT * FROM employees WHERE jobTitle LIKE "%sales";
-- results will be "VP Sales"
SELECT * FROM employees WHERE jobTitle LIKE "sales%";
-- sales rep, sales manager

-- we repeat multiple cards multiple times
-- the following show any rows as long as its jobTitle includes
-- the string "sales"
SELECT * FROM employees WHERE jobTitle LIKE "%sales%";

-- logical operators AND/OR works as usual
-- AND: the row must match all the criteria
SELECT * FROM employees WHERE jobTitle LIKE "Sales Rep"
	AND officeCode = 1;

-- OR: the row must match one of the criteria
SELECT * FROM employees WHERE officeCode = 1 OR officeCode = 2;

-- REMEMBER: And has higher precedence than OR
select * from employees where jobTitle LIKE "Sales Rep" 
	AND (officeCode = 2 OR officeCode =1)


-- Q1. show all the customers from the USA in the state NV
-- who has credit limit more than 5000
SELECT * FROM customers where country = "USA" 
  and state = "NV"
  and creditLimit > 5000;


-- Q2. show all the customers who are in the USA or Singapore and
-- at the same time has creditLimit less than 10000
select * from customers where (country = "USA" or country="Singapore") and creditLimit < 10000;

-- JOIN TWO TABLES
SELECT * FROM employees JOIN offices
  ON employees.officeCode = offices.officeCode

-- display the first name, last name, email and city for each employee
SELECT * FROM employees JOIN offices
  ON employees.officeCode = offices.officeCode

-- SELECT * and WHERE will work on the joined table
-- we can filter by columns that we never select
SELECT firstName, lastName, email, city FROM employees JOIN offices
  ON employees.officeCode = offices.officeCode
  WHERE jobTitle LIKE "Sales Rep";
  


-- for each customer display their customerName and
-- the first name, last name and email address of their sales rep
SELECT customerName, firstName, lastName, email FROM customers JOIN employees
 ON employees.employeeNumber = customers.salesRepEmployeeNumber

 -- if there are two columns with the name in the joined table
 -- then we need specify when selecting them which table to 
 -- take from (as in the case of officeCode below:)
 SELECT offices.officeCode, firstName, lastName, email FROM employees JOIN offices
   ON employees.officeCode = offices.officeCode
   
-- get the current date
select curdate();

-- get the current date and time
select now();

-- display all payments made after 30th June 2003
select * from payments where paymentDate > "2003-06-30";

-- display all payments made between 1st Jan 2003 and 30th June 2003
SELECT * from payments where paymentDate >= "2003-01-01" 
AND paymentDate <="2003-06-30";

-- display all payments made between 1st Jan 2003 and 30th June 2003
SELECT * from payments where paymentDate BETWEEN "2003-01-01" AND "2003-06-30";

-- show all the payments made in year 2003, but I want the day, month and year
-- in different columns
select customerNumber, checkNumber, YEAR(paymentDate), MONTH(paymentDate), DAY(paymentDate) from payments;

-- show all payments made in June 2003
select * FROM payments WHERE YEAR(paymentDate) = "2003"
 AND MONTH(paymentDate) = "6";

 -- show all payments made in June 2003
select * FROM payments WHERE paymentDate BETWEEN "2003-06-01" AND "2003-06-30";

-- HANDS ON
-- 1 - Find all the offices and display only their city, phone and country
SELECT city, phone, country FROM offices;

-- 2 - Find all rows in the orders table that mentions FedEx in the comments.
SELECT * FROM orders WHERE comments LIKE "%FedEx%";

-- 3 - Show the contact first name and contact last name of all customers in descending order by the customer's name
SELECT contactFirstName, contactLastName FROM customers ORDER BY customerName DESC

-- 4 - Find all sales rep who are in office code 1, 2 or 3 and their first name or last name contains the substring 'son'
SELECT * FROM employees WHERE (officeCode = 1 OR officeCode =2 OR officeCode =3) 
   AND  (firstName LIKE "%son%" OR lastName LIKE "%son%") AND jobTitle LIKE "Sales Rep";
SELECT * FROM employees WHERE officeCode IN (1,2,3)

-- 5 - Display all the orders bought by the customer with the customer number 124, along with the customer name, the contact's first name and contact's last name.
SELECT customerName, contactFirstName, contactLastName, orders.* from customers JOIN orders ON
    customers.customerNumber = orders.customerNumber
    WHERE customers.customerNumber = 124;

-- Count how many employees there are
select count(employeeNumber) from employees;

-- Count how many orders there are in orderNumbers
-- count (DISTINCT orderNumber) will not count the duplicates
SELECT count(DISTINCT orderNumber) FROM orderdetails;

-- Add up all the credit limit for customers
SELECT sum(creditLimit) FROM customers;

SELECT orderNumber, productCode, quantityOrdered * priceEach AS "Line Total" FROM orderdetails;

SELECT SUM(quantityOrdered * priceEach) FroM orderdetails;

-- show the total revenue made in year 2004:
-- show the total amount earned in the orderdetails table
-- for orders that take place in 2004
select SUM(quantityOrdered * priceEach) from orders JOIN orderdetails
 ON orders.orderNumber = orderdetails.orderNumber
 WHERE YEAR(orderDate) = 2004;

-- AVG stands for "average"
 select AVG(creditLimit) from customers;

 -- Find the MAXIMUM creditLimit
 select MAX(creditLimit) from customers;

 -- Find the MINIMUM creditLimit that is not 0
 --  reminder: WHERE happens before SELECT, which is why this works
 select MIN(creditLimit) from customers where creditLimit > 0;

 -- GROUP BY allows us to perform aggregate functions on groups
 -- display the average credit limit for customers by country
SELECT AVG(creditLimit), country FROM
 customers
 GROUP BY country

 -- remember: GROUP BY happens, then the SELECT  is applied
 -- to each group

 -- for each country, show the average credit limit for each customer there
SELECT AVG(creditLimit), city, country
FROM customers
GROUP BY city, country

-- you can select aggregate functions and whatever columns you
-- have grouped by in the GROUP BY critera.

-- show how many employees for each office code
select count(*), officeCode
from employees
group by officeCode

-- also show the city name for each office
select count(*), employees.officeCode, city
from employees JOIN offices 
 ON employees.officeCode = offices.officeCode
group by employees.officeCode, city

-- also only includes offices not in the USA
SELECT count(*), employees.officeCode, city
from employees JOIN offices 
 ON employees.officeCode = offices.officeCode
WHERE country != "USA"
GROUP BY employees.officeCode, city

-- for each office, show the number of employees
-- along with the city that the office is in
-- but exclude offices in the USA and order by the
-- number of employees in each office and only
-- show 1 result
SELECT count(*) AS "EmployeeCount", employees.officeCode, city
from employees JOIN offices 
 ON employees.officeCode = offices.officeCode
WHERE country != "USA"
GROUP BY employees.officeCode, city
HAVING EmployeeCount > 3
ORDER BY EmployeeCount ASC
LIMIT 1




-- for each sales rep, show the average credit limit of all the customers
-- for that sales rep, and only the top 3 for average credit limit. Include the first
-- and last name for the sale rep
SELECT AVG(creditLimit) as "AverageCreditLimit", employeeNumber, firstName, lastName
FROM employees JOIN customers
	ON employees.employeeNumber = customers.salesRepEmployeeNumber
WHERE country = "USA"
GROUP BY employeeNumber, firstName, lastName
HAVING count(*) >= 3
ORDER BY AverageCreditLimit DESC
LIMIT 3;

-- HANDS ON 4
-- Q6
SELECT orderdetails.*, products.productName FROM orderdetails JOIN products
  ON orderdetails.productCode = products.productCode

-- Q7
SELECT customers.customerNumber, customerName, SUM(amount)
FROM customers JOIN payments ON
  customers.customerNumber = payments.customerNumber
 WHERE country = "USA"
 GROUP BY customers.customerNumber, customerName

 -- Q8
 SELECT customers.customerNumber, customers.customerName, payments.* FROM customers JOIN payments
 ON customers.customerNumber = payments.customerNumber
 WHERE country="USA" or country="UK"

 -- Q9
 SELECT state, COUNT(employeeNumber) FROM employees
 JOIN offices ON employees.officeCode = offices.officeCode
 WHERE country = "USA"
 GROUP BY state;

 -- Q10
 SELECT MONTH(orderDate), count(orderNumber) FROM
 orders WHERE orderDate
 between "2003-01-01" AND "2003-12-31"
 GROUP BY MONTH(orderDate)

 -- Q11
 SELECT customers.customerNumber, customerName, AVG(amount) FROM
  payments JOIN customers
  ON payments.customerNumber = customers.customerNumber
  GROUP BY customers.customerNumber,  customerName
  ORDER BY AVG(amount) DESC

-- Q12
SELECT COUNT(*), productLine FROM products
GROUP BY productLine
ORDER BY COUNT(*) DESC

-- Q13
SELECT AVG(amount) AS `Average Amount`, customers.customerNumber
FROM customers JOIN payments
ON customers.customerNumber = payments.customerNumber
GROUP BY customers.customerNumber
HAVING AVG(amount) > 10000
ORDER BY `Average Amount`;

-- Q14
SELECT products.productCode, SUM(quantityOrdered)
FROM products JOIN orderdetails
ON products.productCode = orderdetails.productCode
GROUP BY products.productCode
ORDER BY SUM(quantityOrdered) DESC
LIMIT 10