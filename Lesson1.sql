--Question 1: Try using LIMIT yourself below by writing a query that displays all the data in the occurred_at, account_id, and channel columns of the web_events table, and limits the output to only the first 15 rows.
SELECT occurred_at,account_id,channel FROM web_events Limit 15;

-- Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
-- Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
-- Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.

SELECT id, occurred_at,total_amt_usd FROM orders ORDER BY occurred_at ASC LIMIT 10;
SELECT id, account_id,total_amt_usd FROM orders ORDER BY total_amt_usd DESC LIMIT 5;
SELECT id, account_id,total_amt_usd FROM orders ORDER BY total_amt_usd ASC LIMIT 20;

-- Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).

-- Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).

-- Compare the results of these two queries above. How are the results different when you switch the column you sort on first?

SELECT id, account_id,total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

SELECT id, account_id,total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC,account_id;

-- Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
-- Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.

SELECT * FROM orders WHERE gloss_amt_usd>=1000 LIMIT 5;
SELECT * FROM orders WHERE total_amt_usd<500 LIMIT 10;

--Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.

SELECT name,website,primary_poc FROM accounts WHERE name = 'Exxon Mobil';

-- Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields.

-- Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also. NOTE - you will receive an error with the correct solution to this question. This occurs because at least one of the values in the data creates a division by zero in your formula. You will learn later in the course how to fully handle this issue. For now, you can just limit your calculations to the first 10 orders, as we did in question #1, and you'll avoid that set of data that causes the problem.

SELECT id, account_id, (standard_amt_usd/standard_qty) AS standard_unit_price FROM orders LIMIT 10;
SELECT id, account_id, poster_amt_usd/ (standard_amt_usd+gloss_amt_usd+poster_amt_usd)*100 AS revenue_poster FROM orders LIMIT 10;

-- All the companies whose names start with 'C'.

-- All companies whose names contain the string 'one' somewhere in the name.

-- All companies whose names end with 's'.

SELECT name FROM accounts WHERE name LIKE 'C%';
SELECT name FROM accounts WHERE name LIKE '%one%';
SELECT name FROM accounts WHERE name LIKE '%s';

-- Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
-- Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
SELECT name,primary_poc,sales_rep_id FROM accounts WHERE name IN ('Walmart','Target','Nordstrom');
SELECT * FROM web_events WHERE channel IN ('organic','adwords');

-- Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.

-- Use the web_events table to find all information regarding individuals who were conta
cted via any method except using organic or adwords methods.

SELECT name,primary_poc,sales_rep_id FROM accounts WHERE name NOT IN ('Walmart','Target','Nordstrom');
SELECT * FROM web_events WHERE channel NOT IN ('organic','adwords');

-- Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.

-- Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.

-- When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? Figure out the answer to this important question by writing a query that displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. Then look at your output to see if the BETWEEN operator included the begin and end values or not.

-- Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.

SELECT * FROM orders WHERE standard_qty>1000 AND poster_qty =0 AND gloss_qty =0;
SELECT name FROM accounts WHERE name NOT LIKE 'C%' AND name LIKE '%s';
SELECT occurred_at,gloss_qty FROM orders WHERE gloss_qty BETWEEN 24 AND 29;
SELECT * FROM web_events WHERE channel IN ('organic','adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01' ORDER BY occurred_at DESC;

-- Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.

-- Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.

-- Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
SELECT id FROM orders WHERE gloss_qty >4000 OR poster_qty > 4000;
SELECT * FROM orders WHERE standard_qty = 0 AND (poster_qty > 1000 OR gloss_qty > 1000);
SELECT name FROM accounts WHERE (name LIKE 'C%' OR name LIKE 'W%')
AND (primary_poc NOT LIKE 'eana%')
AND (primary_poc LIKE '%ANA%' OR primary_poc LIKE '%Ana%');


