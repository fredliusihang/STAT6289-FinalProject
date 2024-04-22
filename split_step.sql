DROP TABLE IF EXISTS `listings` ;
CREATE TABLE `listings`  (
  `id` varchar(255) NULL,
  `listing_url` text NULL,
  `scrape_id` varchar(255) NULL,
  `last_scraped` varchar(255) NULL,
  `source` varchar(255) NULL,
  `name` varchar(255) NULL,
  `description` varchar(255) NULL,
  `neighborhood_overview` text NULL,
  `picture_url` varchar(255) NULL,
  `host_id` varchar(255) NULL,
  `host_url` varchar(255) NULL,
  `host_name` varchar(255) NULL,
  `host_location` varchar(255) NULL,
  `host_about` text NULL,
  `host_response_time` varchar(255) NULL,
  `host_response_rate` varchar(255) NULL,
  `host_acceptance_rate` varchar(255) NULL,
  `host_is_superhost` varchar(255) NULL,
  `host_thumbnail_url` text NULL,
  `host_picture_url` text NULL,
  `host_neighbourhood` varchar(255) NULL,
  `host_listings_count` varchar(255) NULL,
  `host_verifications` varchar(255) NULL,
  `host_has_profile_pic` varchar(255) NULL,
  `host_identity_verified` varchar(255) NULL,
  `neighbourhood` text NULL,
  `neighbourhood_cleansed` text NULL,
  `neighbourhood_group_cleansed` text NULL,
  `latitude` varchar(255) NULL,
  `longitude` varchar(255) NULL,
  `property_type` varchar(255) NULL,
  `room_type` varchar(255) NULL,
  `accommodates` varchar(255) NULL,
  `bathrooms_text` varchar(255) NULL,
  `beds` varchar(255) NULL,
  `amenities` varchar(255) NULL,
  `price` varchar(255) NULL,
  `minimum_nights` varchar(255) NULL,
  `maximum_nights` varchar(255) NULL,
  `minimum_minimum_nights` varchar(255) NULL,
  `maximum_minimum_nights` varchar(255) NULL,
  `minimum_maximum_nights` varchar(255) NULL,
  `maximum_maximum_nights` varchar(255) NULL,
  `minimum_nights_avg_ntm` varchar(255) NULL,
  `maximum_nights_avg_ntm` varchar(255) NULL,
  `calendar_updated` varchar(255) NULL,
  `has_availability` varchar(255) NULL,
  `availability_30` varchar(255) NULL,
  `availability_60` varchar(255) NULL,
  `availability_90` varchar(255) NULL,
  `availability_365` varchar(255) NULL,
  `calendar_last_scraped` varchar(255) NULL,
  `number_of_reviews` varchar(255) NULL,
  `number_of_reviews_ltm` varchar(255) NULL,
  `number_of_reviews_l30d` varchar(255) NULL,
  `first_review` varchar(255) NULL,
  `last_review` varchar(255) NULL,
  `review_scores_rating` varchar(255) NULL,
  `review_scores_accuracy` varchar(255) NULL,
  `review_scores_cleanliness` varchar(255) NULL,
  `review_scores_checkin` varchar(255) NULL,
  `review_scores_communication` varchar(255) NULL,
  `review_scores_location` text NULL,
  `review_scores_value` varchar(255) NULL,
  `license` text NULL,
  `instant_bookable` varchar(255) NULL,
  `calculated_host_listings_count` varchar(255) NULL,
  `calculated_host_listings_count_entire_homes` varchar(255) NULL,
  `calculated_host_listings_count_private_rooms` varchar(255) NULL,
  `calculated_host_listings_count_shared_rooms` varchar(255) NULL,
  `reviews_per_month` varchar(255) NULL
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/listings.csv'
INTO TABLE listings
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;




-- host split step:
INSERT INTO `host` (
    host_id,
    host_url,
    host_name,
    host_location,
    host_about,
    host_response_time,
    host_response_rate,
    host_acceptance_rate,
    host_is_superhost,
    host_thumbnail_url,
    host_picture_url,
    host_neighbourhood,
    host_listings_count,
    host_verifications,
    host_has_profile_pic,
    host_identity_verified
)
SELECT
    DISTINCT 
    CAST(host_id AS UNSIGNED) AS host_id,
    host_url,
    host_name,
    host_location,
    host_about,
    host_response_time,
    CASE
        WHEN host_response_rate = 'N/A' OR host_response_rate = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(host_response_rate, '%', ''), ',', '') AS DECIMAL(5,2))
    END AS host_response_rate,
    CASE
        WHEN host_acceptance_rate = 'N/A' OR host_acceptance_rate = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(host_acceptance_rate, '%', ''), ',', '') AS DECIMAL(5,2))
    END AS host_acceptance_rate,
		CASE
        WHEN host_is_superhost = 't' THEN 1
        WHEN host_is_superhost = 'f' THEN 0
        ELSE NULL 
    END AS host_is_superhost,
    host_thumbnail_url,
    host_picture_url,
    host_neighbourhood,
    CAST(host_listings_count AS UNSIGNED) AS host_listings_count,
    host_verifications,
		CASE
        WHEN host_has_profile_pic = 't' THEN 1
        WHEN host_has_profile_pic = 'f' THEN 0
        ELSE NULL 
    END AS host_has_profile_pic,
	  CASE
        WHEN host_identity_verified = 't' THEN 1
        WHEN host_identity_verified = 'f' THEN 0
        ELSE NULL 
    END AS host_identity_verified
