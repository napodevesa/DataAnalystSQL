-- Create a route dimension table
CREATE TABLE route(
	route_id INTEGER PRIMARY KEY,
    park_name VARCHAR(160) NOT NULL,
    city_name VARCHAR(160) NOT NULL,
    distance_km float NOT NULL,
    route_name VARCHAR(160) NOT NULL
);
-- Create a week dimension table
CREATE TABLE week(
	week_id INTEGER PRIMARY KEY,
    week integer NOT NULL,
    month varchar(160) NOT NULL,
    year integer NOT NULL
);

----****----****----

SELECT 
	-- Get the total duration of all runs
	SUM(duration_mins)
FROM 
	runs_fact
-- Get all the week_id's that are from July, 2019
INNER JOIN week_dim ON 
runs_fact.week_id = week_dim.week_id
WHERE week_dim.month = 'July' and week_dim.year = '2019';

----****----****----

-- Add the book_id foreign key
ALTER TABLE fact_booksales 
ADD CONSTRAINT sales_book
FOREIGN KEY (book_id) 
REFERENCES dim_book_star (book_id);
    
-- Add the time_id foreign key
ALTER TABLE fact_booksales 
ADD CONSTRAINT sales_time
FOREIGN KEY (time_id) 
REFERENCES dim_time_star (time_id);
    
-- Add the store_id foreign key
ALTER TABLE fact_booksales 
ADD CONSTRAINT sales_store
FOREIGN KEY (store_id) 
REFERENCES dim_store_star (store_id);

----****----****----


-- Create a new table for dim_author with an author column
CREATE TABLE dim_author (
    author varchar(256)  NOT NULL
);

-- Insert authors 
INSERT INTO dim_author
SELECT DISTINCT author FROM dim_book_star;

-- Add a primary key 
ALTER TABLE dim_author 
ADD COLUMN author_id SERIAL PRIMARY KEY;

-- Output the new table
SELECT * FROM dim_author;