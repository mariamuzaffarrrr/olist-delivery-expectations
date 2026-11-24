SELECT order_status, COUNT(*) AS orders
FROM orders
GROUP BY order_status
ORDER BY orders DESC;

SELECT COUNT(*) AS delivered_without_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;
  

CREATE TABLE delivery_reviews AS
SELECT
  o.order_id,
  o.customer_id,
  r.review_score,
  DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS actual_days,
  DATEDIFF(o.order_estimated_delivery_date, o.order_purchase_timestamp) AS promised_days,
  DATEDIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date) AS days_early
FROM orders o
JOIN order_reviews_clean r ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;
  
  
  SELECT COUNT(*) AS total_rows,                 -- Checking for extreme values
       COUNT(DISTINCT order_id) AS distinct_orders,
       MIN(actual_days), MAX(actual_days),
       MIN(promised_days), MAX(promised_days),
       MIN(days_early), MAX(days_early)
FROM delivery_reviews;

SELECT COUNT(*)             -- Checking for impossible values
FROM delivery_reviews      
WHERE actual_days < 0 OR promised_days < 0;
