# Pizza Analysis
![image](https://github.com/user-attachments/assets/a272ad93-c434-4bdf-8e7c-ef99406304d1)

## Table of Contents
- [Introduction](#Introduction)
- [Dataset Overview](#Dataset-Overview)
- [Data Cleaning and Transformation](#Data-Cleaning-and-Transformation)
- [Data Exploration and Insight](#Data-Exploration-and-Insight)
- [Recommendation](#Recommendation)
- [Conclusion](#Conclusion)

  ### Introduction
  In this presentation, I’ll walk you through my analysis of pizza data, where I examined several aspects including ingredient combinations, pricing patterns, sales performance, and customer preferences. The goal was to identify trends and insights that could help improve product offerings or marketing strategies. To achieve this, I used SQL with a focus on subqueries and Common Table Expressions (CTEs), which allowed me to break down complex queries and structure the analysis more efficiently. Let’s explore the key findings and what they reveal about the pizza business.

  ### Dataset Overview
  The dataset I used for this analysis is composed of four interconnected tables: orders, order_details, pizzas, and pizza_types. The orders table contains information about each transaction, including order ID and date and time. Order_details breaks down each order into specific pizza items and quantities. The pizzas table includes details such as pizza size and price, while pizza_types provides information on the pizza category, name, and ingredients. Together, these tables form a comprehensive view of customer behavior, product variety, and sales performance, allowing for detailed analysis using joins, subqueries, and CTEs.

    The dataset I used for this analysis is composed of four interconnected tables: orders, order_details, pizzas, and pizza_types. The orders table contains 21,350 rows, each representing a unique transaction with details such as order ID and date. The order_details table is the largest, consisting of 48,620 rows, and it breaks down each order into individual pizza items and quantities. The pizzas table contains 96 rows, providing details on the available pizza sizes and prices. The pizza_types table consists of 32 rows, describing each pizza’s name, category, and ingredients. Combined, these tables form a well-structured dataset that enables a comprehensive analysis of customer behavior, sales trends, and product performance. For this project, I used SQL—leveraging joins, subqueries, and Common Table Expressions (CTEs)—to extract and interpret the data effectively.

### Data Cleaning and Transformation
1. Importing the large csv file.
- order.csv file.

```sql
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\orders.csv'
into table orders
fields terminated by ','
enclosed by ''
lines terminated by '\r\n'
ignore 1 lines;
```
- order_details.csv file
```sql
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\order_details.csv'
into table order_details
fields terminated by ','
enclosed by ''
lines terminated by '\r\n'
ignore 1 lines;
```
2. Handling missing value from the four(4) tables.
```sql
select * from pizzas where pizza_id is null or pizza_type_id is null or size is null or price is null;
select * from pizza_types where pizza_type_id is null or name is null or category is null or ingredients is null;
select * from order_details where order_details_id is null or order_id is null or pizza_id is null or quantity is null;
select * from orders where order_id is null or date is null or time is null;
```
3. Checking for Duplicates record in orders table.
```sql
select order_id, count(*) from orders group by 1 having count(*) >1;
```

### Data Exploration and Insight
1. Retrieve the total number of orders placed.
```sql
select count(*) as total_number from orders;
```
Insight: There are 21,350 orders placed.

2. Calculate the total revenue generated from pizza sales.
```sql
select round(sum(p.price * o.quantity),2) as total_revenue from pizzas as p join order_details as o on p.pizza_id=o.pizza_id;
```
Insight: The total revenue is #817,860.05

3. Identify the highest-priced pizza.
```sql
select pi.name,p.price from pizza_types as pi join pizzas as p on pi.pizza_type_id=p.pizza_type_id order by 2 desc limit 1;
```
Insight: The Highest priced pizza is The Greek Pizza with a priced tag of #35.95

4. Identify the most common pizza size ordered.
```sql
with size as (select pizza_id,case when pizza_id like '%s' then 'small' when pizza_id like '%m' then 'medium' when pizza_id like '%l' then 'large' end as size
from order_details)
select size, count(size) as order_number from size group by 1 order by 2 desc limit 1;
```
Insight: The most common pizza type order is Large size ordered 19,098 times.

5. List the top 5 most ordered pizza types along with their quantities.
```sql
select pizza_id,count(pizza_id) as quantity from order_details group by 1 order by 2 desc limit 5;
```
 Insight: They are

 - big_meat_s ordered 1811 times.
 - thai_ckn_l ordered 1365 times.
 - five_cheese_l ordered 1359 times.
 - four_cheese_l ordered 1273 times.
 - classic_dlx_m ordered 1159 times.

6. Join the necessary tables to find the total quantity of each pizza category ordered.
```sql
select pi.category,sum(o.quantity) as total_quantity from pizza_types as pi join pizzas as p on pi.pizza_type_id=p.pizza_type_id
join order_details as o on p.pizza_id=o.pizza_id group by 1;
```
Insght: They are

- Classic ordered 14888 times.
- Veggie ordered 11649 times.
- Supreme ordered 11987 times.
- Chicken ordered 11050 times.

7. Determine the distribution of orders by hour of the day.
```sql
with timming as(select time, case when hour(time) between 9 and 12 then 'morning' when hour(time) between 13 and 15 then 'afternoon' else 'evening'
end as distribution from orders)
select distribution, count(distribution) as total from timming group by 1 order by 2 desc;
```
Insight: In the morning 3760 orders are make while 5395 orders are make in the afternoon and 12195 orders in the evening.

8. Group the orders by date and calculate the average number of pizzas ordered per day.
```sql
select dayname(od.date),weekday(od.date) as weekday,round(avg(o.quantity),3) as avg from orders as od join order_details as o on od.order_id=o.order_id 
group by 1,2 order by weekday(od.date);
```
Insight: On Monday the average number of pizzas order is 1.018, Tuesday have 1.021, Wednesday have 1.022,Thursday have 1.021, Friday have 1.017,Saturday have 1.019 and Sunday have 1.02. 

9. Determine the top 3 most ordered pizza types based on revenue.
```sql
select pi.name,(p.price) * (o.quantity) as revenue from pizza_types as pi join pizzas as p on pi.pizza_type_id=p.pizza_type_id join order_details as o
on p.pizza_id=o.pizza_id order by 2 desc limit 3;
```
Insight: The result are

- The California Chicken Pizza with a revenue of #83.
- The Prosciutto and Arugula Pizza with a revenue of #62.25.
- The Barbecue Chicken Pizza with a revenue of #62.25.

10. Calculate the percentage contribution of each pizza type to total revenue.
```sql
with rev as(select pt.name as name,sum(p.price*o.quantity) as revenue from pizza_types as pt join pizzas as p on pt.pizza_type_id=p.pizza_type_id join
order_details as o on p.pizza_id=o.pizza_id group by pt.name),
total_rev as(select round(sum(revenue),2) as total_revenue from rev)
select name,concat(round(revenue*100/total_revenue,2),'','%') as percent from rev,total_rev order by 2 desc;
```
Insight: The Thai Chicken Pizza have the highest percentage of 5.31%

11. Analyze the cumulative revenue generated over time.
```sql
with timming as (select p.price * od.quantity as revenue, o.time,case when hour(time) between 9 and 12 then 'morning' 
when hour(time) between 13 and 15 then 'afternoon' else 'evening' end as distribution from pizzas as 
p join order_details as od on p.pizza_id=od.pizza_id join orders as o on od.order_id=o.order_id)
select distribution, round(sum(revenue),2) as total_revenue_over_time from timming group by 1;
```
Insight: The total revenue generated in the morning is #157,200.35 while in the afternoon is #218,259.40 and the revenue generated at night is #442,400.30.

12. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
```sql
select pi.name,pi.category, round(sum(p.price * o.quantity),2) as revenue from pizza_types as pi join pizzas as p on pi.pizza_type_id=p.pizza_type_id
join order_details as o on p.pizza_id=o.pizza_id group by 1,2 order by 3 limit 3;
```
Insight: The most 3 ordered pizza are The Brie Carre Pizza, The Green Garden Pizza, The Spinach Supreme Pizza.

### Recommendation
📈 Business Recommendations Based on Most Common Pizza Size
1. Optimize Inventory for Top Size
  - Stock more dough, cheese, and boxes for the most popular size (e.g., Large).
  - Negotiate bulk supplier deals for these inputs to reduce cost per unit.

2. Bundle and Upsell with Popular Size
  - Create meal deals: “Buy a Large pizza, get 20% off on drinks or sides.”
  - Encourage larger purchases by bundling with the most favored size.

3. Introduce Premium Variants
  - If Large is dominant, offer “Gourmet Large” options at a premium.
  - Leverage popularity to raise average order value.

4. Right-Size Your Production
  - If Small or Medium are underperforming:
  - Reduce their production frequency to cut waste.
  - Consider merging the sizes into a single “Regular” option for simplicity.

5. Customize Marketing
  - Target ads and social media posts featuring the top-selling size.
  - Use customer feedback to understand why this size is preferred and highlight that in promotions.

6. Evaluate Price Sensitivity
  - If customers consistently choose Large, there may be room for a slight price increase without hurting demand.

7. Test Limited-Time Sizes
  - Try “Extra Large” or “Mini” for a limited time to gauge interest beyond standard sizes.

🍕 Business Recommendations Based on Most Ordered Pizza
1. Feature It as Your Signature Pizza
  - Promote it front and center on your menu and website.
  - Brand it as a customer favorite (“#1 Seller” badge).

2. Create Bundles and Deals
  - Offer combos like “Pepperoni Pizza + 2 Drinks” at a slight discount.
  - Family packs with 2 large pepperoni pizzas + sides.

3. Use in Cross-Promotions
  - Feature it in app banners, delivery platforms, and loyalty programs.
  - “Get a free drink with every Pepperoni Pizza” to drive repeat orders.

4. Leverage for Feedback & Innovation
  - Ask frequent buyers what they love about it and how it could be improved.
  - Use insights to inspire new menu items.

5. Price Optimization
  - If demand is strong and inelastic, test a small price increase.
  - Alternatively, create a lower-cost mini version to attract budget-conscious customers.

### Conclusion
Based on the analysis of our pizza orders, The California Chicken Pizza has emerged as the most frequently ordered item. This insight opens up numerous opportunities to optimize operations, enhance customer satisfaction, and boost profitability:
  - Optimizing Inventory: Stocking up on ingredients for our most popular pizza ensures we can meet demand efficiently while reducing waste.
  - Strategic Marketing & Sales: Featuring The California Chicken Pizza prominently in promotions and bundles can increase visibility, attract new customers, and encourage repeat orders.
  - Innovating with Variants: Offering creative spins on the best-seller, such as limited-time options or premium variants, keeps the menu fresh and engages loyal customers.
  - Price Optimization: With consistent demand, we can explore minor price adjustments or offer value-driven bundles to enhance average order value.

By capitalizing on these insights, we can continue to provide great value to our customers while driving operational efficiency and profitability.
