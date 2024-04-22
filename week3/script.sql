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

-- select, grouping, further restriction on which groups you want to return
SELECT Location, MAX(Area) AS Max_area
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200; --only want to show those where the largest area is greater than 200

-- relational algebra peeks through!
SELECT COUNT(*) FROM Site; -- when you do any query, returns a table 
-- (cute baby table in this case: 1 column, column has a name, has 1 row, data type)
-- every operation in SQL returns a table
-- to prove it: (note: Greg put spaces at beginning and end like ( this ))
SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM Site ); -- :)

-- Bird nest table
SELECT * FROM Bird_nests LIMIT 3;
-- ARE THERE ANY SPECIES FOR WHICH WE HAVE NO BIRD NEST DATA?
SELECT COUNT(*) FROM Species; -- 99 TOTAL SPECIES
-- tell me the species that we have no nest data for
SELECT * FROM Species
    WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests ); 
    -- 80 rows: we have data for 19 species, no data for 80 (total was 99)

SELECT COUNT(Scientific_name) FROM Species; -- don't have 2 scientific names


-- don't want momentary queries (they're gonna evaporate!)
CREATE TEMP TABLE t AS 
    SELECT * FROM Species
        WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests ); 

SELECT * FROM t; -- and there's a table!

-- TEMP keyword means that as soon as you exit out of duckdb, that table is gone. 
-- remove TEMP if you want it to be permanent
CREATE TABLE t_perm AS 
    SELECT * FROM Species
        WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests ); -- without doing a join

SELECT * FROM t_perm; -- saved in duckdb
-- remove table
DROP TABLE t_perm;

-- NULL processing ----------
-- floatAge (real number, determine egg age by floating them in water)
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge > 5; -- 70
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge <= 5; -- 97
SELECT COUNT(*) FROM Bird_nests; -- 1547 rows... 
-- other rows are null: if floatAge is null, null > 5, is not T or F! it's NULL
-- tri-value logic! it's ordinal. NULL > 5? NULL.
SELECT COUNT(*) FROM Bird_nests WHERE floatAge = NULL; -- RETURNS 0

-- is NULL = NULL? "I don't know. NULL"
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NULL; -- RETURNS 1380
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NOT NULL; -- RETURNS 167

-- JOINS!
SELECT * FROM Camp_assignment; -- 441 rows
-- full names are in Personnel table
SELECT * FROM Personnel; -- 269 rows
SELECT * FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation; -- tells how they're related
    -- note: both columns are retained...

-- could join bird nest table with species table, do an outer join to find out which species we have data for

.mode csv -- to see all of the columns
SELECT * FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 3; -- tells how they're related

.mode duckbox
SELECT Year, Site, Abbreviation, Name, Start, "End" -- End is a special thing in SQL so have to put it in quotes
    FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 3;

-- getting a lot of duplicated information
SELECT * FROM Camp_assignment JOIN Personnel -- End is a special thing in SQL so have to put it in quotes
    ON Observer = Abbreviation;


-- more stuff about joins -- column names are ambiguous in query
SELECT * FROM Camp_assignment JOIN Personnel
    ON Camp_assignment.Observer = Personnel.Abbreviation; -- specifies which table they're from

SELECT * FROM Camp_assignment AS ca JOIN Personnel p -- don't need to say AS for either/both
    ON ca.Observer = p.Abbreviation;

SELECT * FROM Camp_assignment ca JOIN Personnel p -- don't need to say AS
    ON ca.Observer = p.Abbreviation;

-- multiway joins
.mode csv
SELECT * FROM Camp_assignment ca JOIN Personnel p
    ON ca. Observer = p.Abbreviation
    JOIN Site s 
    ON ca.Site = s.Code
    LIMIT 3;

.mode duckbox
SELECT * FROM Camp_assignment ca JOIN Personnel p
    ON ca. Observer = p.Abbreviation
    JOIN Site s 
    ON ca.Site = s.Code
    WHERE ca.Observer = 'lmckinnon'
    LIMIT 3;

-- order by: at end
SELECT * FROM Camp_assignment ca JOIN (
    SELECT * FROM Personnel ORDER BY Abbreviation -- that ORDER BY is lost unless it's the very last step
) p
    ON ca. Observer = p.Abbreviation
    JOIN Site s 
    ON ca.Site = s.Code
    WHERE ca.Observer = 'lmckinnon'
    LIMIT 3;

-- how many bird eggs are in each nest?
SELECT Nest_ID, COUNT(*) FROM Bird_eggs 
    GROUP BY Nest_ID;



--------------------- week 4 -----------------------------

.tables
--SELECT Nest_ID, COUNT(*) FROM Bird_eggs 
SELECT Species FROM Bird_nests WHERE Site = 'nome';

------ nested tables, joins -----
SELECT Scientific_name, Nest_count FROM 
(SELECT Species, COUNT(*) AS Nest_count
    FROM Bird_nests WHERE Site = 'nome'
    GROUP BY Species
    ORDER BY Species
    LIMIT 2) JOIN Species ON Species = Code;

-- outer joins

