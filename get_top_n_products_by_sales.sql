CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_products_by_sales`(
	in_market varchar(45),
    in_fiscal_year int,
    in_top_n int
)
BEGIN
	#-------top 5 market by sales-------- 
	SELECT 
		product,
		round(sum(net_sales)/1000000,2) as net_sales_mln
	FROM gdb0041.net_sales n
    	join dim_customer c
	on
		n.customer_code = c.customer_code
	where fiscal_year = in_fiscal_year and c.market = in_market
	group by product
	order by net_sales_mln desc
	limit in_top_n;
END