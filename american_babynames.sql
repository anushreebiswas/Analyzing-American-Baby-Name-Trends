--CLASSIC AMERICAN names
--Select first_name and the total number of babies that have ever been given that name.
--Group by first_name and filter for those names that appear in all 101 years.
--Order the results by the total number of babies that have ever been given that name, descending. 

SELECT first_name,sum(num)
FROM baby_names
GROUP BY first_name
HAVING COUNT(year)=101
ORDER BY SUM(num) DESC;


--Timeless or trendy?
--Select first_name, the sum of babies who've ever been given that name, and popularity_type.
--Classify all names in the dataset as 'Classic,' 'Semi-classic,' 'Semi-trendy,' or 'Trendy' based on whether the name appears in the dataset more than 80, 50, 20, or 0 times, respectively.
--Alias the new classification column as popularity_type.
--Order the results alphabetically by first_name

SELECT first_name, SUM(num),
    CASE WHEN COUNT(year) > 80 THEN 'Classic'
        WHEN COUNT(year) > 50 THEN 'Semi-classic'
        WHEN COUNT(year) > 20 THEN 'Semi-trendy'
        ELSE 'Trendy' END AS popularity_type
FROM baby_names
GROUP BY first_name
ORDER BY first_name;

--Top-ranked female names since 1920
--Select name_rank, first_name, and the sum of babies who've ever had that name.
--RANK the first_name by the sum of babies who've ever had that name, aliasing as name_rank and showing the names in descending order by name_rank.
--Filter the data to include only results where sex equals 'F'.
--Limit to ten results.

SELECT
    RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank,
    first_name, SUM(num)
FROM baby_names
WHERE sex = 'F'
GROUP BY first_name
LIMIT 10;


--Picking a baby name
--Select only the first_name column.
--Filter the data for results where sex equals 'F', the year is greater than 2015, and the first_name ends in an 'a.'
--Group the data by first_name and order by the total number of babies ever given that first_name, descending.

SELECT first_name FROM baby_names
WHERE sex='F' AND year>2015 AND first_name LIKE '%a'
GROUP BY first_name
ORDER BY SUM(num) DESC


--The Olivia expansion
--Select year, first_name, num of Olivias in that year, and cumulative_olivias.
--Using a window function, sum the cumulative number of babies who have ever been named Olivia up to that year; alias as cumulative_olivias.
--Filter the results so that only data for the name Olivia is returned.
--Order the results by year from the earliest year Olivia appeared in the dataset to the most recent.

SELECT year, first_name, num,
    SUM(num) OVER (ORDER BY year) AS cumulative_olivias
FROM baby_names
WHERE first_name = 'Olivia'
ORDER BY year;


--Many males with the same name
--Select the year and the maximum num of babies given any one male name in that year; alias the maximum as max_num.
--Filter the data to include only results where sex equals 'M'.

SELECT year,MAX(num) AS max_num FROM baby_names
WHERE sex='M'
GROUP BY year
ORDER BY MAX(num) DESC


--Top male names over the years
--Select year, the first_name given to the largest number of male babies, and num of babies given the first_name that year.
--Join baby_names to the code in the last task as a subquery, using whatever alias you like and joining on both columns in the subquery.
--Order the results by year, starting with the most recent year.

SELECT b.year, b.first_name, b.num
FROM baby_names AS b
INNER JOIN (
    SELECT year, MAX(num) as max_num
    FROM baby_names
    WHERE sex = 'M'
    GROUP BY year) AS subquery 
ON subquery.year = b.year 
    AND subquery.max_num = b.num
ORDER BY year DESC;

--The most years at number one
--Select first_name and a count of the number of years that the first_name appeared as a year's top name in the last task; alias this count as count_top_name.
--To do this, use the code from the previous task as a common table expression.
--Group by first_name and order the results from the name with the most years at the top to the name with the fewest.

WITH top_male_names AS (
    SELECT b.year, b.first_name, b.num
    FROM baby_names AS b
    INNER JOIN (
        SELECT year, MAX(num) num
        FROM baby_names
        WHERE sex = 'M'
        GROUP BY year) AS subquery 
    ON subquery.year = b.year 
        AND subquery.num = b.num
    ORDER BY YEAR DESC
    )
SELECT first_name, COUNT(first_name) as count_top_name
FROM top_male_names
GROUP BY first_name
ORDER BY COUNT(first_name) DESC;