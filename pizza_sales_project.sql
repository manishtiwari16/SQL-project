create database pizaa_sales


select * from orders
select * from pizzas
select * from order_details
select * from pizza_types


select * from order_details where pizza_id in  (select pizza_id from pizzas where size='M') 
select * from order_details where exists (select * from pizzas where order_details.pizza_id=pizzas.pizza_id)

select 



--basic
--1
select count(order_id) as total_orders from orders

--2
select round(sum(price*quantity),2) from pizzas 
join order_details on pizzas.pizza_id=order_details.pizza_id





--3
select top 1 pizza_id,round(max(price),0)as seq_price from pizzas group by pizza_id order by seq_price desc


--4
select pizzas.size,count(pizzas.size) from pizzas
join order_details on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size





--5

select pizza_types.name,count(order_details.quantity)as quantity from pizzas
join order_details on pizzas.pizza_id=order_details.pizza_id
join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
group by pizza_types.name 
order by quantity desc



--intermediat
select * from orders
select * from order_details
select * from pizzas
select * from pizza_types




--1 join the necessary table to find the total quantity of each category pizza
select pizza_types.category,count(order_details.quantity)as cat_quantity from pizzas
join order_details on pizzas.pizza_id=order_details.pizza_id
join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
group by pizza_types.category
order by cat_quantity desc



--determine the distribution of orders by each hour of the day
select datepart(hour,time)as hour,count(order_id) as total_orders from orders group by datepart(hour,time)
order by datepart(hour,time) desc



--join the relevent tables to find the category wise distribution of pizzas
select category,count(pizza_type_id) as pizza_type from pizza_types group by category order by category




--group the orders by date and calculate the average number of pizzas ordered per day
select avg(quantitty) from
(select date,count(order_details.quantity) as quantitty from order_details
join orders on order_details.order_id=orders.order_id
group by date) as data



--determine the top 3 most ordered pizza type based on revenue
select top 3 pizza_types.name, round(sum(order_details.quantity*pizzas.price),0)as revenue from order_details
join pizzas on order_details.pizza_id=pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
group by pizza_types.name
order by revenue desc



--advanced
--calculate the percentage of each pizza type in total revenue 
select * from orders
select * from order_details
select * from pizzas
select * from pizza_types


--analyse the cumulative revenue genrerated over time
select * from orders
select * from order_details
select * from pizzas
select * from pizza_types



select date,
sum(revenue) over(order by date) as cum_revenue from
(select date,round(sum(pizzas.price*order_details.quantity),0)as revenue from pizzas
join order_details on pizzas.pizza_id=order_details.pizza_id
join orders on order_details.order_id=orders.order_id
group by date
order by date) as sales



--determine the top 3 most ordered pizza types based on revenue for each pizza category
select top 3 pizza_types.name, round(sum(order_details.quantity*pizzas.price),0)as sales from order_details
join pizzas on order_details.pizza_id=pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
group by pizza_types.name
order by sales desc