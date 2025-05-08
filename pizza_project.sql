create database pizza;
select * from pizza_types;
select * from pizzas;


select * from orders; 
truncate orders;

-- copy location from the properties of the file, then add another \ to the existing \,then add \\ and the file.csv
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\orders.csv'
into table orders
fields terminated by ','
enclosed by ''
lines terminated by '\r\n'
ignore 1 lines; 

select * from order_details; 
truncate order_details;

-- copy location from the properties of the file, then add another \ to the existing \,then add \\ and the file.csv
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\order_details.csv'
into table order_details
fields terminated by ','
enclosed by ''
lines terminated by '\r\n'
ignore 1 lines; 

-- 1. Retrieve the total number of orders placed.
select * from orders;
select count(*) as total_number from orders;
-- 2. Calculate the total revenue generated from pizza sales.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders; 
select round(sum(p.price * o.quantity),2) as total_revenue from pizzas as p join order_details as o on p.pizza_id=o.pizza_id;
-- 3. Identify the highest-priced pizza.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
select pi.name,p.price from pizza_types as pi join pizzas as p on pi.pizza_type_id=p.pizza_type_id order by 2 desc limit 1;
-- 4. Identify the most common pizza size ordered.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
with size as (select pizza_id,case when pizza_id like '%s' then 'small' when pizza_id like '%m' then 'medium' when pizza_id like '%l' then 'large' end as size
from order_details)
select size, count(size) as order_time from size group by 1 order by 2 desc limit 1;
-- 5. List the top 5 most ordered pizza types along with their quantities.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
select pizza_id,count(pizza_id) as quantity from order_details group by 1 order by 2 desc limit 5;
 
-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
select p.pizza_id,sum(o.quantity) as total_quantity from pizzas as p join order_details as o on p.pizza_id=o.pizza_id group by 1;
-- 7. Determine the distribution of orders by hour of the day.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
select time, case when hour(time) between 9 and 12 then 'morning' when hour(time) between 13 and 15 then 'afternoon' else 'evening'
end as distribution from orders;
-- 8. Join relevant tables to find the category-wise distribution of pizzas.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
select pi.category,sum(o.quantity) as total from pizza_types as pi join pizzas as p on pi.pizza_type_id=p.pizza_type_id join order_details as o
on p.pizza_id=o.pizza_id group by 1;
-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
select date, count(date)as count from orders group by 1;
select dayname(od.date),weekday(od.date) as weekday,round(avg(o.quantity),3) as avg from orders as od join order_details as o on od.order_id=o.order_id 
group by 1,2 order by weekday(od.date);
-- 10. Determine the top 3 most ordered pizza types based on revenue.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
select pi.name,(p.price) * (o.quantity) as revenue from pizza_types as pi join pizzas as p on pi.pizza_type_id=p.pizza_type_id join order_details as o
on p.pizza_id=o.pizza_id order by 2 desc limit 3;
-- 11. Calculate the percentage contribution of each pizza type to total revenue.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
-- revenue
with rev as(select pt.name as name,sum(p.price*o.quantity) as revenue from pizza_types as pt join pizzas as p on pt.pizza_type_id=p.pizza_type_id join
order_details as o on p.pizza_id=o.pizza_id group by pt.name),
-- total_revenue
total_rev as(select round(sum(revenue),2) as total_revenue from rev)
-- result
select name,concat(round(revenue*100/total_revenue,2),'','%') as percent from rev,total_rev order by 2 desc;
-- 12. Analyze the cumulative revenue generated over time.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
with timming as (select p.price * od.quantity as revenue, o.time,case when hour(time) between 9 and 12 then 'morning' 
when hour(time) between 13 and 15 then 'afternoon' else 'evening' end as distribution from pizzas as 
p join order_details as od on p.pizza_id=od.pizza_id join orders as o on od.order_id=o.order_id)
select distribution, round(sum(revenue),2) as total_revenue_over_time from timming group by 1;
-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;
select pi.name,pi.category, round(sum(p.price * o.quantity),2) as revenue from pizza_types as pi join pizzas as p on pi.pizza_type_id=p.pizza_type_id
join order_details as o on p.pizza_id=o.pizza_id group by 1,2 order by 3 limit 3;