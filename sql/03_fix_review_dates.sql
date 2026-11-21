USE olist;

SELECT COUNT(*) FROM order_reviews;

SELECT *
FROM order_reviews
WHERE review_creation_date IS NULL
   OR review_creation_date < '2016-01-01'
   OR review_score IS NULL
   OR review_score NOT BETWEEN 1 AND 5;
   
   USE olist;
SET SQL_SAFE_UPDATES = 0;   -- Workbench blocks updates on tables without a key unless you switch this off

UPDATE order_reviews
SET review_creation_date = NULL,
    review_answer_timestamp = NULL
WHERE review_creation_date < '2016-01-01';

SET SQL_SAFE_UPDATES = 1;   -- turn the protection back on

SELECT COUNT(*) FROM order_reviews WHERE review_creation_date IS NULL;