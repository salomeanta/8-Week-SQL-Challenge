# Case Study #1 - Danny's Diner :ramen:

## Problem Statement

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers. 

Full description: [Case Study #1 - Danny's Diner](https://8weeksqlchallenge.com/case-study-1/)

## Case Study Questions

Each of the following case study questions can be answered using a single SQL statement. I'll mostly use two queries for convenience purposes.

### 1.What is the total amount each customer spent at the restaurant?
#### *1.Her müşterinin restoranda harcadığı toplam tutar nedir?*
```sql
select customer_id,
sum(price) as total_spent
from menu as  m
left join sales as s on m.product_id = s.product_id
group by 1
order by 1
```
| customer_id | total_spent |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

---

### 2.How many days has each customer visited the restaurant?
#### *2.Her müşteri restoranı kaç gün ziyaret etti?*
```sql
select customer_id,
count(distinct order_date) as days_of_visiting
from sales
group by 1
```
  
| customer_id | days_of_visiting |
| ----------- | ---------------- |
| A           | 4                |
| B           | 6                |
| C           | 2                |
---

### 3.What was the first item from the menu purchased by each customer?
#### *3.Her müşterinin satın aldığı menüden ilk ürün neydi?*
```sql
WITH ranking AS (
    SELECT 
        customer_id,
        product_name,
        RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_rank
    FROM 
        menu AS m
    LEFT JOIN 
        sales AS s ON m.product_id = s.product_id
)
SELECT 
    customer_id,
    STRING_AGG(DISTINCT product_name, ', ') AS unique_products
FROM 
    ranking
WHERE 
    order_rank = 1
GROUP BY 
    customer_id
```
| customer_id | product_name | 
| ----------- | ------------ | 
| A           | sushi,curry  |      
| B           | curry        | 
| C           | ramen        | 
---
### 4.What is the most purchased item on the menu and how many times was it purchased by all customers?
#### *4.Menüde en çok satın alınan ürün hangisidir ve tüm müşteriler tarafından kaç kez satın alınmıştır?*
```sql
select m.product_name,
count(s.product_id) as total_purchase_quantity
from menu as  m
left join sales as s on m.product_id = s.product_id
group by 1
limit 1
```
| product_name | total_purchase_quantity |
| ------------ | ----------------------- |
| ramen        | 8                       |
---
### 5.Which item was the most popular for each customer?
#### *5.Her müşteri için en popüler ürün hangisiydi?*
```sql
WITH Popularity AS (
    SELECT
        customer_id,
        product_name,
        COUNT(s.product_id) AS total_purchase_quantity,
        RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(s.product_id) DESC) AS product_rank
    FROM
        menu AS m
    LEFT JOIN
        sales AS s ON m.product_id = s.product_id
    GROUP BY
        customer_id,
        product_name
)
SELECT
    customer_id,
    product_name,
    total_purchase_quantity
FROM
    Popularity
WHERE
    product_rank = 1
```
| customer_id | product_name | total_purchase_quantity |
| ----------- | ------------ | ----------------------- |
| A           | ramen        | 3                       |
| B           | sushi        | 2                       |
| B           | curry        | 2                       |
| B           | ramen        | 2                       |
| C           | ramen        | 3                       |
---
### 6.Which item was purchased first by the customer after they became a member?
#### *6.Müşteri üye olduktan sonra ilk olarak hangi ürünü satın aldı?*

```sql
with order_ranking as (
select s.customer_id,
s.product_id,
	product_name,
row_number() over (partition by s.customer_id order by order_date)as order_rank
FROM
        menu AS m
    LEFT JOIN
        sales AS s ON m.product_id = s.product_id
	join members as me on me.customer_id = s.customer_id
	where order_date >= join_date
) 
		select customer_id,
		product_name
		from order_ranking
		where order_rank =1
```
| customer_id |  product_name |
| ----------- |  ------------ |
| A           |  curry        |
| B           |  sushi        |
---
### 7.Which item was purchased just before the customer became a member?
#### *7.Müşteri üye olmadan hemen önce hangi ürün satın alındı?*

	``` sql
		WITH order_ranking AS (
    SELECT 
        s.customer_id,
        s.product_id,
        product_name,
        RANK() OVER (PARTITION BY s.customer_id ORDER BY order_date) AS order_rank
    FROM menu AS m
    LEFT JOIN 
        sales AS s ON m.product_id = s.product_id
    JOIN 
        members AS me ON me.customer_id = s.customer_id
    WHERE 
        order_date < join_date )
     SELECT 
    customer_id,
    STRING_AGG(product_name, ', ') AS product_name
    FROM order_ranking
    WHERE order_rank = 1
    GROUP BY 
    customer_id
    ```
| customer_id | product_name |
| ----------- | ------------ |
| A           | sushi,curry  |
| B           | sushi        |
---
### 8.What is the total items and amount spent for each member before they became a member?
#### *8.Her üyenin üye olmadan önce harcadığı toplam kalem ve tutar nedir?*
```sql
select s.customer_id,
sum(m.price) as total_purchase_amount,
count(s.product_id) as total_number_of_items
FROM
        menu AS m
    LEFT JOIN
        sales AS s ON m.product_id = s.product_id
	join members as me on me.customer_id = s.customer_id
	where order_date < join_date
	group by 1
	order by 1
```
| customer_id | total_number_of_items | total_purchase_amount |
| ----------- | --------------------- | --------------------- |
| A           | 2                     | 25                    |
| B           | 3                     | 40                    |
---
### 9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
#### *9.Harcanan her 1 dolar 10 puana eşitse ve suşi 2 kat puan çarpanına sahipse, her müşterinin kaç puanı olur?*
```sql
select customer_id,
sum(case when m.product_name = 'sushi' then price*20 else price*10 end ) as points
FROM
        menu AS m
    LEFT JOIN
        sales AS s ON m.product_id = s.product_id
group by 1
order by 1
```

| customer_id | points |
| ----------- | ------ |
| A           | 860    |
| B           | 940    |
| C           | 360    |
---
### 10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi how many points do customer A and B have at the end of January?
#### *10.Bir müşteri programa katıldıktan sonraki ilk haftada (katılma tarihi dahil) yalnızca suşide değil,tüm yiyeceklerde 2 kat puan kazanır.A ve B müşterisi Ocak ayının sonunda kaç puana sahip olur?*

```sql
with data as (
select s.customer_id,
me.join_date,
	m.product_name,
s.order_date,
sum(m.price) as total_price
FROM
        menu AS m
    LEFT JOIN
        sales AS s ON m.product_id = s.product_id
	 join members as me on me.customer_id = s.customer_id
		where EXTRACT(month FROM s.order_date) = 1
group by 1,2,3,4)
select customer_id,
sum(case when product_name='sushi' then total_price*20 
     when order_date BETWEEN join_date AND join_date + INTERVAL '6' DAY then total_price*20
	 else total_price*10 end) as last_total_price
	 from data
group by 1
order by 1
```
| customer_id | last_total_price |
| ----------- | ---------------- |
| A           |     1370         |
| B           |     820          |