FROM listings;




-- location split step
INSERT INTO `location`(
   neighbourhood,
    neighbourhood_cleansed,
    neighbourhood_group_cleansed,
    latitude,
    longitude
)
SELECT
        neighbourhood,
    neighbourhood_cleansed,
    neighbourhood_group_cleansed,
    latitude,
    longitude
FROM(
SELECT
        DISTINCT
    neighbourhood,
    neighbourhood_cleansed,
    neighbourhood_group_cleansed,
    CAST(latitude AS DECIMAL(9,6))AS latitude,
    CAST(longitude AS DECIMAL(9,6))AS longitude,
        RANK()OVER(PARTITION BY latitude,longitude ORDER BY neighbourhood DESC)ranking
FROM listings
)A 
WHERE ranking=1;


-- listing split step
INSERT INTO listing(
    id,
    name,
    description,
    neighborhood_overview,
    picture_url,
    latitude,
    longitude,
    property_type,
    room_type,
    accommodates,
    bathrooms_text,
    amenities,
    price,
    minimum_nights,
    maximum_nights,
    has_availability,
    availability_30,
    availability_60,
    availability_90,
    availability_365,
    number_of_reviews,
    number_of_reviews_ltm,
    number_of_reviews_l30d
)
SELECT
		DISTINCT 
    id,
    name,
    description,
    neighborhood_overview,
    picture_url,
    CAST(latitude AS DECIMAL(9,6)) AS latitude,
    CAST(longitude AS DECIMAL(9,6)) AS longitude,
    property_type,
    room_type,
    CAST(accommodates AS UNSIGNED) AS accommodates,
    bathrooms_text,
    amenities,
    case when price='' then null else CAST(REPLACE(price,'$','')AS DECIMAL(10,2)) end AS price,
    CAST(minimum_nights AS UNSIGNED) AS minimum_nights,
    CAST(maximum_nights AS UNSIGNED) AS maximum_nights,
        CASE
        WHEN has_availability = 't' THEN 1
        WHEN has_availability = 'f' THEN 0
        ELSE NULL 
    END AS has_availability,
    CAST(availability_30 AS UNSIGNED) AS availability_30,
    CAST(availability_60 AS UNSIGNED) AS availability_60,
    CAST(availability_90 AS UNSIGNED) AS availability_90,
    CAST(availability_365 AS UNSIGNED) AS availability_365,
    CAST(number_of_reviews AS UNSIGNED) AS number_of_reviews,
    CAST(number_of_reviews_ltm AS UNSIGNED) AS number_of_reviews_ltm,
    CAST(number_of_reviews_l30d AS UNSIGNED) AS number_of_reviews_l30d
    
FROM (
 SELECT *,  RANK()OVER(PARTITION BY id ORDER BY name DESC,neighborhood_overview DESC,latitude ASC,longitude ASC,property_type DESC,room_type ASC,beds DESC, bathrooms_text DESC,price ASC,
        minimum_nights DESC,maximum_nights DESC,availability_30 DESC,availability_60 DESC,availability_90 DESC,
        number_of_reviews DESC,number_of_reviews_ltm DESC,number_of_reviews_l30d DESC,reviews_per_month DESC
        )AS ranking FROM listings
)A 
WHERE ranking=1;






-- review split step

-- review split step
INSERT INTO `review` (
    listing_id,
    review_scores_rating,
    review_scores_accuracy,
    review_scores_cleanliness,
    review_scores_checkin,
    review_scores_communication,
    review_scores_location,
    review_scores_value,
    first_review,
    last_review
)
SELECT
    id AS listing_id,
    CAST(COALESCE(NULLIF(review_scores_rating, ''), '0') AS DECIMAL(3,2)) AS review_scores_rating,
    CAST(COALESCE(NULLIF(review_scores_accuracy, ''), '0') AS DECIMAL(3,2)) AS review_scores_accuracy,
    CAST(COALESCE(NULLIF(review_scores_cleanliness, ''), '0') AS DECIMAL(3,2)) AS review_scores_cleanliness,
    CAST(COALESCE(NULLIF(review_scores_checkin, ''), '0') AS DECIMAL(3,2)) AS review_scores_checkin,
    CAST(COALESCE(NULLIF(review_scores_communication, ''), '0') AS DECIMAL(3,2)) AS review_scores_communication,
    CAST(COALESCE(NULLIF(review_scores_location, ''), '0') AS DECIMAL(3,2)) AS review_scores_location,
    CAST(COALESCE(NULLIF(review_scores_value, ''), '0') AS DECIMAL(3,2)) AS review_scores_value,
    STR_TO_DATE(COALESCE(NULLIF(first_review, ''), '01/01/1970'), '%m/%d/%Y') AS first_review,
    STR_TO_DATE(COALESCE(NULLIF(last_review, ''), '01/01/1970'), '%m/%d/%Y') AS last_review
FROM listings;






