use pizzashop;

-- Q1 Retrieve the total number of orders placed.--
select count(order_id)  from orders;

-- Calculate the total revenue generated from pizza sales.--

select 
round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id;   

-- Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;




-- Identify the most common pizza size ordered.--

select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc limit 1;


-- List the top 5 most ordered pizza types along with their quantities.--

select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by quantity desc limit 5;


-- Join the necessary tables to find the total quantity of each pizza category
-- ordered.

SELECT pizza_types.category,SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN  pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
ORDER BY quantity ASC;


-- Q  Determine the distribution of orders by hour of the day.-- 

SELECT HOUR(order_time) as ordertime, COUNT(order_id) 
FROM orders
group by ordertime;


-- Q Join relevant tables to find the category-wise distribution of pizzas.-- 

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;



-- Group the orders by date and calculate the average number of pizzas ordered per day.

	SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizza_ordered_per_day
FROM
    (SELECT 
        orders.order_data, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_data) AS order_quantity;



-- Q Determine the top 3 most ordered pizza types based on revenue.--
SELECT 
    pizza_types.name, SUM(pizzas.price) AS most
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY most DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.-- 
 
SELECT 
    pizza_types.category, round((sum(order_details.quantity * pizzas.price))/ (select 
round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id)* 100,2) as pizza_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY pizza_revenue DESC ;


-- Analyze the cumulative revenue generated over time.


select order_data,
round(sum(revenue) over (order by order_data),2) cum_revenue
from
(select orders.order_data , sum(order_details.quantity * pizzas.price) as revenue
from order_details 
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
GROUP BY orders.order_data) as sales;




-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.


select name , revenue  from
(select category, name, revenue, rank() over(partition by category order by revenue desc) as rn
from
(SELECT 
    pizza_types.category, pizza_types.name  ,
    SUM(order_details.quantity * pizzas.price) AS revenue 
FROM
    pizza_types pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category, pizza_types.name) as a ) as b
where rn <= 3;


-- SELECT 
--     category,
--     pizzaname AS name,
--     revenue
-- FROM (
--     SELECT 
--         pizza_types.category,
--         pizza_types.name AS pizzaname,
--         SUM(order_details.quantity * pizzas.price) AS revenue,
--         RANK() OVER (PARTITION BY pizza_types.category ORDER BY SUM(order_details.quantity * pizzas.price) DESC) AS rn
--     FROM
--         pizza_types
--     JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
--     JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
--     GROUP BY pizza_types.category, pizza_types.name
-- ) AS ranked_pizzas
-- WHERE rn <= 3;










     
     
     
     
     
     
     
     
     
     
     
     
     
