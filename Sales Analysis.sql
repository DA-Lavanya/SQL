SALES ANALYSIS:

1.Table: sales(sale_id, product_id, sale_date, quantity) 
Table: products(product_id, category, price)

Business Ask: Find the top-selling product per category in the last 30 days, based on total revenue (price × quantity).
Answer:
WITH revenue_cte AS (
    SELECT 
        p.category,
        s.product_id,
        SUM(p.price * s.quantity) AS total_revenue
    FROM sales s
    LEFT JOIN products p ON s.product_id = p.product_id
    WHERE s.sale_date >= CURRENT_DATE - INTERVAL '30 DAY'
    GROUP BY p.category, s.product_id
),
top_selling AS (
    SELECT 
        category,
        product_id,
        total_revenue,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rnk
    FROM revenue_cte
)
SELECT 
    category,
    product_id,
    total_revenue
FROM top_selling
WHERE rnk = 1;


2.Table: orders(order_id, customer_id, order_date) 
Table: order_items(order_id, product_id, quantity) 
Table: products(product_id, price)

Business Ask: Find the top 3 customers who spent the most money in the last 60 days.

Answer:
WITH Total_Spending AS (
  SELECT 
    o.customer_id,
    SUM(oi.quantity * p.price) AS Total_spent
  FROM orders o
  INNER JOIN order_items oi ON o.order_id = oi.order_id
  INNER JOIN products p ON p.product_id = oi.product_id
  WHERE o.order_date >= CURRENT_DATE - INTERVAL '60 DAY'
  GROUP BY o.customer_id
),
CTE AS (
  SELECT 
    customer_id,
    Total_spent,
    ROW_NUMBER() OVER (ORDER BY Total_spent DESC) AS rnk
  FROM Total_Spending
)
SELECT customer_id, Total_spent
FROM CTE
WHERE rnk <= 3;

3.Problem Statement: From your sales data, identify:

Customers who placed only one order in the last 6 months (one-time buyers)
Customers who placed more than one order (repeat buyers)
Compare their average spend per order and total revenue contribution.

Tables Involved:
orders(order_id, customer_id, order_date)
order_items(order_id, product_id, quantity)
products(product_id, price)

Answer:
WITH Total_Orders AS (
  SELECT 
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    SUM(oi.quantity * p.price) AS total_spent
  FROM orders o
  INNER JOIN order_items oi ON o.order_id = oi.order_id
  INNER JOIN products p ON p.product_id = oi.product_id
  WHERE o.order_date >= CURRENT_DATE - INTERVAL '180 days'
  GROUP BY o.customer_id
)
SELECT 
  customer_id,
  CASE 
    WHEN number_of_orders = 1 THEN 'One-Time Buyer'
    WHEN number_of_orders > 1 THEN 'Repeat Buyer'
    ELSE 'NONE'
  END AS buyer_type,
  number_of_orders,
  total_spent,
  ROUND(total_spent / number_of_orders, 2) AS avg_spend_per_order
FROM Total_Orders;


4.Problem Statement: Identify customers who made more than one purchase in the last 90 days, and calculate the average gap in days between their purchases.

Tables Involved:
customers(customer_id, name)

sales(sale_id, customer_id, sale_date)

Answer:
WITH recent_sales AS (
    SELECT 
        s.customer_id,
        c.name,
        s.sale_date
    FROM sales s
    JOIN customers c ON s.customer_id = c.customer_id
    WHERE s.sale_date >= CURRENT_DATE - INTERVAL '90 days'
),
ranked_sales AS (
    SELECT 
        customer_id,
        name,
        sale_date,
        LAG(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date) AS prev_sale_date
    FROM recent_sales
),
gaps AS (
    SELECT 
        customer_id,
        name,
        EXTRACT(DAY FROM sale_date - prev_sale_date) AS gap_days
    FROM ranked_sales
    WHERE prev_sale_date IS NOT NULL
)
SELECT 
    customer_id,
    name,
    ROUND(AVG(gap_days), 2) AS avg_days_between_purchases
FROM gaps
GROUP BY customer_id, name
HAVING COUNT(*) >= 1;

