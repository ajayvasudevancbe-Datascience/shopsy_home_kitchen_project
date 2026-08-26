-- Shopsy Home & Kitchen Analysis
-- Run after the shopsy_db.products table has been created and loaded.

USE shopsy_db;

-- 1. Top products by review count
SELECT product_name, brand, price, rating, reviews
FROM products
WHERE reviews IS NOT NULL
ORDER BY reviews DESC
LIMIT 10;

-- 2. Top-rated products
SELECT product_name, brand, price, rating, reviews
FROM products
WHERE rating IS NOT NULL
  AND reviews IS NOT NULL
ORDER BY rating DESC, reviews DESC
LIMIT 10;

-- 3. Brand performance
SELECT brand,
       COUNT(*) AS product_count,
       ROUND(AVG(price), 2) AS average_price,
       ROUND(AVG(rating), 2) AS average_rating,
       COALESCE(SUM(reviews), 0) AS total_reviews
FROM products
WHERE brand IS NOT NULL
GROUP BY brand
ORDER BY total_reviews DESC
LIMIT 10;

-- 4. Discount summary
SELECT ROUND(AVG(discount), 2) AS average_discount,
       MAX(discount) AS highest_discount,
       MIN(discount) AS lowest_discount,
       COUNT(*) AS products_with_discount
FROM products
WHERE discount IS NOT NULL;

-- 5. Price by brand
SELECT brand,
       COUNT(*) AS product_count,
       ROUND(MIN(price), 2) AS minimum_price,
       ROUND(AVG(price), 2) AS average_price,
       ROUND(MAX(price), 2) AS maximum_price
FROM products
WHERE brand IS NOT NULL
  AND price IS NOT NULL
GROUP BY brand
ORDER BY average_price DESC
LIMIT 10;

-- 6. Material distribution
SELECT material,
       COUNT(*) AS product_count,
       ROUND(AVG(price), 2) AS average_price
FROM products
WHERE material IS NOT NULL
GROUP BY material
ORDER BY product_count DESC, average_price DESC
LIMIT 10;

-- 7. Discount and rating analysis
SELECT discount,
       COUNT(*) AS product_count,
       ROUND(AVG(rating), 2) AS average_rating,
       ROUND(AVG(reviews), 2) AS average_reviews
FROM products
WHERE discount IS NOT NULL
GROUP BY discount
ORDER BY discount;

-- 8. Review coverage
SELECT COUNT(*) AS total_products,
       SUM(CASE WHEN reviews IS NOT NULL THEN 1 ELSE 0 END) AS products_with_reviews,
       SUM(CASE WHEN reviews IS NULL THEN 1 ELSE 0 END) AS products_without_reviews,
       ROUND(100 * AVG(CASE WHEN reviews IS NOT NULL THEN 1 ELSE 0 END), 2) AS review_coverage_percent
FROM products;

-- 9. Price bands
SELECT CASE
           WHEN price < 200 THEN 'Under 200'
           WHEN price < 400 THEN '200 to 399'
           ELSE '400 and above'
       END AS price_band,
       COUNT(*) AS product_count,
       ROUND(AVG(rating), 2) AS average_rating,
       COALESCE(SUM(reviews), 0) AS total_reviews
FROM products
WHERE price IS NOT NULL
GROUP BY price_band
ORDER BY MIN(price);

-- 10. High-value products by engagement
SELECT product_name, brand, price, discount, rating, reviews,
       ROUND(rating * LOG10(COALESCE(reviews, 0) + 1), 2) AS engagement_score
FROM products
WHERE rating >= 4
  AND price IS NOT NULL
ORDER BY engagement_score DESC, discount DESC
LIMIT 10;
