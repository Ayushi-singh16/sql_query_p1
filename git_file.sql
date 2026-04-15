--Data Exploration & Cleaning


SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

------------------------------------------------------------------------------------

select * from sales;

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from sales where sale_date='2022-11-05'

------Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from sales 
where
  category='Clothing'
  and
  quantity>=4
  and
  to_char(sale_date,'yyyy-mm')='2022-11'
---------
--ALTER TABLE sales
--RENAME COLUMN quantiy TO quantity;
--Write a SQL query to calculate the total sales (total_sale) for each category.:
select sum(total_sale) as total_sales,
category
from sales
group by 2
----Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select  avg(age),customer_id,category
from sales 
group by customer_id,category
having category='Beauty'

----Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from sales where total_sale>='1000'
----Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select count(transactions_Id),gender,category
from sales 
group by 2,3
------Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
with month_sale as
(select
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
extract(year from sale_date) as year
from sales
group by 1,3
order by 3,1,2
),
 year_sale as(
select month,
 year,
avg_sale,

rank()over(partition by year order by avg_sale desc) as rank
from month_sale

)
select * from year_sale
where
rank=1
-----Write a SQL query to find the top 5 customers based on the highest total sales
with rank as

(SELECT 
    customer_id,
    SUM(total_sale) AS total_sales,
    RANK() OVER (ORDER BY SUM(total_sale) DESC) AS rnk
FROM sales
GROUP BY customer_id)
select * FROM rank
where rnk<=5


--Write a SQL query to find the number of unique customers who purchased items from each category
select count(distinct(customer_id)),
category
from sales
group by 2
--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17
with hourly_sale as(
select *,
case
when extract(hour from sale_time) <12 then 'morning'
when extract(hour from sale_time) between 12 and 17 then 'afternoon'
else 'evening'
end as shift
from sales
)
select shift,
count(*) as total_order
from hourly_sale
group by 1