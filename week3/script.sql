-- Monday typescript

SELECT * FROM Species;
.tables

-- SQL is entirely case insensitive
select * from species;

-- traditionally, all SQL keywords are written in CAPS

-- limiting rows 
SELECT * FROM Species LIMIT 5;
SELECT * FROM Species LIMIT 5 OFFSET 5;
SELECT * FROM Species LIMIT 5 OFFSET 25;

-- How many rows (match the condition)?
SELECT COUNT(*) FROM Species;

-- If put column name in COUNT(), how many non-NULL values?
SELECT COUNT(Scientific_name) FROM Species; -- must be 2 NULLs
-- very common to do a COUNT(*) to get how many rows are in a certain case

-- SELECT(*) is just the whole thing (in R)

-- How many distinct values occur?
SELECT DISTINCT Species FROM Bird_nests; -- 19 rows

-- Can select which columns to return by naming them
SELECT * FROM Species;
SELECT Code, Common_name FROM Species;
SELECT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests;

-- In R, you'd use "UNIQUE" or something similar

-- get number of distinct combinations
SELECT DISTINCT Species, Observer FROM Bird_nests;


-- Ordering of results (rows have no particular order in a database)
-- think of db as engine with its own brain -- enter query, doesn't alter it. 
-- can't rely on rows coming back in any order
-- if you want them to....
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species; -- alphabetical order

-- exercise: what distinct locations occur in the Site table? order them 
-- also, limit to 3 results
SELECT * FROM Site; -- NOTE LOCATION COLUMN

SELECT DISTINCT Location FROM Site ORDER BY Location LIMIT 3;

-- check: what did it do first (by default)?
SELECT DISTINCT Location FROM Site;
SELECT DISTINCT Location FROM Site ORDER BY Location;
SELECT DISTINCT Location FROM Site LIMIT 3;