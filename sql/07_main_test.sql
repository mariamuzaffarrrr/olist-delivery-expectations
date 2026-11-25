SELECT
  CASE
    WHEN actual_days <= 7  THEN '1. 0-7 days'
    WHEN actual_days <= 14 THEN '2. 8-14 days'
    WHEN actual_days <= 21 THEN '3. 15-21 days'
    WHEN actual_days <= 30 THEN '4. 22-30 days'
    ELSE '5. 31+ days'
  END AS actual_days_band,
  CASE WHEN days_early < 0 THEN 'late' ELSE 'on time or early' END AS vs_promise,
  COUNT(*) AS orders,
  ROUND(AVG(review_score), 2) AS avg_review
FROM delivery_reviews
GROUP BY actual_days_band, vs_promise
ORDER BY actual_days_band, vs_promise;