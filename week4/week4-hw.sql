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


SELECT Code
    FROM Site LEFT JOIN Bird_eggs ON Code = Site
    WHERE Site IS NULL
    ORDER BY Code; -- 14 ROWS!! YAY

-- Using the set operation EXCEPT.
SELECT Code FROM Site
    EXCEPT SELECT DISTINCT Site FROM Bird_eggs
    ORDER BY Code;

-- Add an ORDER BY clause to your queries so that all three produce the exact same result:

----- HW 4 Part 2: Who worked with whom? ------
-- Your goal is to answer, Who worked with whom? 
-- That is, you are to find all pairs of people who worked at the same site, 
-- and whose date ranges overlap while at that site.

-- 1 way (no Names)
SELECT A.Site, A.Observer AS Observer_1, B.Observer AS Observer_2 
    FROM Camp_assignment A 
    JOIN Camp_assignment B
        ON A.Site = B.Site -- 15521 rows
        WHERE (A.Start <= B.End)  AND  (A.End >= B.Start) -- 3500 rows
        AND A.Site = 'lkri'
        AND A.Observer < B.Observer;

┌─────────┬────────────┬──────────────┐
│  Site   │ Observer_1 │  Observer_2  │
│ varchar │  varchar   │   varchar    │
├─────────┼────────────┼──────────────┤
│ lkri    │ apopovkina │ jloshchagina │
│ lkri    │ apopovkina │ gsedash      │
└─────────┴────────────┴──────────────┘

--- adding in Names: attempt 1 ---
SELECT A.Site, A.Name AS Name_1, B.Name AS Name_2
    FROM (
    SELECT ca.Site, ca.Start, ca.End, p.Name
        FROM Camp_assignment ca
        JOIN Personnel p1 ON p1.Abbreviation = c.Observer
    ) AS A

SELECT cb.Site, cb.Start, cb.End, p.Name
        FROM Camp_assignment cb
        JOIN Personnel p2 ON p2.Abbreviation = c.Observer

FROM ca JOIN cb USING(Site)
WHERE (ca.Start <= cb.End)  AND  (ca.End >= cb.Start) -- 3500 rows
        AND ca.Site = 'lkri'
        AND ca.Observer < cb.Observer
    ;
------ HW 4 PART 3  ---------------
--  looking at nest data for “nome” between 1998 and 2008 inclusive, 
-- and for which egg age was determined by floating, can you determine 
-- the name of the observer who observed exactly 36 nests?

-- join personnel table to get Name column

SELECT p.Name, COUNT(*) AS Num_floated_nests 
    FROM Bird_nests bn 
    JOIN Personnel p ON p.Abbreviation = bn.Observer
    WHERE bn.Year >= 1998 AND bn.Year <= 2008 
    AND bn.Site = 'nome'
    AND bn.ageMethod = 'float'
    GROUP BY p.Name
    ORDER BY Num_floated_nests DESC
    LIMIT 1
    ;
┌──────────────────┬───────────────────┐
│       Name       │ Num_floated_nests │
│     varchar      │       int64       │
├──────────────────┼───────────────────┤
│ Emilie D'Astrous │                36 │
└──────────────────┴───────────────────┘