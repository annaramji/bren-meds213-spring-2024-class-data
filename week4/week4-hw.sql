----------- Week 4: Missing data ------------------------------------
-- Which sites have no egg data? 
-- Please answer this question using all three techniques demonstrated in class.
--  In doing so, you will need to work with the Bird_eggs table, the Site table, or both. 

-- As a reminder, the techniques are:
-- Using a Code NOT IN (subquery) clause.
SELECT Code FROM Site
    WHERE Code NOT IN ( SELECT DISTINCT Site FROM Bird_eggs )
    ORDER BY Code;

-- Using an outer join with a WHERE clause that selects the desired rows. 
-- Caution: make sure your IS NULL test is performed against a column that is not ordinarily allowed to be NULL. 
-- You may want to consult the database schema to remind yourself of column declarations.
.nullvalue -NULL- 
SELECT Code FROM Site
    LEFT JOIN Bird_eggs ON Code = Site
    WHERE Code NOT IN (SELECT DISTINCT Site FROM Bird_eggs)
    ORDER BY Code;

SELECT Code
    FROM Site LEFT JOIN Bird_eggs ON Code = Site
    WHERE Site IS NULL
    ORDER BY Code; -- 14 ROWS!! YAY

-- Using the set operation EXCEPT.
SELECT Code FROM Site
    EXCEPT SELECT DISTINCT Site FROM Bird_eggs
    ORDER BY Code;

-- Add an ORDER BY clause to your queries so that all three produce the exact same result:

