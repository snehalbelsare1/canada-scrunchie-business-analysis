/* ----------------------------------------------------------------------------
	STAGING TABLES
----------------------------------------------------------------------------- */

	SELECT * INTO categories_stg FROM categories_raw;
	SELECT * INTO customers_stg FROM customers_raw;
	SELECT * INTO order_items_stg FROM order_items_raw;
	SELECT * INTO orders_stg FROM orders_raw;
	SELECT * INTO products_stg FROM products_raw;
	SELECT * INTO regions_stg FROM regions_raw;
	SELECT * INTO returns_stg FROM returns_raw;
