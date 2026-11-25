-- How long did orders take, and how did reviews look?
SELECT
  CASE
    WHEN actual_days <= 7  THEN '1. 0-7 days'
    WHEN actual_days <= 14 THEN '2. 8-14 days'
    WHEN actual_days <= 21 THEN '3. 15-21 days'
    WHEN actual_days <= 30 THEN '4. 22-30 days'
    WHEN actual_days <= 60 THEN '5. 31-60 days'
    ELSE '6. 61+ days'
  END AS actual_days_band,
  COUNT(*) AS orders,
  ROUND(AVG(review_score), 2) AS avg_review
FROM delivery_reviews
GROUP BY actual_days_band
ORDER BY actual_days_band;

-- How early or late were orders compared to the promise?
SELECT
  CASE
    WHEN days_early < -14 THEN '1. more than 14 days late'
    WHEN days_early < 0   THEN '2. 1-14 days late'
    WHEN days_early <= 7  THEN '3. on time to 7 days early'
    WHEN days_early <= 14 THEN '4. 8-14 days early'
    ELSE '5. more than 14 days early'
  END AS gap_band,
  COUNT(*) AS orders,
  ROUND(AVG(review_score), 2) AS avg_review
FROM delivery_reviews
GROUP BY gap_band
ORDER BY gap_band;