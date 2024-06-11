create table platinum_dimfact_layer.dim_products as 
select product_key, 
	product_name,
    brand, 
    color, 
    unit_cost_usd, 
    unit_price_usd, 
    sub_category_key, 
    sub_category as sub_category_name, 
    category_key, 
    category as category_name 
from products p ; 
 
ALTER TABLE platinum_dimfact_layer.dim_products 
ADD PRIMARY KEY (product_key); 


--select currency_detail_code, 
--    cast(date AS date) as exchange_rates_date, 
--    currency as currency_code,
--    exchange 
--from exchange_rates er

create table platinum_dimfact_layer.dim_exrates as 
select currency_detail_code, 
    cast(date AS date) as exchange_rates_date, 
    currency as currency_code,
    exchange 
from exchange_rates er ; 
 
ALTER TABLE platinum_dimfact_layer.dim_exrates 
ADD PRIMARY KEY (currency_detail_code); 

create table platinum_dimfact_layer.dim_stores as
select store_key,
  country as store_country,
  state as store_state,
  square_meters,
  cast(open_date as date) as open_date
from platinum_base_layer.stores s  

ALTER TABLE platinum_dimfact_layer.dim_stores 
ADD PRIMARY KEY (store_key);

create table platinum_dimfact_layer.dim_customers as
select customer_key,
  gender,
  name as cust_name,
  city,
  state_code,
  state,
  zip_code,
  country,
  continent,
  cast(birthday as date) as birthday_date,
  DATE_PART('year', '2020-12-31'::date) - DATE_PART('year', birthday) -
        CASE 
            WHEN DATE_PART('month', '2020-12-31'::date) < DATE_PART('month', birthday)
                OR (DATE_PART('month', '2020-12-31'::date) = DATE_PART('month', birthday) AND DATE_PART('day', '2020-12-31'::date) < DATE_PART('day', birthday))
            THEN 1 
            ELSE 0 
        END AS age
from platinum_base_layer.customers c 

ALTER TABLE platinum_dimfact_layer.dim_customers 
ADD PRIMARY KEY (customer_key);

create table platinum_dimfact_layer.fact_sales_detail as
select s.order_number,
	   s.line_item,
	   cast(s.order_date as date) , 
       cast(s.delivery_date as date) , 
	   s.customer_key ,
	   s.store_key ,
	   s.product_key ,
	   p.unit_price_usd as product_price,
	   s.quantity,
	   s.currency_code,
	   s.currency_detail_code 
from sales s 
join products p on s.product_key = p.product_key 

--create table platinum_dimfact_layer.fact_sales as
--select s.order_number , 
--    COUNT(line_item) as total_item, 
--    s.store_key , 
--    s.customer_key , 
--    cast(s.order_date as date) , 
--    cast(s.delivery_date as date) , 
--    sum(quantity) as total_quantity, 
--    sum(p.unit_price_usd) as total_price,
--    s.currency_code, 
--    s.currency_detail_code 
--from sales s  
--join products p on s.product_key = p.product_key  
--join exchange_rates er on s.currency_detail_code = er.currency_detail_code 
--group by 1, 3, 4, 5, 6, 9, 10
--
--ALTER TABLE platinum_dimfact_layer.fact_sales  
--ADD PRIMARY KEY (order_number);