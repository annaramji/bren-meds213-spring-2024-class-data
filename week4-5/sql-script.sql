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

