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
-- If this were the first egg measurement for this particular nest, immediately after the insert we would see:

.nullvalue -NULL-
SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';