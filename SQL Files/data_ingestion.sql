-- /* In this sql file we are going to upload data from the S3 bucket into a newly created table */ ---
-------------------------------------------------------------------------------------------------------------------------
-- 1 . Table creation for storing all the data from 10 json reviews data files --
-- This table has only one column i.e. "review_text" which is of variant data type for storing json data --

create or replace table yelp_reviews (review_text variant) 

-- Loading data from S3 bucket into our table ---
COPY INTO yelp_reviews 
FROM 's3://sql-projects/yelp-reviews-data-analysis/'
CREDENTIALS = (
     AWS_KEY_ID = 'AKIAXPX4OFZJI6ACXNLS'
     AWS_SECRET_KEY = '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'
)
FILE_FORMAT = (TYPE = JSON) ; 

SELECT * from yelp_reviews LIMIT 100; --- Checking the loaded data ---

-------------------------------------------------------------------------------------------------------------------------

--- 2. Table creation for storing the jason data about businesses ---
-- This table has only one column i.e. "business_text" which is of variant data type for storing json data --

create or replace table yelp_businesses (business_text variant)

-- Loading data from S3 bucket into our table ---
COPY INTO yelp_businesses 
FROM 's3://sql-projects/yelp-reviews-data-analysis/yelp_academic_dataset_business.json'
CREDENTIALS = (
     AWS_KEY_ID = 'AKIAXPX4OFZJI6ACXNLS'
     AWS_SECRET_KEY = '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'
)
FILE_FORMAT = (TYPE = JSON) ;

SELECT * from yelp_businesses LIMIT 100; --- Checking the loaded data ---


