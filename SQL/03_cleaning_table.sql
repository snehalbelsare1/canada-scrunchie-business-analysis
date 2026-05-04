/* -----------------------------------------------------------------------------------------------
	**** CLEANING TABLE	****
------------------------------------------------------------------------------------------------- */

-- 1. customers_stg --> customers_clean
	-- I. Trimming spaces
		UPDATE customers_stg
			SET
			customer_id =LTRIM(RTRIM(customer_id)),
			email = LTRIM(RTRIM(email)),
			signup_date = LTRIM(RTRIM(signup_date)),
			customer_type = LTRIM(RTRIM(customer_type)),
			acquisition_channel = LTRIM(RTRIM(acquisition_channel)),
			city = LTRIM(RTRIM(city)),
			province = LTRIM(RTRIM(province)),
			country = LTRIM(RTRIM(country)),
			region_id = LTRIM(RTRIM(region_id));

	-- II. Adding column customer_name
		ALTER TABLE customers_stg
		ADD customer_name VARCHAR(150);
		
		-- Combining first_name & last_name 
		UPDATE customers_stg
		SET customer_name = first_name + ' ' + last_name;

		UPDATE customers_stg
		SET customer_name = LTRIM(RTRIM(customer_name));

		-- Drop columns first_name & last_name
		ALTER TABLE customers_stg
		DROP COLUMN first_name, last_name;

	-- III. Standardize text format
		-- i. Column : Email
			UPDATE customers_stg
			SET email = LOWER(email);

		-- ii. For column : customer_type
			UPDATE customers_stg
			SET customer_type =
			CASE
				WHEN customer_type IN ('returning','Returning','RETURNING') THEN 'Returning'
				WHEN customer_type IN ('vip','Vip','VIP') THEN 'VIP'
				WHEN customer_type IN ('new','New','NEW') THEN 'New'
				ELSE customer_type
			END;
		-- iii. For column : acquisition_channel
			UPDATE customers_stg
			SET acquisition_channel =
			CASE
				WHEN acquisition_channel IN ('Referral','REFERRAL','referral') THEN 'Referral'
				WHEN acquisition_channel IN ('Email','email','EMAIL') THEN 'Email'
				WHEN acquisition_channel IN ('Organic','organic','ORGANIC') THEN 'Organic'
				WHEN acquisition_channel IN ('Paid ads','Paid Ads','PAID ADS') THEN 'Paid Ads'
				ELSE acquisition_channel
			END;

-- 2. For categories_stg 
	-- I. Trimming spaces
		UPDATE categories_stg
			SET
			category_id =LTRIM(RTRIM(category_id)),
			category_name = LTRIM(RTRIM(category_name));

-- 3. For orders_stg
	-- I. Trimming spaces
		UPDATE orders_stg
			SET 
			order_id = LTRIM(RTRIM(order_id)),
			customer_id = LTRIM(RTRIM(customer_id)),
			order_date = LTRIM(RTRIM(order_date)),
			region_id = LTRIM(RTRIM(region_id)),
			order_status = LTRIM(RTRIM(order_status)),
			payment_method = LTRIM(RTRIM(payment_method));

-- 4. For order_items
	-- I. Trimming spaces
		UPDATE order_items_stg
		SET 
		order_item_id = LTRIM(RTRIM(order_item_id)),
		order_id = LTRIM(RTRIM(order_id)),
		product_id = LTRIM(RTRIM(product_id)),
		quantity = LTRIM(RTRIM(quantity)),
		discount_pct = LTRIM(RTRIM(discount_pct)),
		item_price = LTRIM(RTRIM(item_price));

	-- II. Formatting values to DECIMAL (3,1)
		-- i. For column discount_pct
			UPDATE order_items_stg
			SET discount_pct = (discount_pct * 100);
			ALTER TABLE order_items_stg
			ALTER COLUMN discount_pct DECIMAL (3,1);

		-- ii. For column item_price
			ALTER TABLE order_items_stg
			ALTER COLUMN item_price DECIMAL (3,1);

-- 5. For products
	-- I. Trimmig spaces
		UPDATE products_stg
		SET
			product_id = LTRIM(RTRIM(product_id)),
			product_name = LTRIM(RTRIM(product_name)),
			category_id = LTRIM(RTRIM(category_id)),
			unit_cost = LTRIM(RTRIM(unit_cost)),
			unit_price = LTRIM(RTRIM(unit_price)),
			launch_date = LTRIM(RTRIM(launch_date)),
			active_flag = LTRIM(RTRIM(active_flag));
		
	-- II. Formatting values to DECIMAL (3,2)
		ALTER TABLE products_stg
		ALTER COLUMN unit_cost DECIMAL (3,2);

		ALTER TABLE products_stg
		ALTER COLUMN unit_price DECIMAL (3,2);
		
	-- III. Derived columns
		ALTER TABLE products_stg
		ADD unit_margin INT;

		UPDATE products_stg
		SET unit_margin = unit_price - unit_cost; 

-- 6. For regions
	-- I. Trimming spaces
		UPDATE regions_stg
		SET
			region_id = LTRIM(RTRIM(region_id)),
			region_name = LTRIM(RTRIM(region_name)),
			country = LTRIM(RTRIM(country));

-- 7. For returns
	-- I. Trimming spaces
		UPDATE returns_stg
		SET
			return_id = LTRIM(RTRIM(return_id)),
			order_item_id = LTRIM(RTRIM(order_item_id)),
			return_date = LTRIM(RTRIM(return_date)),
			return_reason = LTRIM(RTRIM(return_reason)),
			refund_amount = LTRIM(RTRIM(refund_amount));
		
	-- II. Adjusting decimal values
		ALTER TABLE returns_stg
		ALTER COLUMN refund_amount DECIMAL (3,1);
