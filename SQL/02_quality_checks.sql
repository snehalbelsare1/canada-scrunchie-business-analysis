/* ----------------------------------------------------------------------------
	DATA QUALITY CHECKS
------------------------------------------------------------------------------ */
-- 1. For customers_stg
	-- I. Row Count 
		SELECT COUNT (*) AS row_Count FROM customers_stg;
	
	-- II. Check duplicates on primary key
		SELECT customer_id, COUNT (*) AS dup_count
		FROM customers_stg
		GROUP BY customer_id
		HAVING COUNT (*) > 1;
	
	-- III. Check nulls
		SELECT COUNT (*) AS NULL_Customers
		FROM customers_stg
		WHERE customer_id IS NULL 
		OR first_name IS NULL
		OR last_name IS NULL
		OR email IS NULL
		OR signup_date IS NULL
		OR customer_type IS NULL
		OR acquisition_channel IS NULL
		OR city IS NULL
		OR province IS NULL
		OR country IS NULL
		OR region_id IS NULL;

-- 2. For categories_stg
	-- I. Row Count 
		SELECT COUNT (*) AS row_Count FROM categories_stg;
	
	-- II. Check duplicates on primary key
		SELECT category_id, COUNT (*) AS dup_count
		FROM categories_stg
		GROUP BY category_id
		HAVING COUNT (*) > 1;
	
	-- III. Check nulls
		SELECT COUNT (*) AS NULL_categories
		FROM categories_stg
		WHERE category_id IS NULL 
		OR category_name IS NULL;

-- 3. For products_stg
	-- I. Row Count 
		SELECT COUNT (*) AS row_Count FROM products_stg;
	
	-- II. Check duplicates on primary key
		SELECT product_id, COUNT (*) AS dup_count
		FROM products_stg
		GROUP BY product_id
		HAVING COUNT (*) > 1;
	
	-- III. Check nulls
		SELECT COUNT (*) AS NULL_products
		FROM products_stg
		WHERE product_id IS NULL 
		OR product_name IS NULL
		OR category_id IS NULL
		OR unit_cost IS NULL
		OR unit_price IS NULL
		OR launch_date IS NULL
		OR active_flag IS NULL;
		
-- 4. For orders_stg
	-- I. Row Count 
		SELECT COUNT (*) AS row_Count FROM orders_stg;
	
	-- II. Check duplicates on primary key
		SELECT order_id, COUNT (*) AS dup_count
		FROM orders_stg
		GROUP BY order_id
		HAVING COUNT (*) > 1;
	
	-- III. Check nulls
		SELECT COUNT (*) AS NULL_products
		FROM orders_stg
		WHERE order_id IS NULL 
		OR customer_id IS NULL
		OR region_id IS NULL
		OR order_date IS NULL
		OR order_status IS NULL
		OR payment_method IS NULL;

-- 5. For order_items_stg
	-- I. Row Count 
		SELECT COUNT (*) AS row_Count FROM order_items_stg;
	
	-- II. Check duplicates on primary key
		SELECT order_item_id, COUNT (*) AS dup_count
		FROM order_items_stg
		GROUP BY order_item_id
		HAVING COUNT (*) > 1;
	
	-- III. Check nulls
		SELECT COUNT (*) AS NULL_products
		FROM order_items_stg
		WHERE product_id IS NULL 
		OR order_id IS NULL
		OR order_item_id IS NULL
		OR quantity IS NULL
		OR discount_pct IS NULL
		OR item_price IS NULL;

	-- IV. Check Negative revenue 
		SELECT * 
		FROM order_items_stg
		WHERE quantity < 0 OR item_price < 0;

	-- V. Check Invalid discount
		SELECT *
		FROM order_items_stg
		WHERE discount_pct > 100 OR discount_pct < 0;

-- 6. For region_stg
	-- I. Row Count 
		SELECT COUNT (*) AS row_Count FROM regions_stg;
	
	-- II. Check duplicates on primary key
		SELECT region_id, COUNT (*) AS dup_count
		FROM regions_stg
		GROUP BY region_id
		HAVING COUNT (*) > 1;
	
	-- III. Check nulls
		SELECT COUNT (*) AS NULL_products
		FROM regions_stg
		WHERE region_id IS NULL 
		OR region_name IS NULL
		OR country IS NULL;

-- 7. For returns_stg
	-- I. Row Count 
		SELECT COUNT (*) AS row_Count FROM returns_stg;
	
	-- II. Check duplicates on primary key
		SELECT return_id, COUNT (*) AS dup_count
		FROM returns_stg
		GROUP BY return_id
		HAVING COUNT (*) > 1;
	
	-- III. Check nulls
		SELECT COUNT (*) AS NULL_products
		FROM returns_stg
		WHERE return_id IS NULL 
		OR order_item_id IS NULL
		OR return_date IS NULL
		OR return_reason IS NULL
		OR refund_amount IS NULL;
		
-- 8. Foreign key checks
	-- I. For orders_stg
		-- i. Orders_stg --> Customers_stg
			SELECT o.*
			FROM orders_stg o
			LEFT JOIN customers_stg c 
			ON o.customer_id  =  c.customer_id 
			WHERE c.customer_id IS NULL;

		-- ii. orders_stg --> regions_stg
			SELECT o.*
			FROM orders_stg o
			LEFT JOIN regions_stg r
			ON o.region_id = r.region_id
			WHERE r.region_id IS NULL;

	-- II. For customers_stg
		-- i. customers_stg --> regions_stg
			SELECT c.*
			FROM customers_stg c
			LEFT JOIN regions_stg r
			ON c.region_id = r.region_id
			WHERE r.region_id IS NULL;

	-- III. For order_items_stg
		-- i. order_items_stg --> orders_stg
			SELECT oi.*
			FROM order_items_stg oi
			LEFT JOIN orders_stg o
			on oi.order_id = o.order_id
			WHERE o.order_id IS NULL;

		-- ii. order_items_stg --> products_stg
			SELECT oi.*
			FROM order_items_stg oi
			LEFT JOIN products_stg p
			ON oi.product_id = p.product_id
			WHERE p.product_id IS NULL;

	-- IV. For products_stg
		-- i. products_st --> categories_stg
			SELECT p.*
			FROM products_stg p
			LEFT JOIN categories_stg ca
			ON p.category_id = ca.category_id
			WHERE ca.category_id IS NULL;

	-- V. For returns_stg
		-- i. returns_stg --> order_items_stg
			SELECT r.*
			FROM returns_stg r
			LEFT JOIN order_items_stg oi
			ON r.order_item_id = oi.order_item_id
			WHERE oi.order_item_id IS NULL;
