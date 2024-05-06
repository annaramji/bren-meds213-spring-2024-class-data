SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';
.nullvalue -NULL-

CREATE TRIGGER egg_filler
    AFTER INSERT ON Bird_eggs
    FOR EACH ROW
    BEGIN
        UPDATE Bird_eggs
        SET Egg_num = (
            -- return the maximum non-null value, vs greater than 0, then add 1
            SELECT
                CASE
                        WHEN MAX(Egg_num) IS NULL THEN 1
                        ELSE MAX(Egg_num) + 1
                    END
            FROM Bird_eggs
            WHERE Nest_ID = new.Nest_ID 
        )
        WHERE Nest_ID = new.Nest_ID 
            AND Egg_num IS NULL; 
    END;


INSERT INTO Bird_eggs
    (Book_page, Year, Site, Nest_ID, Length, Width)
    VALUES ('b14.6', 2014, 'eaba', '14eabaage01', 12.34, 56.78);

INSERT INTO Bird_eggs
    (Book_page, Year, Site, Nest_ID, Length, Width)
    VALUES ('b14.6', 2014, 'eaba', '14eabaage01', 12.44, 56.78);
-- If this were the first egg measurement for this particular nest, immediately after the insert we would see:

.nullvalue -NULL-
SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';

--DELETE: being safe by using a select statement first
SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01' AND Egg_num = 5;

-- DELETE
-- DELETE FROM Bird_eggs WHERE Nest_ID = '14eabaage01' AND Egg_num = 5;


-- not_in
 bash query_timer.sh not_in 1000 'SELECT Code
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);' \
     database.db timings.csv

-- outer
bash query_timer.sh outer 1000 'SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Nest_ID IS NULL;' \
    database.db timings.csv

-- except
bash query_timer.sh except 1000 'SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests;' \
    database.db timings.csv
