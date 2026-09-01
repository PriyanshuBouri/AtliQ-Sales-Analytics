CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_market_by_sales`(
	in_fiscal_year int,
    in_top_n int
)
BEGIN
	SELECT 
		market,
		round(sum(net_sales)/1000000,2) as net_sales_mln
	FROM gdb0041.net_sales
	where fiscal_year = in_fiscal_year
	group by market
	order by net_sales_mln desc
	limit in_top_n;
END