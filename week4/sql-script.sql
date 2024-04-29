-- inserting data
SELECT * FROM Species;

.maxrows 8

INSERT INTO Species VALUES ('abcd', 'thing', 'scientific name', NULL);
SELECT * FROM Species;

-- you can explicitly label the columns
INSERT INTO Species (Common_name, Scientific_name, Code, Relevance)
    VALUES('thing 2', 'another scientific name', 'efgh', NULL);

SELECT * FROM Species;

-- columns can have default values
-- take advantage of default values
INSERT INTO Species (Common_name, Code) VALUES ('thing 3', 'ijkl');
.nullvalue -NULL-
SELECT * FROM Species;

-- being explicit = less fragile
-- INSERT statement and schema definition files might not be easy to access concurrently (?ppl are lazy) so 
-- being explicit is always better 


-- UPDATE and DELETE
UPDATE Species SET Relevance = 'not sure yet' WHERE Relevance IS NULL;
-- like a select statement -- identifying some rows out of that table -- what do you want to do
SELECT * FROM Species;

DELETE FROM Species WHERE Relevance = 'not sure yet';
SELECT * FROM Species;
-- deletes whole rows
-- update and delete statements are dangerous -- can do a lot of damage

-- DELETE FROM Species; -- this line would delete all rows from the Species table. 

-- SAFE delete practice #1
SELECT * FROM Species WHERE Relevance = 'Study species';
-- AFTER confirming, then edit the statement
-- DELETE * FROM Species WHERE Relevance = 'Study species';

-- incomplete statement
-- leave off DELETE then add it after visual confirmation
-- FROM Species WHERE .... -- then add DELETE later

-- write to csv
COPY Species TO 'species_fixed.csv' (HEADER, DELIMITER ','); -- comma separated values
-- instead of table, you could have SELECT, JOIN, etc. statements -- save query in view or save results into csv file

-- CREATE TABLE
CREATE TABLE Snow_cover2 (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Date DATE NOT NULL,
    Plot VARCHAR, -- some Null in the data :/
    Location VARCHAR NOT NULL,
    Snow_cover INTEGER CHECK (Snow_cover > -1 AND Snow_cover < 101),
    Observer VARCHAR
);
SELECT * FROM Snow_cover2;

-- IMPORT data from csv to empty table we just defined
COPY Snow_cover2 FROM 'snow_cover_fixedman_JB.csv' (HEADER TRUE);
SELECT * FROM Snow_cover2;

