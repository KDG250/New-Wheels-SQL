-- 1
SELECT COUNT(*) AS num_of_customers, state
FROM customer_t
GROUP BY state
ORDER BY num_of_customers DESC;

-- 2

SELECT COUNT(customer_id) as num_of_customers, vehicle_maker
FROM order_t
JOIN product_t USING(product_id)
GROUP BY vehicle_maker
ORDER BY num_of_customers DESC;

-- 3 Most popular maker in each state
SELECT state, product_t.vehicle_maker,
RANK()OVER(Partition By STATE) AS orders,
COUNT(vehicle_maker)OVER(ORDER BY state) as rnk
FROM customer_t
JOIN order_t ON order_t.customer_id = customer_t.customer_id
JOIN product_t ON product_t.product_id = order_t.product_id;


-- practice orders and vehicle count and city

SELECT CustomerId, state, city, vehicle_maker
FROM(
	SELECT c.customer_id AS CustomerId, c.state, c.city, p.vehicle_maker, 
		SUM(o.quantity) AS Vehicles_Ordered,
		RANK() OVER(PARTITION BY c.state ORDER BY SUM(o.quantity) DESC) AS rnk
	FROM customer_t c 
    JOIN order_t o ON o.customer_id = c.customer_id
	JOIN product_t p ON p.product_id = o.product_id
    GROUP BY c.customer_id, p.product_id) AS RankedVehicles
WHERE rnk = 1;
    
-- Q4 --
SELECT ROUND(SUM(RatingCount * RatingNumber)/Sum(RatingCount), 3) AS Average_Rating
FROM(
	SELECT customer_feedback, COUNT(*) AS RatingCount,
        CASE 
        WHEN customer_feedback = "Very Bad" THEN 1
        WHEN customer_feedback = "Bad" THEN 2
        WHEN customer_feedback = "Okay" THEN 3
        WHEN customer_feedback = "Good" THEN 4
        WHEN customer_feedback = "Very Good" THEN 5
        END AS RatingNumber
    FROM order_t
    GROUP BY customer_feedback
    ORDER BY RatingNumber DESC) AS RatingDistribution;
    
    
    -- Q5 --
SELECT quarter_number, CountPerQuarter, (CountPerQuarter/SUM(CountPerQuarter))*100 AS percentagesmf
FROM
(
SELECT quarter_number, COUNT(customer_feedback) as CountPerQuarter
FROM order_t
GROUP BY 1
Order By 1) as Distrib
GROUP BY quarter_number;


-- Q6 -- 

    SELECT COUNT(*) AS orderscount, quarter_number
    FROM order_t
    GROUP BY 2
    ORDER BY 2;
    
   -- nonsense -- 

    
    SELECT credit_card_type, ROUND(AVG(discount), 2) AS avg_discount
FROM customer_t
JOIN order_t o USING(customer_id)
GROUP BY credit_card_type
ORDER BY avg_discount DESC;
	
   SELECT state,  vehicle_maker
FROM(
	SELECT c.customer_id AS CustomerId, c.state, city, p.vehicle_maker, 
		SUM(o.quantity) AS Vehicles_Ordered,
		RANK() OVER(PARTITION BY c.state ORDER BY SUM(o.quantity) DESC) AS rnk
	FROM customer_t c 
    JOIN order_t o ON o.customer_id = c.customer_id
	JOIN product_t p ON p.product_id = o.product_id
    GROUP BY c.customer_id, p.product_id) AS RankedVehicles
WHERE rnk = 1
GROUP BY state;