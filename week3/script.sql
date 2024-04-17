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


-- Wednesday typescript, Day 2: 2024 April 17

.maxrow 6
SELECT Location FROM Site;

SELECT * FROM Site WHERE Area < 200;
-- LIKE is used for pattern matching (uses % instead of *, note about "how old SQL is")
-- all data bases support regular expressions
-- case sensitive on duckdb, not elsewhere
SELECT * FROM Site WHERE Area < 200 AND Location LIKE '%USA';

-- use ILIKE for insensitive matching, WHERE used to filter
SELECT * FROM Site WHERE Area < 200 AND Location LIKE '%usa'; -- returns 0 rows
SELECT * FROM Site WHERE Area < 200 AND Location ILIKE '%usa'; -- returns 4 rows

-- expressions
SELECT Site_name, Area FROM Site; 
-- CONVERT TO ACRES
SELECT Site_name, Area*2.47 FROM Site; -- NOTE, NAME OF COLUMN IS WHOLE EXPRESSION
SELECT Site_name, Area*2.47 AS Area_acres FROM Site; -- column name is now Area_acres

-- string concatenation operator ||
SELECT Site_name || 'foo' FROM Site;


-- aggregation function
SELECT COUNT(*) FROM Site;
SELECT COUNT(*) AS num_rows FROM Site;

.help mode
.mode box
SELECT Site_name, Area*2.47 AS Area_acres FROM Site; -- column name is now Area_acres
.mode duckbox -- SHOW VARIABLE DATA TYPE
SELECT COUNT(Scientific_name) FROM Species;

SELECT DISTINCT Relevance FROM Species;

SELECT COUNT(DISTINCT Relevance) FROM Species; -- like combining with count *

-- MIN, MAX, AVG
SELECT AVG(Area) FROM Site; -- collapse all rows to just one output: average area
SELECT MIN(Area) FROM Site; -- note, NULL values are ignored
SELECT MAX(Area) FROM Site;


-- grouping
SELECT * FROM Site; -- view Site table, note a number of sites occur in the same Location
-- what is the largest area for each of those locations?
SELECT Location, MAX(Area)
    FROM Site
    GROUP BY Location;

-- how many sites are there within each Location?
SELECT Location, COUNT(*)
    FROM Site
    GROUP BY Location; -- COUNT how many rows are in each group 
    -- if you put in a column name, non null ... ?

-- SELECT * FROM Species;
-- HOW many species there are in each relevance

SELECT Relevance, COUNT(*) 
    FROM Species
    GROUP BY Relevance;
    
-- how many non null scientific names there are in each group
SELECT Relevance, COUNT(Scientific_name) 
    FROM Species
    GROUP BY Relevance; -- adds up to 97, not 99, 2 null in avian

-- adding WHERE clause
SELECT Location, MAX(Area)
    FROM Site
    GROUP BY Location;
-- if you only want to do this for Locations in Canada
SELECT Location, MAX(Area)
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location;
-- follows the order of the clauses in the statement ^^
-- first selecting which rows we want to operate on, then doing the grouping

-- seelct, grouping, further restriction on which groups you want to return
SELECT Location, MAX(Area) AS Max_area
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200; --only want to show those where the largest area is greater than 200

    