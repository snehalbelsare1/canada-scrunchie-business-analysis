/*----------------------------------------------------------------------------------------------------
		***	Dimension Tables ***
-----------------------------------------------------------------------------------------------------*/
-- Descriptive (Which, Who, What, Where)--
-- 1. dim_categories
	-- I. Creating dimension Table 
		CREATE TABLE dim_categories (
			category_key INT IDENTITY(1,1) PRIMARY KEY,
			category_id INT,
			category_name VARCHAR (50)
		);
		
	-- II. Load values 
		INSERT INTO dim_categories (
			category_id,
			category_name
		)
		SELECT 
			category_id,
			category_name
		FROM categories_stg;
		
-- 2. dim_customers
	-- I. Creating table 
		CREATE TABLE dim_customers (
			customer_key INT IDENTITY(1,1) PRIMARY KEY,
			customer_id INT,
			email VARCHAR (50),
			signup_date DATE,
			customer_type VARCHAR (50),
			acquisition_channel VARCHAR (50),
			city VARCHAR (50),
			province VARCHAR (50),
			country VARCHAR (50),
			region_id INT,
			customer_name VARCHAR (50)
		);
	
	-- II. Load values
		INSERT INTO dim_customers (
			customer_id,
			email,
			signup_date,
			customer_type,
			acquisition_channel,
			city,
			province,
			country,
			region_id,
			customer_name
		)
		SELECT
			customer_id,
			email,
			signup_date,
			customer_type,
			acquisition_channel,
			city,
			province,
			country,
			region_id,
			customer_name
		FROM customers_stg;

-- 3. dim_products
	-- I. Creating table
		CREATE TABLE dim_products (
			product_key INT IDENTITY(1,1) PRIMARY KEY,
			product_id INT,
			category_key INT,
			product_name VARCHAR (50),
			unit_cost NUMERIC,
			unit_price NUMERIC,
			unit_margin NUMERIC,
			launch_date DATE,
			active_flag VARCHAR (50)
		);
		
	
	-- II. Load values
		INSERT INTO dim_products (
			product_id,
			category_key,
			product_name,
			unit_cost,
			unit_price,
			unit_margin,
			launch_date,
			active_flag
		)
		SELECT 
			p.product_id,
			ca.category_key,
			p.product_name,
			p.unit_cost,
			p.unit_price,
			p.unit_margin,
			p.launch_date,
			p.active_flag
		FROM products_stg p
		JOIN dim_categories ca
		ON p.category_id = ca.category_id;
			
-- 4. dim_regions
	-- I. Creating table
		CREATE TABLE dim_regions (
			region_key INT IDENTITY(1,1) PRIMARY KEY,
			region_id INT,
			region_name VARCHAR(50),
			country VARCHAR(50)
		);

	-- II. Load values - 
		INSERT INTO dim_regions (
			region_id,
			region_name,
			country
		)
		SELECT 
			region_id,
			region_name,
			country
		FROM regions_stg;
		SELECT * FROM dim_regions;
		SELECT * FROM orders_stg;

