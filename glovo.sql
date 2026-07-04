select * from orders_details;
-- Which top 10 areas generated the highest revenue
select area, 
	sum(order_total) as total_revenue
from orders_details
	group by area
	order by total_revenue desc
	limit 10
;
-- Which customer segment has the highest average order value and total profit
SELECT customer_segment, max(avg_order_value) as avg_order_value, sum(total_profit) as total_profit
from orders_details
	group by customer_segment
	order by total_profit desc
;
-- For each month, what were the total order, revenue and profit?
select 
	month(order_date) as month,
	count(order_id) as total_order, 
	sum(order_total) as total_revenue,
    sum(total_profit) as total_profit
from orders_details
group by month(order_date)
order by month
;
-- Which payment method contributes the highest total revenue and average order value
select payment_method, sum(order_total) as total_revenue, avg(avg_order_value) as avg_order
from orders_details
group by payment_method
order by total_revenue desc
;
-- Which areas have an average delivery time above the overall average delivery time
select area, avg(delivery_time_minutes) as avg_delivery_time
from orders_details 
group by area 
having avg(delivery_time_minutes)>
(
	select avg(delivery_time_minutes)
    from orders_details
)
order by avg_delivery_time desc
;
-- Rank customers segment by total profit (using SQL ranking functions)
select customer_segment,
sum(total_profit) as total_profit,
rank() over(
        order by sum(total_profit) desc)
as rank_no
from orders_details
group by customer_segment
;
-- Which delivery partners handled the most orders and what was their average delivery time and average customer rating
select
	delivery_partner_id, 
	count(order_id) as total_orders,
    avg(delivery_time_minutes) as avg_delivery_time,
    avg(rating) as avg_customer_rating
from orders_details
group by delivery_partner_id
order by total_orders desc
;
--  How does customer rating differ between on-time and delayed deliveries
select delivery_status_x,
	avg(rating) as avg_rating,
    count(order_id) as total_orders
from orders_details
group by delivery_status_x
;
-- Which customers have placed more orders than the average customer and generated above revenue
select customer_name, total_orders, order_total
	from orders_details
	where total_orders >
(
	select avg(total_orders)
	from orders_details
)
and order_total >
(
select avg(order_total)
from orders_details
)
order by order_total
;

