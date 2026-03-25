--/* Here we will be creating a sentiment analysis function for getting better information about the reviews in our yelp reviews data */ -- 
---------------------------------------------------------------------------------------------------------------------------
-- Creating test table as reviews having review as a column and saving some text in that coulmn to test our sentiment analysis function --

create table reviews (review varchar(200));

insert into reviews values ('I love this product;works perfectly');
insert into reviews values ('This product is okay ; but could be better');
insert into reviews values ('I just hate this product ; stpped working after a week');
insert into reviews values ('This product is okay ; not that great');
insert into reviews values ('This product is not good ; but I can use');

SELECT * from reviews;

--Creating Functions for Sentiment Analysis---

--Function1 : This function analyze_sentiment1 returns polarity according to the text's positive or negative tone. --

CREATE or REPLACE FUNCTION analyze_sentiment1(text STRING) 
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION ='3.9'
PACKAGES = ('textblob')
HANDLER = 'sentiment_analyzer1'
AS $$ 
from textblob import TextBlob
def sentiment_analyzer1(text):
    analysis=TextBlob(text)
    return analysis.sentiment.polarity
$$;
--- Testing the function created above ---
SELECT review , analyze_sentiment1(review) from reviews;

-----------------------------------------------------------------------------------------------------------------------------
--Function 2 : This function analyze_sentiment2 returns positive , negative or neutral as per polarity of the text review .--

CREATE or REPLACE FUNCTION analyze_sentiment2(text STRING) 
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION ='3.9'
PACKAGES = ('textblob')
HANDLER = 'sentiment_analyzer2'
AS $$ 
from textblob import TextBlob
def sentiment_analyzer2(text):
    analysis=TextBlob(text)
    if analysis.sentiment.polarity > 0:
        return 'Positive'
    elif analysis.sentiment.polarity == 0:
          return 'Neutral'
    else:
         return 'Negative'
$$; 

--- Testing the function created above ---
SELECT review , analyze_sentiment2(review) from reviews;

