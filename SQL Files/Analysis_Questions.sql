-- /* Analysis of Yelp reviews and businesses data through some important business questions .*/ ---
----------------------------------------------------------------------------------------------------------------------------

--- Q1. Find the number of businesses in each category ---
SELECT * from tbl_yelp_business LIMIT 10;
-- here we have used the function called lateral split_to_table to separate the different categories present in single column---
WITH CTE1 as (
SELECT business_id , trim(A.value) as category from tbl_yelp_business,
lateral split_to_table(categories,',') A
)
SELECT category , count(*) as number_of_businesses from CTE1 GROUP BY 1 ORDER BY 2 DESC;

--------------------------------------------------------------------------------------------------------------------------
--- Q2. Find the top 10 users who have reviewed the most businesses in 'restaurant' category ----

SELECT * from tbl_yelp_reviews LIMIT 10;
SELECT r.user_id , COUNT(DISTINCT r.business_id)
from tbl_yelp_reviews  r inner join  tbl_yelp_business  b 
on r.business_id=b.business_id
where b.categories ilike '%restaurant%'     --'ilke' is used for getting rid of case sensitive issue--
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--------------------------------------------------------------------------------------------------------------------------
--- Q3. Find the most Popular categories of businesses (based on number of reviews)---

WITH CTE1 as (
SELECT business_id , trim(A.value) as category from tbl_yelp_business,
lateral split_to_table(categories,',') A
)
SELECT category , COUNT(*) as no_of_reviews
from CTE1 
inner join tbl_yelp_reviews r on CTE1.business_id=r.business_id
GROUP BY 1
ORDER BY 2 DESC;

---------------------------------------------------------------------------------------------------------------------------
--- Q4. Find top 3 most recent reviews of  each business ---
With cte as (
SELECT r.*,b.name , 
row_number() over (partition by r.business_id order by r.review_date desc) as rn
from tbl_yelp_reviews  r inner join  tbl_yelp_business  b 
on r.business_id=b.business_id ) 
SELECT * from cte where rn<=3;

--------------------------------------------------------------------------------------------------------------------------
--- Q5. Find the month with highest number of reviews ---

SELECT EXTRACT(month from review_Date) as months
, count(*) as no_of_reviews from tbl_yelp_reviews 
group by 1 order by 2 desc ;

-------------------------------------------------------------------------------------------------------------------------
--- Q6. Find the percentage of 5 star reviews for each business .

SELECT b.name , r.business_id , COUNT(*) as total_reviews ,
SUM(CASE when r.stars=5 then 1 else 0 end ) as stars5_reviews,
ROUND((stars5_reviews/total_reviews)*100,2) as percentage_5_stars
from tbl_yelp_reviews r
inner join  tbl_yelp_business  b  on r.business_id=b.business_id
GROUP BY 1,2
ORDER BY 3 DESC ;

--------------------------------------------------------------------------------------------------------------------------
--- Q7. Find the top 5 most reviewed business in each city.
SELECT * from tbl_yelp_business LIMIT 10;
--solution with first method --
WITH cte1 as (
SELECT b.city ,b.business_id,b.name,  COUNT(*) as total_reviews ,
from tbl_yelp_reviews r
inner join  tbl_yelp_business  b  on r.business_id=b.business_id
GROUP BY 1,2,3 ),
cte2 as (
SELECT * , row_number() over (partition by city order by total_reviews desc)  as rn
from cte1) 
SELECT * from cte2 where rn<=5;

-- solution with second method using "qualify" function ---
WITH cte1 as (
SELECT b.city ,b.business_id,b.name,  COUNT(*) as total_reviews ,
from tbl_yelp_reviews r
inner join  tbl_yelp_business  b  on r.business_id=b.business_id
GROUP BY 1,2,3 )
SELECT * from cte1 qualify row_number() over (partition by city order by total_reviews desc)<=5 ;

--------------------------------------------------------------------------------------------------------------------------
--- Q8. Find the average rating of the businesses that have atleast 100 reviews---
SELECT b.business_id,b.name,  COUNT(*) as total_reviews , AVG (r.stars)
from tbl_yelp_reviews r
inner join  tbl_yelp_business  b  on r.business_id=b.business_id
GROUP BY 1,2 
HAVING total_reviews >=100
Order by 3 desc ;

---------------------------------------------------------------------------------------------------------------------------
--- Q9. List the top 10 users who have written the most reviews , along with business they reviewed ---
with cte as (
SELECT r.user_id , COUNT(*) as total_reviews ,
from tbl_yelp_reviews r
GROUP BY 1 
order by 2 desc
LIMIT 10)
SELECT user_id , business_id from tbl_yelp_reviews where user_id in (SELECT user_id from cte)
group by 1,2
order by 1 ;

---------------------------------------------------------------------------------------------------------------------------
--- Q10. Find top 10 businesses with highest positive sentiment reviews ---

SELECT b.business_id,b.name,  COUNT(*) as total_reviews 
from tbl_yelp_reviews r
inner join  tbl_yelp_business  b  on r.business_id=b.business_id
where r.sentiments='Positive'
GROUP BY 1,2 
Order by 3 desc
LIMIT 10 ; 

