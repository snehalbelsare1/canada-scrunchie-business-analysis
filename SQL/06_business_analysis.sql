/* -------------------------------------------------------------------------------------------
			*** Analysis : View Table ***
-----------------------------------------------------------------------------------------------*/
-- 1. View_Table
		CREATE VIEW vw_sales AS
		SELECT 
			fo.order_id,
			fo.order_key,
			fo.order_date,
			fo.quantity,
			fo.discount_pct,
			fo.item_price,
			fo.payment_method,
			(fo.item_price * fo.quantity * (1-fo.discount_pct/100))AS net_revenue,
			dp.product_name,
			dp.unit_cost,
			dp.unit_margin,
			dp.unit_price,
			dc.category_name,
			dcu.customer_name,
			dcu.customer_type,
			dcu.acquisition_channel,
			dcu.country,
			dcu.city,
			dcu.signup_date,
			dr.region_name
		FROM fact_orders fo
		JOIN dim_products dp ON fo.product_key = dp.product_key
		JOIN dim_categories dc ON dp.category_key = dc.category_key
		JOIN dim_customers dcu ON fo.customer_key = dcu.customer_key
		JOIN dim_regions dr ON fo.region_key = dr.region_key;

		SELECT * FROM vw_sales;

-- 2. Analysis 
	-- I. Core Business Matrics -
		-- i. Total Revenue -
			SELECT SUM(net_revenue) AS total_revenue
			FROM vw_sales;

		-- ii. Total Orders -
			SELECT COUNT(DISTINCT order_id) AS total_orders
			FROM vw_sales;

	-- II. Time Based Analysis -
		-- i. Annual Revenue Trend -
			SELECT 
			FORMAT(order_date, 'yyyy') AS Year,
			SUM(net_revenue) AS revenue
			FROM vw_sales
			GROUP BY FORMAT (order_date, 'yyyy')
			ORDER BY year;
		
		-- ii. Monthly Revenue Trend -
			SELECT 
			FORMAT(order_date, 'yyyy-MM') AS month,
			SUM(net_revenue) AS revenue
			FROM vw_sales
			GROUP BY FORMAT(order_date, 'yyyy-MM')
			ORDER BY month;

	-- III. Products & Category Insights -
		-- i. Category by Revenue -
			SELECT 
				category_name,
				SUM(net_revenue) AS revenue
			FROM vw_sales
			GROUP BY category_name
			ORDER BY revenue DESC;

		-- ii. Products by Revenue -
			SELECT 
			product_name,
			SUM(net_revenue) AS revenue
			FROM vw_sales
			GROUP BY product_name
			ORDER BY revenue DESC;

		-- iii. Top 10 products -
			SELECT Top 10
				product_name,
				SUM(net_revenue) AS revenue
				FROM vw_sales
				GROUP BY product_name
				ORDER BY revenue DESC;

	-- IV. High Margin Products -
		SELECT 
			product_name,
			AVG(unit_margin) AS avg_margin,
			SUM(net_revenue) AS revenue
		FROM vw_sales
		GROUP BY product_name
		ORDER BY avg_margin DESC;

	-- V. Customer Insights -
		-- i. Revenue by customer Type -
			SELECT 
				customer_type,
				SUM(net_revenue) AS revenue
			FROM vw_sales
			GROUP BY customer_type
			ORDER BY customer_type ASC;

		-- ii. Top Customers -
			SELECT TOP 10
				customer_name,
				SUM(net_revenue) AS revenue
			FROM vw_sales
			GROUP BY customer_name
			ORDER BY revenue DESC;

	-- VI. Regional Analysis -
		SELECT 
			region_name,
			SUM(net_revenue) AS revenue
		FROM vw_sales
		GROUP BY region_name
		ORDER BY revenue DESC;

	-- VII. Return Analysis -
		-- i. Return by revenue - 
			SELECT 
			COUNT(*) AS total_returns,
			SUM(refund_amount) AS total_refunds
			FROM fact_returns;

		-- ii. Return rate - 
			SELECT 
			COUNT(DISTINCT fr.order_key) * 100.0 / COUNT(DISTINCT fo.order_key) AS return_rate_pct
			FROM fact_orders fo
			LEFT JOIN fact_returns fr ON fo.order_key = fr.order_key;

	-- VIII. Profit Analysis - 
		SELECT 
			SUM(net_revenue) AS revenue,
			SUM(quantity * unit_cost) AS total_cost,
			SUM(net_revenue) - SUM(quantity * unit_cost) AS profit
		FROM vw_sales;
