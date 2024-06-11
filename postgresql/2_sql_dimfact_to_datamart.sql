--create table platinum_datamart.product_performance as
--select fsd.order_date ,
--	   fsd.product_key ,
--	   dp.product_name ,
--	   dp.brand ,
--	   dp.color ,
--	   dp.sub_category_name ,
--	   dp.category_name ,
--	   fsd.quantity as quantity_selled,
--	   dp.unit_cost_usd * fsd.quantity as total_cost_usd,
--	   (dp.unit_price_usd * fsd.quantity) * de.exchange  as total_revenue_converted,
--	   ((dp.unit_price_usd * fsd.quantity) * de.exchange)-(dp.unit_cost_usd * fsd.quantity) as total_profit_usd
--from fact_sales_detail fsd 
--join dim_products dp on fsd.product_key = dp.product_key 
--join dim_exrates de on fsd.currency_detail_code = de.currency_detail_code

create table platinum_datamart.product_performance as
select fsd.order_number ,
	   fsd.order_date ,
	   fsd.product_key ,
	   dp.product_name ,
	   dp.brand ,
	   dp.color ,
	   dp.sub_category_name ,
	   dp.category_name ,
	   fsd.quantity as quantity_selled,
	   (dp.unit_cost_usd * fsd.quantity) as total_cost_usd,
	   (dp.unit_price_usd * fsd.quantity) * de.exchange   as total_revenue_usd,
	   ((dp.unit_price_usd * fsd.quantity) * de.exchange )-(dp.unit_cost_usd * fsd.quantity) as total_profit_usd
from dim_products dp 
left join fact_sales_detail fsd on dp.product_key = fsd.product_key
left join dim_exrates de on fsd.currency_detail_code = de.currency_detail_code 

create table platinum_datamart.product_performance_2020 as
select fsd.order_number ,
	   fsd.order_date ,
	   fsd.product_key ,
	   dp.product_name ,
	   dp.brand ,
	   dp.color ,
	   dp.sub_category_name ,
	   dp.category_name ,
	   fsd.quantity as quantity_selled,
	   (dp.unit_cost_usd * fsd.quantity) as total_cost_usd,
	   (dp.unit_price_usd * fsd.quantity) * de.exchange   as total_revenue_usd,
	   ((dp.unit_price_usd * fsd.quantity) * de.exchange )-(dp.unit_cost_usd * fsd.quantity) as total_profit_usd
from dim_products dp 
left join fact_sales_detail fsd on dp.product_key = fsd.product_key
left join dim_exrates de on fsd.currency_detail_code = de.currency_detail_code 
where fsd.order_date between '2020-01-01' and '2020-12-31'

--select fsd.order_date ,
--	   dp.product_name ,
--	   fsd.quantity as quantity_selled,
--	   dp.unit_cost_usd * fsd.quantity as total_cost_usd,
--	   (dp.unit_price_usd * fsd.quantity) * de.exchange  as total_revenue_converted,
--	   ((dp.unit_price_usd * fsd.quantity) * de.exchange)-(dp.unit_cost_usd * fsd.quantity) as total_profit_usd
--from dim_products dp 
--join fact_sales_detail fsd on dp.product_key = fsd.product_key 
--join dim_exrates de on fsd.currency_detail_code = de.currency_detail_code 
--order by 3 asc

--select fsd.order_number,
--	   fsd.line_item ,
--	   fsd.order_date ,
--	   dc.cust_name as customer_name ,
--	   dp.product_name ,
--	   ds.store_country ,
--	   sum(fsd.quantity) as total_quantity ,
--	   (dp.unit_price_usd * fsd.quantity) * de.exchange  as total_price_usd
--from fact_sales_detail fsd 
--join dim_customers dc on fsd.customer_key = dc.customer_key 
--join dim_stores ds on fsd.store_key = ds.store_key 
--join dim_products dp on fsd.product_key = dp.product_key 
--join dim_exrates de on fsd.currency_detail_code = de.currency_detail_code 
--group by 1, 2, 3, 4, 5, 6, dp.unit_price_usd, fsd.quantity, de.exchange
--order by 1, 2

create table platinum_datamart.sales_by_channel as
select fsd.order_number ,
	   fsd.order_date ,
	   fsd.delivery_date ,
	   fsd.delivery_date - fsd.order_date as time_process ,
	   fsd.customer_key ,
	   dc.cust_name ,
	   dc.age ,
	   fsd.product_key ,
	   fsd.store_key ,
	   CASE 
        WHEN fsd.store_key = 0 then 'Online'
        ELSE 'Offline'
    END AS order_channel
from fact_sales_detail fsd 
join dim_customers dc on fsd.customer_key = dc.customer_key 

