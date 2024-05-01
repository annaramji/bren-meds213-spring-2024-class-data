-- index order example

SELECT Nest_ID FROM Bird_nests LIMIT 3;

SELECT Nest_ID, floatAge, ageMethod FROM Bird_nests LIMIT 3;
-- these won't necessarily output rows in the same order
-- refers to index if present, however it's stored
-- row index from entire table? 
-- DB stores rows in some order, just reading that order when you're running the second line
-- duckdb query planner different from SQLite -- indicates how diff systems planners differ
-- coincidence, not guaranteed 