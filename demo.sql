-- Active: 1713367857756@@127.0.0.1@3306@airbnb
USE airbnb;


-- Select all data from the table
SELECT * FROM airbnb.host;

#Sample query for WHERE
-- Select all columns where host_is_superhost is true
SELECT * FROM airbnb.host WHERE host_is_superhost = 1;

#Sample query for Inner JOIN and ORDER BY
# Select listing name, price, property type where review_scores_rating in review table 
# is greater than 4.8, order by price in descending order.
SELECT 
    l.name, 
    l.price, 
    l.property_type
FROM airbnb.listing l
JOIN airbnb.review r 
    ON l.id = r.listing_id
WHERE r.review_scores_rating > 4.8
ORDER BY l.price DESC;

#Sample query for AND, OR, NOT
# Select listing name, price, property type where review_scores_rating in review table
# is greater than 4.8 and price is less than 100 or property type is house.
SELECT 
    l.name, 
    l.price, 
    l.property_type
FROM airbnb.listing l
JOIN airbnb.review r 
    ON l.id = r.listing_id
WHERE (r.review_scores_rating > 4.8 AND l.price < 200) OR l.property_type = 'House';

#Sample query for IN or NOT IN
# Slect host location, host acceptance rate, host response rate where location is in 
# Washington DC, Arlington VA, Alexandria VA
SELECT 
    host_location, 
    host_acceptance_rate, 
    host_response_rate
FROM airbnb.host
WHERE host_location IN ('Washington, DC', 'Arlington, VA', 'Alexandria, VA');

#Sample query for LIKE
#Select host id, name, about from host where host name ends with y.
SELECT host_id, host_name, host_about
FROM airbnb.host
WHERE host_name LIKE '%y';


# Sample query for join with 3 tables
# Select listing name, listing price, property type from listing, review score rating from 
# review, and host location from host, where review score rating is greater than 4.8 and host 
# location is in Washington DC, Arlington VA, Alexandria VA
SELECT 
    l.name, 
    l.price, 
    l.property_type,
    r.review_scores_rating,
    h.host_location
FROM airbnb.listing l
JOIN airbnb.review r 
    ON l.id = r.listing_id
JOIN airbnb.host h
    ON l.host_id = h.host_id
WHERE r.review_scores_rating > 4.8 AND h.host_location IN ('Washington, DC', 'Arlington, VA', 'Alexandria, VA');


#Sample query for join with 2 conditions
# Select neighbourhood, latitude, longitude from location and name, price, property type 
# from listing where property type is 'Entire home' and price is less than 100. Order by 
# price in descending order.
SELECT 
    loc.neighbourhood, 
    loc.latitude, 
    loc.longitude,
    l.name, 
    l.price, 
    l.property_type
FROM airbnb.location loc
JOIN airbnb.listing l 
    ON loc.latitude = l.latitude 
    AND loc.longitude = l.longitude
WHERE l.property_type = 'Entire home' AND l.price < 100
ORDER BY l.price DESC;


#Sample query for right outer join
# Select listing name, listing price, property type from listing and review score rating from
# review where listing id is equal to review listing id.
SELECT 
    l.name, 
    l.price, 
    l.property_type,
    r.review_scores_rating
FROM airbnb.listing l
RIGHT JOIN airbnb.review r 
    ON l.id = r.listing_id;

#Sample query for left outer join
# Select listing name, listing price, property type from listing and review score rating from
# review where listing id is equal to review listing id.
SELECT 
    l.name, 
    l.price, 
    l.property_type,
    r.review_scores_rating
FROM airbnb.listing l
LEFT JOIN airbnb.review r 
    ON l.id = r.listing_id;

#Sample query for Insert
# Insert a new row into the host table with host id 100, host name 'John', host location 'Washington, DC',
# host about 'I am a host', host response rate 100, host acceptance rate 100, host is superhost 1.
INSERT INTO airbnb.host (host_id, host_name, host_location, host_about, host_response_rate, host_acceptance_rate, host_is_superhost)
VALUES (100, 'John', 'Washington, DC', 'I am a host', 100, 100, 1);
#Remove a row from the host table where host id is 100.
DELETE FROM airbnb.host WHERE host_id = 100;

