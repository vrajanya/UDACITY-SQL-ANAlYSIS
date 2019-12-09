-- LEFT & RIGHT Quizzes
-- In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.

SELECT RIGHT(a.website,3) AS EXT, COUNT(*)
	FROM accounts a
	GROUP BY EXT

-- There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).

SELECT LEFT(a.name,1) AS firstLetter , COUNT(*)
	FROM accounts a
	GROUP BY firstLetter
	ORDER BY firstLetter

-- Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?


WITH T1 AS SELECT CASE WHEN LEFT(a.name,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 ELSE 1 END AS alphabetCount,
		   CASE	WHEN LEFT(a.name,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS NumberCount
		FROM accounts a T1
	SELECT SUM(alphabetCount) ACOUNT,SUM(NumberCount) NCOUNT
	FROM T1

-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?

SELECT SUM(vowelCount) ACOUNT,SUM(notvowelCount) NCOUNT, ACOUNT/351 Per
FROM
	(SELECT CASE WHEN LEFT(LOWER(a.name),1) IN ('a','e','i','o','u') THEN 0 ELSE 1 END AS notvowelCount,
		   CASE	WHEN LEFT(LOWER(a.name),1) IN ('a','e','i','o','u') THEN 1 ELSE 0 END AS vowelCount
		FROM accounts a) T1
