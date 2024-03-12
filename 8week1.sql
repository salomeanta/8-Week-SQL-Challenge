--1)Her müşterinin restoranda harcadığı toplam tutar nedir?
--What is the total amount each customer spent at the restaurant?
select customer_id,
sum(price) as total_sales
from menu as  m
left join sales as s on m.product_id = s.product_id
group by 1
order by 1;

--2)Her müşteri restoranı kaç gün ziyaret etti?
--How many days has each customer visited the restaurant?
select customer_id,
count(distinct order_date)
from sales
group by 1;

--3)Her müşterinin satın aldığı menüden ilk ürün neydi?
--What was the first item from the menu purchased by each customer?
with sıralama as(
select customer_id,
product_name,
rank () over (partition by customer_id order by order_date ) as order_rank
from menu as  m
left join sales as s on m.product_id = s.product_id
)
select customer_id,
product_name
from sıralama 
where order_rank =1;


--4)Menüde en çok satın alınan ürün hangisidir ve tüm müşteriler tarafından kaç kez satın alınmıştır?
--What is the most purchased item on the menu and how many times was it purchased by all customers?
select m.product_name,
count(s.product_id)
from menu as  m
left join sales as s on m.product_id = s.product_id
group by 1
limit 1;


--5)Her müşteri için en popüler ürün hangisiydi?
--Which item was the most popular for each customer?

WITH Popularity AS (
    SELECT
        customer_id,
        product_name,
        COUNT(s.product_id) AS sales_count,
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
    sales_count
FROM
    Popularity
WHERE
    product_rank = 1;

--6)Müşteri üye olduktan sonra ilk olarak hangi ürünü satın aldı?
--Which item was purchased first by the customer after they became a member?


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
		where order_rank =1;





--7)Müşteri üye olmadan hemen önce hangi ürün satın alındı?
--Which item was purchased just before the customer became a member?
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
	where order_date < join_date
) 
		select customer_id,
		product_name
		from order_ranking
		where order_rank =1;

--8)Her üyenin üye olmadan önce harcadığı toplam kalem ve tutar nedir?
--What is the total items and amount spent for each member before they became a member?
select s.customer_id,
sum(m.price) as total_sales,
count(s.product_id)
FROM
        menu AS m
    LEFT JOIN
        sales AS s ON m.product_id = s.product_id
	join members as me on me.customer_id = s.customer_id
	where order_date < join_date
	group by 1;
	
--9)Harcanan her 1 dolar 10 puana eşitse ve suşi 2 kat puan çarpanına sahipse, her müşterinin kaç puanı olur?
--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select customer_id,
sum(case when m.product_name = 'sushi' then price*20 else price*10 end ) as last_total
FROM
        menu AS m
    LEFT JOIN
        sales AS s ON m.product_id = s.product_id
group by 1;


--10)Bir müşteri programa katıldıktan sonraki ilk haftada (katılma tarihi dahil) yalnızca suşide değil,
--tüm yiyeceklerde 2 kat puan kazanır - A ve B müşterisi Ocak ayının sonunda kaç puana sahip olur?

--In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi 
--how many points do customer A and B have at the end of January?
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
group by 1,2,3,4) select customer_id,
sum(case when product_name='sushi' then total_price*20 
     when order_date BETWEEN join_date AND join_date + INTERVAL '6' DAY then total_price*20
	 else total_price*10 end) as last_total_price
	 from data
group by 1
