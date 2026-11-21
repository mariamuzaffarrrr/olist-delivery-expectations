# Cleaning Log

Every data-cleaning decision goes here: what I found, what I did, and why.

### order_reviews: malformed row
- **Found:** MySQL gave 3 warnings on load, all on one row (#77917). Its date columns were stored as 0000-00-00.
- **Did:** Set both dates to NULL and kept the row.
- **Why:** Review dates aren't used in this analysis, and the score and order_id looked valid.
- **Impact:** At most one neighboring review affected, about 0.001% of the data.

### orders: load check
- **Found:** 99,441 rows loaded, matching the source file.
- **Did:** Empty date cells were converted to NULL on import.
- **Why:** Orders that were never delivered have no delivery date.