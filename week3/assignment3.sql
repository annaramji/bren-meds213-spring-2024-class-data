------------ PART 1 ----------------------------------
-- Does SQL abort with some kind of error?
-- Does it ignore NULL values?
--  Do the NULL values somehow factor into the calculation, and if so, how?

-- 1: create temp table with column of "REAL"
CREATE TEMP TABLE my_table (
    Real_Nums REAL);


INSERT INTO my_table
VALUES (89), (23), (NULL), (14);

SELECT AVG(Real_Nums) FROM my_table;

-- 42.0 is returned
-- AVG is ignoring the NULL value 
--(dividing the sum of the real numbers by the number of real numbers (3, rather than 4))
-- if the NULL was factored in (as a zero), it would return 31.5 (dividing by 4, rather than 3)


-------------- ASSIGNMENT 3.1 PART 2 --------------------------------
-- SELECT SUM(Real_Nums)/COUNT(*) FROM my_table; 
-- IS WRONG because it is selecting all rows, INCLUSIVE of NULLs. It would return 31.5 rather than 42.0.

-- SELECT SUM(Real_Nums)/COUNT(Real_Nums) FROM my_table;
-- IS CORRECT because it is using the COUNT function to count only the non-NULL values 
-- in the table to perform the operation on, and would return 42.0 (rather than 31.5)

DROP TABLE my_table;


--------------- ASSIGNMENT 3.2 PART 1 --------------

SELECT Site_name, MAX(Area) FROM Site;
-- The above query is not using a GROUP BY operation, so you're giving it an initial column to look at, 
-- then asking it to find the maximum value in an entirely different column (from the same table)
-- without specifying that you want to group by Site_name. It wants to collapse the whole table into a single row,
-- but doesn't know which column(s) to include.

--------------- ASSIGNMENT 3.2 PART 2 --------------
SELECT Site_name, MAX(Area)
    FROM Site
    GROUP BY Site_name
    ORDER BY Max(Area) DESC
    LIMIT 1;

┌──────────────┬───────────┐
│  Site_name   │ max(Area) │
│   varchar    │   float   │
├──────────────┼───────────┤
│ Coats Island │    1239.1 │
└──────────────┴───────────┘

--------------- ASSIGNMENT 3.2 PART 3 --------------
SELECT Site_name, Area 
    FROM Site 
    WHERE Area = (
        SELECT MAX(Area)
            FROM Site);


-------------- ASSIGNMENT 3.3 ---------------------

CREATE TEMP TABLE Averages AS
    SELECT Nest_ID, AVG(((3.14 / 6) * (Width ^ 2) * Length)) AS Avg_volume
        FROM Bird_eggs
        GROUP BY Nest_ID;

-- view output
-- SELECT * from Averages;

-- join with Bird_nests
CREATE TEMP TABLE Bird_species AS
    SELECT Species, MAX(Avg_volume) AS Max_avg_volume -- useful column name
     FROM Bird_nests JOIN Averages USING (Nest_ID)
     GROUP BY Species;

SELECT Scientific_name, Max_avg_volume
    FROM Bird_species bs -- shorthand for specifying columns later
    JOIN Species s 
    ON s.Code = bs.Species
    ORDER BY Max_avg_volume DESC;

┌─────────────────────────┬────────────────────┐
│     Scientific_name     │   Max_avg_volume   │
│         varchar         │       double       │
├─────────────────────────┼────────────────────┤
│ Pluvialis squatarola    │ 36541.850248882525 │
│ Pluvialis dominica      │  33847.85405259203 │
│ Arenaria interpres      │  23338.62131580269 │
│ Calidris fuscicollis    │ 13277.142899082943 │
│ Calidris alpina         │ 12196.237301294967 │
│ Charadrius semipalmatus │ 11266.974320139941 │
│ Phalaropus fulicarius   │  8906.775061603003 │
└─────────────────────────┴────────────────────┘


------ trying to do the above steps in one call ---------
SELECT s.Scientific_name, MAX(avg_volume) AS Max_avg_volume
FROM (
  SELECT Nest_ID, AVG(((3.14 / 6) * (Width ^ 2) * Length)) AS avg_volume
  FROM Bird_eggs
  GROUP BY Nest_ID
) AS Averages
JOIN Bird_nests bn ON Averages.Nest_ID = bn.Nest_ID
JOIN Species s ON bn.Species = s.Code
GROUP BY s.Scientific_name
ORDER BY Max_avg_volume DESC;
-- it worked!