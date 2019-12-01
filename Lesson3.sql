-- Find the total amount of poster_qty paper ordered in the orders table.

SELECT SUM(poster_qty) FROM orders;
--723646
-- Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) FROM orders;
--1938346
-- Find the total dollar amount of sales using the total_amt_usd in the orders table.

SELECT SUM(total_amt_usd) FROM orders;
--23141511.83
-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
SELECT (standard_amt_usd+gloss_amt_usd) AS total_amt FROM orders;
-- Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.

SELECT SUM(standard_amt_usd)/SUM(standard_qty) FROM orders;

-- When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at) FROM orders;

-- Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at FROM orders ORDER BY occurred_at LIMIT 1;

-- When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) FROM web_events;

-- Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at FROM web_events ORDER BY occurred_at DESC LIMIT 1;

-- Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT AVG(standard_amt_usd) Standard_AVG_USD,AVG(gloss_amt_usd) gloss_AVG_USD,AVG(poster_amt_usd) poster_AVG_USD,AVG(standard_qty) Standard_AVG_qty,AVG(gloss_qty) gloss_AVG_qty,AVG(poster_qty) poster_AVG_qty FROM orders;

-- Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?

SELECT * FROM (SELECT total_amt_usd FROM orders ORDER by total_amt_usd LIMIT (SELECT count(*) FROM orders)/2) M ORDER BY M.total_amt_usd DESC LIMIT 2;

-- Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name, MIN(o.occurred_at)
FROM accounts a
JOIN orders o ON o.account_id= a.id
GROUP BY a.name ORDER BY MIN(o.occurred_at) LIMIT 1;

SELECT a.name, o.occurred_at, o.account_id,a.id FROM accounts a JOIN orders o ON o.account_id= a.id ORDER By o.occurred_at LIMIT 1

-- Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT a.name, SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o ON o.account_id= a.id
GROUP BY a.name;

-- Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT w.channel, w.occurred_at, a.name
FROM web_events w
JOIN accounts a ON w.account_id= a.id
ORDER BY w.occurred_at DESC LIMIT 1


-- Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.

SELECT channel, COUNT(channel) usedTimes FROM web_events Group BY channel

-- Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM accounts a
JOIN web_events w ON a.id= w.account_id
WHERE w.occurred_at IN (SELECT MIN(occurred_at) FROM web_events)

SELECT a.primary_poc
FROM accounts a
JOIN web_events w ON a.id= w.account_id
order by w.occurred_at LIMIT 1

-- What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

SELECT a.name, MIN(o.total_amt_usd)
FROM accounts a
JOIN orders o ON a.id= o.account_id
GROUP BY a.name

-- Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT r.name, COUNT(s.name)
FROM sales_reps s
JOIN region r ON r.id =s.region_id
GROUP BY r.name

-- For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.

SELECT a.name, AVG(o.standard_qty) AVG_STD_QTY, AVG(o.gloss_qty) AVG_GLO_QTY,AVG(o.poster_qty) AVG_POS_QTY
FROM orders o
JOIN accounts a ON o.account_id =a.id
GROUP BY a.name

-- For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

SELECT a.name, AVG(o.standard_amt_usd) AVG_STD_AMT, AVG(o.gloss_amt_usd) AVG_GLO_AMT,AVG(o.poster_amt_usd) AVG_POS_AMT
FROM orders o
JOIN accounts a ON o.account_id =a.id
GROUP BY a.name

-- Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT s.name, w.channel,COUNT(w.channel) AS OCCURANCES
FROM web_events w
JOIN accounts a ON w.account_id =a.id
JOIN sales_reps s ON s.id =a.sales_rep_id
GROUP BY s.name, w.channel

-- Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT r.name, w.channel,COUNT(w.channel) AS OCCURANCES
FROM web_events w
JOIN accounts a ON w.account_id =a.id
JOIN sales_reps s ON s.id =a.sales_rep_id
JOIN region r ON s.region_id =r.id
GROUP BY r.name, w.channel ORDER BY r.name

-- Use DISTINCT to test if there are any accounts associated with more than one region.

SELECT DISTINCT a.name accountName, r.name RegionName
FROM accounts a
JOIN sales_reps s ON a.sales_rep_id = s.id
JOIN region r ON r.id = s.region_id
Order BY r.name, a.name

-- Have any sales reps worked on more than one account?

SELECT s.name SalesRepName, COUNT(s.id) HowMany
FROM accounts a
JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY s.name ORDER BY HowMany

-- How many of the sales reps have more than 5 accounts that they manage?
SELECT s.name, COUNT(s.id)
FROM sales_reps s
JOIN accounts a On a.sales_rep_id = s.id
GROUP BY s.name
Having COUNT(s.id)>5
Order By COUNT(s.id)

-- How many accounts have more than 20 orders?

SELECT a.name, COUNT(o.account_id)
FROM orders o
JOIN accounts a On a.id = o.account_id
GROUP BY a.name
Having COUNT(o.account_id)>20
Order By COUNT(o.account_id)

-- Which account has the most orders?

SELECT a.name, COUNT(o.account_id)
FROM orders o
JOIN accounts a On a.id = o.account_id
GROUP BY a.name
Order By COUNT(o.account_id) DESC LIMIT 1

-- Which accounts spent more than 30,000 usd total across all orders?