create table platinum_datamart.sales_by_channel_2020 as
select fsd.order_number ,
	   fsd.order_date ,
	   fsd.delivery_date ,
	   fsd.delivery_date - fsd.order_date as time_process ,
	   fsd.customer_key ,
	   dc.cust_name ,
	   dc.age ,
	   fsd.product_key ,
	   fsd.store_key ,
	   CASE 
        WHEN fsd.store_key = 0 then 'Online'
        ELSE 'Offline'
    END AS order_channel
from fact_sales_detail fsd 
join dim_customers dc on fsd.customer_key = dc.customer_key 
where fsd.order_date between '2020-01-01' and '2020-12-31'
order by 2

create table platinum_datamart.sales_by_country as
select fsd.order_number ,
	   fsd.order_date ,
	   fsd.store_key ,
	   ds.store_state ,
	   ds.store_country ,
	   sum(fsd.quantity) as quantity_selled ,
	   (dp.unit_price_usd * fsd.quantity) * de.exchange  as total_revenue_usd,
	   ((dp.unit_price_usd * fsd.quantity) * de.exchange)-(dp.unit_cost_usd * fsd.quantity) as total_profit_usd
from fact_sales_detail fsd 
join dim_stores ds on fsd.store_key = ds.store_key 
join dim_products dp on fsd.product_key = dp.product_key 
join dim_exrates de on fsd.currency_detail_code = de.currency_detail_code 
where fsd.store_key != 0
group by 1, 2, 3, 4, 5, dp.unit_cost_usd , dp.unit_price_usd , fsd.quantity , de.exchange

create table platinum_datamart.sales_by_country_2020 as
select fsd.order_number ,
	   fsd.order_date ,
	   fsd.store_key ,
	   ds.store_state ,
	   ds.store_country ,
	   sum(fsd.quantity) as quantity_selled ,
	   (dp.unit_price_usd * fsd.quantity) * de.exchange  as total_revenue_usd,
	   ((dp.unit_price_usd * fsd.quantity) * de.exchange)-(dp.unit_cost_usd * fsd.quantity) as total_profit_usd
from fact_sales_detail fsd 
join dim_stores ds on fsd.store_key = ds.store_key 
join dim_products dp on fsd.product_key = dp.product_key 
join dim_exrates de on fsd.currency_detail_code = de.currency_detail_code 
where fsd.store_key != 0
and fsd.order_date between '2020-01-01' and '2020-12-31'
group by 1, 2, 3, 4, 5, dp.unit_cost_usd , dp.unit_price_usd , fsd.quantity , de.exchange 
order by 2

create table platinum_datamart.customer_orders_detail as
select distinct fsd.order_number ,
	   fsd.order_date ,
	   fsd.store_key ,
	   case 
       when fsd.store_key = 0  then 'Online'
       else 'Offline'
    end as order_channel ,
	   count(fsd.line_item) as total_item ,
	   sum(fsd.quantity) as total_quantity ,
	   fsd.customer_key ,
	   dc.cust_name ,
	   dc.gender ,
	   dc.age ,
	case 
       when dc.age <= 24  then '<= 24 (Z Gen)'
       when dc.age between 25 and 39 then '25 >= 39(Milenial)'
       when dc.age between 40 and 55 then '40 >= 55 (X Gen)'
       when dc.age between 56 and 74 then '56 >= 74 (Baby Boomer)'
       else '>= 75 (Silent Gen)'
    end as age_range ,
	   dc.city ,
	   dc.state ,
	   dc.country ,
	   dc.continent ,
	case
	   	when fsd.store_key = 0 then 'Online'
	   	else 'Offline'
	end as order_channel 
from dim_customers dc
left join fact_sales_detail fsd on dc.customer_key  = fsd.customer_key 
group by 1, 2, 3, 7, 8, 9, 10, 11, 12, 13, 14, 15

create table platinum_datamart.customer_orders_detail_2020_v2 as
select distinct fsd.order_number ,
	   fsd.order_date ,
	   fsd.store_key ,
	   count(fsd.line_item) as total_item ,
	   sum(fsd.quantity) as total_quantity ,
	   fsd.customer_key ,
	   dc.cust_name ,
	   dc.gender ,
	   dc.age ,
	case 
       when dc.age <= 24  then '<= 24 (Z Gen)'
       when dc.age between 25 and 39 then '25 >= 39(Milenial)'
       when dc.age between 40 and 55 then '40 >= 55 (X Gen)'
       when dc.age between 56 and 74 then '56 >= 74 (Baby Boomer)'
       else '>= 75 (Silent Gen)'
    end as age_range ,
	   dc.city ,
	   dc.state ,
	   dc.country ,
	   dc.continent ,
	case
	   	when fsd.store_key = 0 then 'Online'
	   	else 'Offline'
	end as order_channel
from dim_customers dc
left join fact_sales_detail fsd on dc.customer_key  = fsd.customer_key 
left join dim_exrates de on fsd.currency_detail_code = de.currency_detail_code 
where fsd.order_date between '2020-01-01' and '2020-12-31'
group by 1, 2, 3, 6, 7, 8, 9, 10, 11, 12, 13, 14
order by 2 asc




