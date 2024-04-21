-- Active: 1713367857756@@127.0.0.1@3306@airbnb
-- Creating the Host table
CREATE TABLE host (
    host_id BIGINT PRIMARY KEY,
    host_url TEXT,
    host_name TEXT,
    host_location TEXT,
    host_about TEXT,
    host_response_time TEXT,
    host_response_rate NUMERIC(5, 2),
    host_acceptance_rate NUMERIC(5, 2),
    host_is_superhost BOOLEAN,
    host_thumbnail_url TEXT,
    host_picture_url TEXT,
    host_neighbourhood TEXT,
    host_listings_count INT,
    host_total_listings_count INT,
    host_verifications TEXT,  -- or JSONB if you want to use JSON functions
    host_has_profile_pic BOOLEAN,
    host_identity_verified BOOLEAN
);


CREATE TABLE listing (
    id BIGINT PRIMARY KEY,
    name TEXT,
    description TEXT,
    neighborhood_overview TEXT,
    picture_url TEXT,
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    property_type TEXT,
    room_type TEXT,
    accommodates INT,
    bathrooms_text TEXT,
    beds INT,
    amenities TEXT, -- Consider using JSON if you want to store a list of amenities
    price NUMERIC(10, 2),
    minimum_nights INT,
    maximum_nights INT,
    has_availability BOOLEAN,
    availability_30 INT,
    availability_60 INT,
    availability_90 INT,
    availability_365 INT,
    number_of_reviews INT,
    number_of_reviews_ltm INT,
    number_of_reviews_l30d INT,
    reviews_per_month NUMERIC(5, 2)
);

CREATE TABLE location (
    neighbourhood TEXT,
    neighbourhood_cleansed TEXT,
    neighbourhood_group_cleansed TEXT,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    PRIMARY KEY (latitude, longitude) -- Assuming latitude and longitude together are unique for each location
);

-- Creating the Review table
CREATE TABLE review (
    listing_id BIGINT, -- Presuming 'listing_id' is the FK to the 'listing' table
    review_scores_rating NUMERIC(3, 2),
    review_scores_accuracy NUMERIC(3, 2),
    review_scores_cleanliness NUMERIC(3, 2),
    review_scores_checkin NUMERIC(3, 2),
    review_scores_communication NUMERIC(3, 2),
    review_scores_location NUMERIC(3, 2),
    review_scores_value NUMERIC(3, 2),
    first_review DATE,
    last_review DATE,
    FOREIGN KEY (listing_id) REFERENCES listing(id)
);



