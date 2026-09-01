CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_market_by_market_region`(
	in_fiscal_year int,
    in_top_n int
)
BEGIN
	#Retrieve the top 2 markets in every region by their gross sales amount in FY=2021. 
	with cte1 as(select 
		c.market,
		c.region,
		round(sum(gp.gross_price*s.sold_quantity)/1000000,2) as gross_sales_mln
	from fact_sales_monthly s
	join fact_gross_price gp
		on gp.product_code = s.product_code
		and gp.fiscal_year = s.fiscal_year
	join dim_customer c
		on c.customer_code = s.customer_code
	where s.fiscal_year = in_fiscal_year
	group by c.market
	order by gross_sales_mln desc),
	cte2 as(select 
		*,
		dense_rank() over(partition by region order by gross_sales_mln desc) as ran_k
	from cte1)    
	select * from cte2
	where ran_k<=in_top_n;
END