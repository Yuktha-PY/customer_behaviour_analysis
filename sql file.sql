select * from updated_file;
-- what is total revenue genearted bu male vs female customers
select gender,sum(purchase_amount) as revenue from updated_file group by gender;
-- which customer used a discount but still spent more than average purxhase amount
select customer_id,purchase_amount from updated_file where discount_applied="Yes" AND purchase_amount>=(select avg(purchase_amount) from updated_file);
-- which are the top 5 products with the highest average review rating
select item_purchased, round(avg(review_rating),2) as Average_review_rating from updated_file group by item_purchased order by (avg(review_rating)) desc limit 5;
-- compare the average purchase amounts between standard and express shipping
select shipping_type ,round(avg(purchase_amount),2) from updated_file where shipping_type in("Standard","Express") group by shipping_type;
-- do subscribed customer spend more? compare average spend and total revenue between subscribers and non-subscribers
select subscription_status,count(customer_id),avg(purchase_amount) as spend ,sum(purchase_amount) as total_revenue from updated_file group by subscription_status order by total_revenue , spend desc;
-- which 5 products have the highest percentage of purchase with discounts applied
select item_purchased , Round(100* sum( case when discount_applied="Yes" then 1 else 0 end)/count(*),2)as discount_rate from updated_file group by item_purchased order by discount_rate desc limit 5;
-- segment the customers into new ,returning ,loyal based on their total number of previous purchase and show the count of each segment
 with customer_type as(
 select customer_id,previous_purchases,
 case when previous_purchases=1 then "New"
      when previous_purchases between 2 and 10 then "Returning"
      else "loyal"
      end as customer_segment
from updated_file
)
select customer_segment ,count(*) as"Number of customers" from customer_type group by customer_segment;
-- what are the top 3 most purchased product within each category
with item_counts as(
select category,item_purchased,count(customer_id) as total_order,
row_number() over(partition by category order by count(customer_id) desc) as item_rank 
from updated_file
group by category,item_purchased
)
select item_rank ,category,item_purchased ,total_order from item_counts where item_rank<=3;
-- are customers who are repeat buyers(more than 5 pervious purchases) also likely to subscribe?
select subscription_status, count(customer_id) from updated_file where previous_purchases>5 group by subscription_status;
-- what is the revenue contribution of the each age group?
select age_group ,sum(purchase_amount) as total_revenue from updated_file group by age_group order by total_revenue desc;
