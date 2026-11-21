USE olist;

CREATE TABLE order_reviews (
  review_id CHAR(32),
  order_id CHAR(32),
  review_score TINYINT,
  review_comment_title VARCHAR(255) NULL,
  review_comment_message TEXT NULL,
  review_creation_date DATETIME,
  review_answer_timestamp DATETIME
) CHARACTER SET utf8mb4;


LOAD DATA LOCAL INFILE 'C:/Users/maria/projects/olist-delivery-expectations/data/raw/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
CHARACTER SET utf8mb4                      -- read the file as UTF-8 so accents survive
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'                 -- comments are wrapped in quotes and may contain commas or line breaks
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@review_id, @order_id, @score, @title, @message, @created, @answered)
SET review_id = @review_id,
    order_id = @order_id,
    review_score = @score,
    review_comment_title = NULLIF(@title, ''),       -- blank comments become NULL
    review_comment_message = NULLIF(@message, ''),
    review_creation_date = @created,
    review_answer_timestamp = NULLIF(REPLACE(@answered, '\r', ''), '');