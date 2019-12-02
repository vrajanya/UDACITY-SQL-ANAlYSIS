-- Here is the necessary quiz to pull the first month/year combo from the orders table.

SELECT DATE_TRUNC('month', MIN(occurred_at))
FROM orders;

-- Then to pull the average for each, we could do this all in one query, but for readability, I provided two queries below to perform each separately.

SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

-- First, we needed to group by the day and channel. Then ordering by the number of events (the third column) gave us a quick way to answer the first question.

SELECT DATE_TRUNC('day',occurred_at) AS day,
   channel, COUNT(*) as events
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC;
-- Here you can see that to get the entire table in question 1 back, we included an * in our SELECT statement. You will need to be sure to alias your table.

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
           channel, COUNT(*) as events
     FROM web_events
     GROUP BY 1,2
     ORDER BY 3 DESC) sub;
-- Finally, here we are able to get a table that shows the average number of events a day for each channel.

SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT RegionName,MaxTotal,repName
FROM
	(SELECT RegionNmae AS RegionName, MAX(total) AS MaxTotal
	 FROM
		 (SELECT s.name as repName,r.name RegionNmae, SUM(o.total_amt_usd) total
		 	FROM accounts a
			JOIN orders o ON a.id = o.account_id
			JOIN sales_reps s ON s.id = a.sales_rep_id
			JOIN region r ON r.id= s.region_id
	        GROUP BY RegionNmae,repName) TBl1
	GROUP BY RegionNmae) TBl2
JOIN
	(SELECT s.name as repName,r.name RegionNmae, SUM(o.total_amt_usd) total
		 	FROM accounts a
			JOIN orders o ON a.id = o.account_id
			JOIN sales_reps s ON s.id = a.sales_rep_id
			JOIN region r ON r.id= s.region_id
	        GROUP BY RegionNmae,repName) TBl3
ON TBl3.RegionNmae= TBl2.RegionName AND TBl2.MaxTotal= TBl3.total


-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
	(SELECT r.name regionName, SUM(o.total_amt_usd) totalAmount, COUNT(o.id) totalOrders
		FROM orders o
		JOIN accounts a ON a.id = o.account_id
		JOIN sales_reps s ON s.id = a.sales_rep_id
		JOIN region r ON r.id =s.region_id
		GROUP BY regionName
        ORDER BY totalAmount DESC LIMIT 1) T1

-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
SELECT T3.AccoName
FROM
	(SELECT a.name AccoName, SUM(o.standard_qty) TotalStandard, SUM(o.total) totalPurchases
			FROM accounts a
			JOIN orders o ON a.id = o.account_id
			GROUP By AccoName) T3
WHERE T3.totalPurchases >
		(SELECT totalPurchases
		FROM
			(SELECT a.name AccoName, SUM(o.standard_qty) TotalStandard, SUM(o.total) totalPurchases
				FROM accounts a
				JOIN orders o ON a.id = o.account_id
				GROUP By AccoName ORDER BY TotalStandard DESC LIMIT 1) T1)

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

SELECT a.name, w.channel ,COUNT(W.id) NoOfEvents
	FROM
	web_events w
	JOIN accounts a on a.id = w.account_id
	GROUP BY a.name, w.channel
	HAVING a.name = (SELECT T1.AccoName
						FROM
							(SELECT a.name AccoName, SUM(o.total_amt_usd)
								FROM orders o
								JOIN accounts a ON a.id = o.account_id
								GROUP BY AccoName
								ORDER BY SUM(o.total_amt_usd) DESC
								LIMIT 1) T1)

-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

SELECT AVG(T1.totalSpending)
FROM
	(SELECT a.name AccoName, SUM(o.total_amt_usd) totalSpending
		FROM orders o
		JOIN accounts a ON a.id = o.account_id
		GROUP BY AccoName
		ORDER BY totalSpending DESC LIMIT 10) T1

-- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

SELECT AVG(spendPerOrder)
FROM (SELECT a.name , AVG(o.total_amt_usd) spendPerOrder
		FROM orders o
		JOIN accounts a ON a.id = o.account_id
		GROUP BY a.name
		HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) AVGAllOrders	FROM orders o)
		) T1