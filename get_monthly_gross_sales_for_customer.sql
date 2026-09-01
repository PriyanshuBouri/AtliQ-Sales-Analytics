CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monthly_gross_sales_for_customer`(
	in_customer_codes text
)
BEGIN
	select 
		s.date,
		ROUND(sum(g.gross_price*s.sold_quantity),2) as gross_price_total
	from fact_sales_monthly s
	join fact_gross_price g
	on 
		s.product_code = g.product_code and
		g.fiscal_year = get_fiscal_year(s.date)
	where 
		find_in_set(s.customer_code, in_customer_codes)>0
	group by s.date
	order by s.date asc;    
END