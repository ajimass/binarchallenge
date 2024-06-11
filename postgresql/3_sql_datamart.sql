select store_country,
	   sum(quantity_selled) as total_quantity ,
	   round(sum(total_revenue_usd)) as total_revenue_usd ,
	   round(sum(total_profit_usd)) as total_profit_usd
from sales_by_country sbc 
group by 1
order by 2 desc

select customer_key ,
	   cust_name ,
	   case 
       when count(customer_key) >= 2  then 'Repeat Order'
       else 'One Time Order'
    end as customer_retention
from customer_orders_detail_2020 cod2
group by 1, 2, store_key 
order by 1

--create table platinum_datamart.customer_retention as
--with cte as (
--select customer_key ,
--	   cust_name , 
--	   case
--	   when store_key = 0 then 'Online'
--	   else 'Offline'
--	   end as order_channel,
--       count(customer_key) as total_order
--from customer_orders_detail_2020 cod2
--group by 1, 2, store_key 
--order by 3 desc
--)
--select * ,
--	   case 
--	   	when total_order >= 2 then 'repeat order'
--	   	else 'one time order'
--	   end as order_retention
--from cte
--where customer_key = 526078



--create table platinum_datamart.channel_comparation as
--with cte as (
--select distinct sbc.order_channel as order_channel,
--	   sbc.order_date ,
--	   extract(month from sbc.order_date) as order_month , 
--	   count(distinct sbc.order_number) as  total_order ,
--	   round(sum(pp.total_revenue_usd)) as total_revenue_usd ,
--	   sum((pp.total_profit_usd)) as total_profit_usd 
--from sales_by_channel_2020 sbc 
--join product_performance pp on sbc.order_number = pp.order_number 
--where sbc.order_date between '2020-01-01' and '2020-12-31'
--group by 1, 2
--order by 2
--)
--select distinct order_month ,
--	   order_channel ,
--	   total_order
--from cte
--group by 1, 2, 3

select count(distinct order_number) 
from product_performance_2020 pp 

create table platinum_datamart.channel_comparation as
select distinct sbc.order_channel as order_channel,
	   sbc.order_date ,
	   extract(month from sbc.order_date) as order_month , 
	   count(distinct sbc.order_number) as  total_order ,
	   round(sum(pp.total_revenue_usd)) as total_revenue_usd ,
	   round(sum(pp.total_profit_usd)) as total_profit_usd 
from sales_by_channel_2020 sbc 
join product_performance pp on sbc.order_number = pp.order_number 
where sbc.order_date between '2020-01-01' and '2020-12-31'
group by 1, 2
order by 2

select count(distinct order_number)
from sales_by_channel_2020 sbc 

select order_retention ,
	   count(order_retention) as compare 
from customer_retention cr 
group by 1

with temp as (
select customer_key ,
	   count(*) as orders
from customer_retention cr 
group by 1
order by 2 desc
)
select count(customer_key) 
from temp
where orders >= 2

with temp as (
select customer_key ,
	   count(*) as orders
from customer_retention cr 
group by 1
order by 2 desc
)
select count(customer_key) 
from temp
where orders = 1

with temp as (
select customer_key ,
	   count(*) as orders
from customer_orders_detail_2020 cod 
group by 1
order by 2 desc
)
select count(customer_key) 
from temp
where orders >= 2

create table platinum_datamart.customer_retention_2020 as
select customer_key ,
	   cust_name ,
	   gender ,
	   age ,
	   age_range ,
	   city as customer_city ,
	   state as customer_state ,
	   country as customer_country ,
	   continent as customer_continent ,
	   count(*) as orders ,
	   case 
	   	when count(*) >= 2 then 'Repeat Order'
	   	when count(*) = 1 then 'One Time order'
	   	else 'Never Order'
	   end as order_retention
from customer_orders_detail_2020 cod 
group by 1, 2, 3, 4, 5, 6, 7, 8, 9


with temp as (
select * ,
	   case
	   	when store_key = 0 then 'Online'
	   	else 'Offline'
	   end as order_channel
from customer_orders_detail_2020 cod 
)
select distinct age_range ,
	   count(*)
from temp
where order_channel = 'Offline'
group by 1
order by 2

select distinct age_range ,
	   count(*)
from customer_orders_detail_2020_v2 codv 
where order_channel = 'Online'
group by 1

select count(distinct order_number)
from sales_by_channel_2020 sbc 