SELECT a.name, SUM(o.total_amt_usd) TT
FROM orders o
JOIN accounts a On a.id = o.account_id
GROUP BY a.name
HAVING  SUM(o.total_amt_usd) > 30000
ORDER BY TT

-- Which accounts spent less than 1,000 usd total across all orders?
SELECT a.name, SUM(o.total_amt_usd) TT
FROM orders o
JOIN accounts a On a.id = o.account_id
GROUP BY a.name
HAVING  SUM(o.total_amt_usd) < 1000
ORDER BY TT

-- Which account has spent the most with us?
SELECT a.name, SUM(o.total_amt_usd) TT
FROM orders o
JOIN accounts a On a.id = o.account_id
GROUP BY a.name
ORDER BY TT DESC LIMIT 1

-- Which account has spent the least with us?

SELECT a.name, SUM(o.total_amt_usd) TT
FROM orders o
JOIN accounts a On a.id = o.account_id
GROUP BY a.name
ORDER BY TT LIMIT 1

-- Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT a.name, count(w.id) NoChannelUsed
FROM accounts a
JOIN web_events w On a.id = w.account_id AND w.channel = 'facebook'
GROUP BY a.name
HAVING COUNT (w.id)>6
ORDER BY COUNT (w.id)


-- Which account used facebook most as a channel?

SELECT a.name, count(w.id) NoChannelUsed
FROM accounts a
JOIN web_events w On a.id = w.account_id AND w.channel = 'facebook'
GROUP BY a.name
HAVING COUNT (w.id)>6
ORDER BY COUNT (w.id) DESC LIMIT 1


-- Which channel was most frequently used by most accounts?
SELECT a.name, w.channel,count(w.id) NoChannelUsed
FROM accounts a
JOIN web_events w On a.id = w.account_id
GROUP BY a.name,w.channel
ORDER BY COUNT(w.id) DESC  LIMIT 1

-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?

SELECT SUM(o.total_amt_usd) As totalSales, DATE_PART('year', o.occurred_at)
FROM orders o
GROUP BY DATE_PART('year', o.occurred_at)
ORDER BY SUM(o.total_amt_usd) DESC

-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

SELECT SUM(o.total_amt_usd) As totalSales, DATE_PART('month', o.occurred_at)
FROM orders o
GROUP BY DATE_PART('month', o.occurred_at)
ORDER BY DATE_PART('month', o.occurred_at) DESC

-- Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
SELECT COUNT(o.id) As totalSales, DATE_PART('year', o.occurred_at)
FROM orders o
GROUP BY DATE_PART('year', o.occurred_at)
ORDER BY COUNT(o.id) DESC

-- Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
SELECT COUNT(o.id) As totalSales, DATE_PART('month', o.occurred_at)
FROM orders o
GROUP BY DATE_PART('month', o.occurred_at)
ORDER BY COUNT(o.id) DESC

-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT SUM(o.gloss_amt_usd), DATE_PART('month', o.occurred_at) MonthCol,DATE_PART('year', o.occurred_at) YearCol
FROM orders o
JOIN accounts a ON o.account_id = a.id AND a.name = 'Walmart'
GROUP BY MonthCol,YearCol
ORDER BY SUM(o.gloss_amt_usd) DESC LIMIT 1

-- Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

SELECT o.account_id, o.total_amt_usd,
	CASE WHEN o.total_amt_usd >= 3000 THEN 'Large' ELSE 'small' END AS LEVEL
FROM orders o

-- Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT COUNT(o.account_id),
	CASE WHEN (o.total) >= 2000 THEN 'At Least 2000'
	WHEN (o.total) < 2000 AND (o.total) >= 1000 THEN 'Between 1000 and 2000'
	WHEN (o.total) < 1000 THEN 'Less than 1000'
END AS Categories3
FROM orders o
GROUP BY Categories3


-- We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

SELECT a.id, a.name,
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top level'
	WHEN SUM(o.total_amt_usd) BETWEEN 200000 AND 100000 THEN 'second level'
	WHEN SUM(o.total_amt_usd) < 100000 THEN 'lowest level'
END AS LEVEL
FROM orders o
JOIN accounts a ON a.id = o.account_id
GROUP BY a.name ,a.id
ORDER BY a.id

-- We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.

SELECT a.name,DATE_PART('year',o.occurred_at),
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top level'
	WHEN SUM(o.total_amt_usd) BETWEEN 200000 AND 100000 THEN 'second level'
	WHEN SUM(o.total_amt_usd) < 100000 THEN 'lowest level'
END AS LEVEL
FROM orders o
JOIN accounts a ON a.id = o.account_id
GROUP BY a.name ,a.id,DATE_PART('year',o.occurred_at)
ORDER BY LEVEL

-- We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.

SELECT s.name, COUNT(o.account_id),
		CASE WHEN COUNT(o.account_id)> 200 THEN 'TOP' ELSE 'NOT' END AS LEVEL
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY s.name
ORDER BY COUNT(o.account_id) DESC

-- The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!

SELECT s.name, COUNT(o.account_id),SUM(o.total_amt_usd),
		CASE WHEN COUNT(o.account_id)> 200 OR SUM(o.total_amt_usd)>750000 THEN 'TOP'
			WHEN COUNT(o.account_id)> 150 OR SUM(o.total_amt_usd)>500000 THEN 'MIDDLE'
			ELSE 'LOW'
		 END AS LEVEL
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY s.name
ORDER BY SUM(o.total_amt_usd) DESC
