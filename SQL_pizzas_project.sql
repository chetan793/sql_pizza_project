select * from orders;
select * from [dbo].[pizza_types]
 select * from [dbo].[pizzas]
 select * from [dbo].[order_details]

  
 -- Retrieve the total number of orders placed
 select count(distinct order_id) as 'Total Orders' from orders

 --caluulate the total Revenue genrated from pizza sales
 select order_details.pizza_id, order_details.quantity, pizzas.price
 from order_details
 join pizzas on pizzas.pizza_id = order_details.pizza_id

 --to get the answer
  select cast(sum(order_details.quantity* pizzas.price) as decimal(10,2)) as 'Total Revenue' 
 from order_details
 join pizzas on pizzas.pizza_id = order_details.pizza_id


 -- Identifyy the hihest price pizza
 -- using Top/limit function
 select top 1 pizza_types.name as 'pizza Name', cast(pizzas.price as decimal(10,2)) as 'price'
 from pizzas
 join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
 order by price desc

-- Identify the most common pizza size ordered
select pizzas.size, count(distinct order_id) as 'No of Orders', sum(quantity) as 'Total qty ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by count(distinct order_id) desc

-- list the 5 most ordered pizza types along with their qty
select top 5 pizza_types.name as 'Pizza', sum(quantity) as 'Total ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by sum(quantity) desc

-- join the necessary tables and the to find totals qty of each pizza category ordered
select top 5 pizza_types.category, sum(quantity) as 'Total qty ordered'
from order_details                                                  
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category
order by sum(quantity) desc

--determine the distribution of orders by hour of the day
--[ By analyzing this data, you can identify the busiest hours of the day and optimize your operations accordingly.
select datepart(hour, time) as 'Hour of the day', count(distinct order_id) as 'no of orders'
from orders 
group by datepart(hour, time)
order by [no of orders] desc 

-- find the category- wise distribution of pizzas
select category,
count(distinct pizza_type_id) as 'no_of_order'
from pizza_types
group by category
order by 'no_of_order' 

--calculate Avg number of pizzas orderd per day
with cte as(
select orders.date, sum(order_details.quantity) as 'Total pizza ordered that day'
from order_details
join orders on orders.order_id = order_details.order_id
group by orders.date
)
select avg([Total pizza ordered that day]) as [Avg number of pizza ordered per day] from cte
 
 --determine the top 3 most orderd pizza types based on Revenu
 select top 3 pizza_types.name, sum(order_details.quantity*pizzas.price) as 'Revenue from pizza'
 from order_details
 join pizzas on pizzas.pizza_id = order_details.pizza_id
 join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
 group by pizza_types.name
 order by [Revenue from pizza] desc
-- To get the total revenue
 select pizza_types.category,
 CONCAT(cast((sum(order_details.quantity*pizzas.price)/
 (select sum(order_details.quantity*pizzas.price) 
 from pizzas
 join order_details on order_details.pizza_id = pizzas.pizza_id
 )) *100 as decimal(10,2)), '%') as 'Revenue contribution  by pizza'
 from pizzas
  join order_details on order_details.pizza_id = pizzas.pizza_id
  join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
  group by pizza_types.category

  --Revenue contribution from each pizza by pizza name
 select pizza_types.name,
 CONCAT(cast((sum(order_details.quantity*pizzas.price)/
 (select sum(order_details.quantity*pizzas.price) 
 from pizzas
 join order_details on order_details.pizza_id = pizzas.pizza_id
 )) *100 as decimal(10,2)), '%') as 'Revenue contribution  by pizza'
 from pizzas
  join order_details on order_details.pizza_id = pizzas.pizza_id
  join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
  group by pizza_types.name
  order by [Revenue contribution  by pizza] desc
 
 --Analyze the cumulative revenue generated over time
 --use of aggregative window fun (to get the cumulative sum)
 with cte as (
 select date as 'date', cast(sum(order_details.quantity*pizzas.price) as decimal(10,2)) as Revenue
 from order_details
 join orders on orders.order_id = order_details.order_id
 join pizzas on pizzas.pizza_id = order_details.pizza_id
 group by date
 )
 select date, Revenue, sum(Revenue) over (order by date) as 'cumukative sum'
 from cte
 group by date, revenue
 -- category wise revenue genratted using cte temporary column name [category and name] 
  with cte as (
 select category, name, cast(sum(order_details.quantity*pizzas.price) as decimal(10,2)) as Revenue
 from order_details
 join pizzas on pizzas.pizza_id = order_details.pizza_id
 join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
 group by category, name















