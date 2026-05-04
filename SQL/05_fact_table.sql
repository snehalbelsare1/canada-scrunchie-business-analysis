/*----------------------------------------------------------------------------------------------------
		*** Fact Tables ***
-----------------------------------------------------------------------------------------------------*/
-- 1. fact_orders (Main fact table connected to all dimension tables)
	-- I. Create table - 
		CREATE TABLE fact_orders (
			order_key INT IDENTITY(1,1) PRIMARY KEY,
			order_id INT,
			order_items_id INT,
			category_key INT,
			customer_key INT,
			product_key INT,
			region_key INT,
			order_date DATE,
			quantity INT,
			discount_pct NUMERIC(10,2),
			item_price NUMERIC(10,2),
			order_status VARCHAR(50),
			payment_method VARCHAR(50),
		);
		
	-- II. Load values -
		INSERT INTO fact_orders (
			order_id,
			order_items_id,
			category_key,
			customer_key,
			product_key,
			region_key,
			order_date,
			quantity,
			discount_pct,
			item_price,
			order_status,
			payment_method
		)
		SELECT 
			o.order_id,
			oi.order_item_id,
			dca.category_key,
			dcu.customer_key,
			dp.product_key,
			dr.region_key,
			order_date,
			quantity,
			discount_pct,
			item_price,
			order_status,
			payment_method
		FROM orders_stg o
		JOIN order_items_stg oi
		ON o.order_id = oi.order_id
		JOIN dim_customers dcu
		ON o.customer_id = dcu.customer_id
		JOIN dim_regions dr
		ON o.region_id = dr.region_id
		JOIN dim_products dp
		ON dp.product_id = oi.product_id
		JOIN dim_categories dca
		ON dp.category_key = dca.category_key;
		

-- 2. fact_returns (connected to fact_orders)
	-- I. Creating table -
		CREATE TABLE fact_returns (
			return_key INT IDENTITY(1,1) PRIMARY KEY,
			return_id INT,
			order_key INT,
			return_date DATE,
			return_reason VARCHAR (250),
			refund_amount NUMERIC (10,2)
		);
		
	-- II. Load Values -
		INSERT INTO fact_returns (
			return_id,
			order_key,
			return_date,
			return_reason,
			refund_amount
			)
		SELECT
			re.return_id,
			fo.order_key,
			re.return_date,
			re.return_reason,
			re.refund_amount
		FROM returns_stg re
		JOIN order_items_stg oi
		ON oi.order_item_id = re.order_item_id
		JOIN fact_orders fo
		ON fo.order_items_id = oi.order_item_id;