#Sample query for Update
# Update host location to 'New York, NY' where host id is 4492.
UPDATE airbnb.host
SET host_location = 'New York, NY'
WHERE host_id = 4492;

#Sample query for Updating multiple rows
#Update host_is_superhost to 1 where host_location is Washington, DC.
UPDATE airbnb.host
SET host_is_superhost = 1
WHERE host_location = 'Washington, DC';

# Sample query for Subquery and SET
# Update price to 10% of price where neighbourhood in location table is LIKE Washington.
UPDATE airbnb.listing AS l
JOIN airbnb.location AS loc
    ON l.latitude = loc.latitude AND l.longitude = loc.longitude
SET l.price = l.price * 0.1
WHERE loc.neighbourhood LIKE '%Washington%';

    
# Sample query for delete rows
# Delete rows from host table where host location is Washington, DC.
DELETE FROM airbnb.host WHERE host_location = 'Washington, DC';

# Sample query for Group By
# Select neighbourhood, count of neighbourhood from location table.
SELECT neighbourhood, COUNT(neighbourhood) AS count
FROM airbnb.location
GROUP BY neighbourhood;

# Sample query for Group by and Having
# Select host location, count of host location from host table where count of host 
# location is greater than 1.
SELECT host_location, COUNT(host_location) AS count
FROM airbnb.host
GROUP BY host_location
HAVING COUNT(host_location) > 1;

#Sample query for View
# Create a view called 'listing_view' that contains listing id, name, price, property type 
# from listing table.
CREATE VIEW listing_view 
AS SELECT id, name, price, property_type
FROM airbnb.listing
WHERE price < 100
WITH CHECK OPTION;
#Drop the view
DROP VIEW listing_view;
#Look at the view
SELECT * FROM listing_view;
# Update price to 150 for listing with id 3686
UPDATE listing_view SET price = 150
WHERE id = 3686;

# Create sample tables to test for constraints
#Create a table called sample listing that contains id, price, property type
CREATE TABLE sample_listing (
    id BIGINT,
    price DECIMAL(10, 2),
    property_type VARCHAR(255),
    PRIMARY KEY (id)
);
CREATE TABLE customer_reservation (
    customer_id INT,
    listing_id BIGINT,
    name VARCHAR(255),
    date DATE,
    property_type VARCHAR(255),
    PRIMARY KEY (customer_id),
    FOREIGN KEY (listing_id) REFERENCES airbnb.sample_listing(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
#Insert data into sample listing table
INSERT INTO sample_listing (id, price, property_type)
VALUES (3686, 100, 'Private room in home'),
       (3943, 150, 'Private room in townhouse'),
       (4197, 200, 'Private room in home'),
       (4529, 250, 'Private room in home'),
       (4967, 300, 'Private room in home');
#Insert data into customer reservation table
INSERT INTO customer_reservation (customer_id, listing_id, name, date, property_type)
VALUES (1, 3686, 'John', '2024-01-01', 'Private room in home'),
       (2, 3943, 'Jane', '2024-01-02', 'Private room in townhouse'),
       (3, 4197, 'Jack', '2024-01-03', 'Private room in home'),
       (4, 4529, 'Jill', '2024-01-04', 'Private room in home'),
       (5, 4967, 'Joe', '2024-01-05', 'Private room in home');
#Test CASCADE constraints
UPDATE airbnb.sample_listing SET id = 9000 WHERE id = 3943;
SELECT * FROM customer_reservation WHERE customer_id = 2;
#Should see the row with customer_id 2 now have listing_id 9000
#Test SET NULL constraints
DELETE FROM airbnb.sample_listing WHERE id = 3686;
SELECT * FROM customer_reservation WHERE customer_id = 1;
#Should see the row with customer_id 1 now have listing_id NULL


#Create Index
CREATE INDEX idx_host_location ON host (host_location(100));
SELECT * FROM host WHERE host_location = 'Washington, DC';
#Drop Index
ALTER TABLE host DROP INDEX idx_host_location;





