--/* Here we are creating tables with necessary columns and data types for analysis from yelp_reviews and yelp_business tables which have data stored as json format */ ---
---------------------------------------------------------------------------------------------------------------------------
--- Table 1 : tbl_yelp_reviews by selecting necessary columns from yelp_reviews table .----
CREATE or REPLACE table tbl_yelp_reviews as 
SELECT review_text:business_id::string as business_id , 
review_text:user_id::string as user_id,
review_text:date::date as review_date,
review_text:stars::number as stars,
review_text:text::string as review_text,
analyze_sentiment2(review_text) as sentiments 
FROM yelp_reviews;

SELECT * from tbl_yelp_reviews LIMIT 10 ;

----------------------------------------------------------------------------------------------------------------------------
--- Table 2 : tbl_yelp_business by selecting necessary columns from yelp_businesses table .----

CREATE or REPLACE table tbl_yelp_business as 
SELECT business_text:business_id::string as business_id , 
business_text:name::string as name,
business_text:city::string as city,
business_text:state::string as state,
business_text:review_count::string as review_text,
business_text:stars::number as stars,
business_text:categories::string as categories
FROM yelp_businesses;

SELECT * from tbl_yelp_business LIMIT 10 ;
