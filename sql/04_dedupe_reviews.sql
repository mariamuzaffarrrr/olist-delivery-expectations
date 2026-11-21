SELECT reviews_per_order, COUNT(*) AS orders
FROM (
  SELECT order_id, COUNT(*) AS reviews_per_order
  FROM order_reviews
  GROUP BY order_id
) t
GROUP BY reviews_per_order
ORDER BY reviews_per_order;

SELECT COUNT(*)
FROM orders o
LEFT JOIN order_reviews r ON o.order_id = r.order_id;


USE olist;

CREATE TABLE order_reviews_clean AS
SELECT review_id, order_id, review_score, review_creation_date
FROM (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY order_id
           ORDER BY review_creation_date DESC, review_answer_timestamp DESC, review_id
         ) AS rn
  FROM order_reviews
) t
WHERE rn = 1;

SELECT COUNT(*), COUNT(DISTINCT order_id) FROM order_reviews_clean;