5.Problem Statement: You’re working with a table called product_prices(product_id, price_date, price). For each product, identify when the price changed compared to the previous entry.

Answer:
WITH Prev_price AS (
  SELECT 
    product_id,
    price_date,
    price,
    LAG(price) OVER (PARTITION BY product_id ORDER BY price_date) AS previous_price
  FROM product_prices
)
SELECT 
  product_id,
  price_date,
  price,
  previous_price,
  CASE 
    WHEN previous_price = price THEN 'No'
    ELSE 'Yes'
  END AS price_changed
FROM Prev_price;

6.You’re working with a table called sales(sale_id, customer_id, sale_date). For customers who made at least two purchases, calculate the number of days between their first and second purchase.

Answer:
WITH Sale_market AS (
  SELECT 
    customer_id,
    sale_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date ASC) AS rnk
  FROM sales
),
T1 AS (
  SELECT customer_id, sale_date FROM Sale_market WHERE rnk = 1
),
T2 AS (
  SELECT customer_id, sale_date FROM Sale_market WHERE rnk = 2
)
SELECT 
  T1.customer_id,
  T1.sale_date AS first_purchase_date,
  T2.sale_date AS second_purchase_date,
  DATEDIFF(T2.sale_date, T1.sale_date) AS days_between
FROM T1
INNER JOIN T2 ON T1.customer_id = T2.customer_id;

7.You’re working with a table called sales(sale_id, customer_id, sale_date). Identify customers who had a gap of more than 45 days between any two consecutive purchases.

Answer:
WITH inactivity_gaps AS (
  SELECT 
    sale_id,
    customer_id,
    sale_date,
    LAG(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date ASC) AS previous_sale_date
  FROM sales
)
SELECT 
  sale_id,
  customer_id,
  sale_date,
  previous_sale_date,
  DATEDIFF(sale_date, previous_sale_date) AS days_between
FROM inactivity_gaps
WHERE previous_sale_date IS NOT NULL
  AND DATEDIFF(sale_date, previous_sale_date) > 45;
  
8.Problem Statement: From tables orders(order_id, customer_id), order_items(order_id, product_id, quantity), and products(product_id, name, price), find each customer’s top-selling product based on total spend.

Answer:
WITH customer_product_spend AS (
  SELECT 
    o.customer_id,
    oi.product_id,
    p.name AS product_name,
    SUM(p.price * oi.quantity) AS total_spent,
    RANK() OVER (PARTITION BY o.customer_id ORDER BY SUM(p.price * oi.quantity) DESC) AS rnk
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN product p ON p.product_id = oi.product_id
  GROUP BY o.customer_id, oi.product_id, p.name
)
SELECT 
  customer_id,
  product_id,
  product_name,
  total_spent
FROM customer_product_spend
WHERE rnk = 1;

9.Problem Statement: From tables orders(order_id, customer_id) and order_items(order_id, product_id, quantity), and products(product_id, price), identify customers whose total spend is above the average spend across all customers.

Answer:
WITH customer_spend AS (
  SELECT 
    o.customer_id,
    SUM(p.price * oi.quantity) AS total_spent
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN product p ON p.product_id = oi.product_id
  GROUP BY o.customer_id
)
SELECT 
  customer_id,
  total_spent
FROM customer_spend
WHERE total_spent > (
  SELECT AVG(total_spent) FROM customer_spend
);

10.Problem Statement: You’re given two tables:
products(product_id, product_name, category)
orders(order_id, product_id, order_date)

Write a query to return the top 2 most ordered products in each category.

WITH order_detail AS (
  SELECT p.category, p.product_name, COUNT(o.order_id) AS 'Total_order'
  FROM products p
  LEFT JOIN orders o ON p.product_id = o.product_id
  GROUP BY p.category, p.product_name
),
max_order AS (
  SELECT category, product_name, Total_order,
         ROW_NUMBER() OVER (PARTITION BY category ORDER BY Total_order DESC) AS rnk
  FROM order_detail
)
SELECT * FROM max_order
WHERE rnk < 3;




