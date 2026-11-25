# Cleaning Log

Every data-cleaning decision goes here: what I found, what I did, and why.

### order_reviews: malformed row
- **Found:** MySQL gave 3 warnings on load, all on one row (#77917). Its date columns were stored as 0000-00-00.
- **Did:** Set both dates to NULL and kept the row.
- **Why:** Review dates aren't used in this analysis, and the score and order_id looked valid.
- **Impact:** At most one neighboring review affected, about 0.001% of the data.

### order_reviews: more than one review per order
- **Found:** 547 orders have more than one review (543 with 2, 4 with 3). A plain LEFT JOIN from orders to order_reviews returned 99,992 rows instead of 99,441, so 551 rows were duplicates.
- **Did:** Created order_reviews_clean, keeping one review per order: the most recent (sql/05_dedupe_reviews.sql). The original table is untouched.
- **Why:** Duplicate rows would double-count orders in every average and percentage. I kept the latest review because it likely reflects the customer's final opinion.
- **Impact:** About 0.6% of reviewed orders. Later I'll test other choices (first review, lowest score) to check the conclusions don't depend on this one.

### orders without a review
- **Found:** 98,672 of the 99,441 orders have a review, so 769 have none.
- **Did:** Nothing yet. These orders can't be used for the review analysis, so they'll be excluded from it but kept in the order funnel.
- **Why:** With no review score, there's nothing to compare against delivery performance.
- **Impact:** About 0.8% of orders. Worth checking later whether they differ from the rest (for example, canceled orders)

### Orders excluded from the delivery analysis
- **Found:** Of 99,441 orders, 96,478 are delivered. The other 2,963 are shipped (1,107), canceled (625), unavailable (609), invoiced (314), processing (301), created (5) or approved (2). 8 of the delivered orders have no delivery date.
- **Did:** Kept only delivered orders with a delivery date (96,470) for the delivery analysis. The other statuses stay in the order funnel.
- **Why:** The gap between promised and actual dates can't be measured without an arrival date. The data is a snapshot, so some shipped orders probably arrived later, but that isn't recorded.
- **Impact:** About 3% of orders excluded. Delivered orders with no review are also dropped from the review analysis: 647 delivered orders have no review.

### Extreme delivery times and delays
- **Found:** The longest delivery took 208 days, and the largest delay was 188 days. 283 orders took over 60 days, and 1,335 were more than 14 days late. No negative durations.
- **Did:** Kept all of them.
- **Why:** They look like real bad experiences, not data errors, and they're part of what this project studies.
- **Impact:** Under 2% of orders. I'll rerun the main test without them to check the conclusions don't depend on them.