--1)Her müşterinin restoranda harcadığı toplam tutar nedir?

select * from members;
select * from menu;
select * from sales;
--sadece kişi bazında 
select customer_id,
sum(price)
from menu as  m
left join sales as s on m.product_id = s.product_id
group by 1
order by 1;
--hem kişi bazında hem de genel toplam
SELECT
    s.customer_id,
    SUM(m.price) AS total_price,
    (SELECT SUM(price) FROM
    menu AS m
LEFT JOIN
    sales AS s ON m.product_id = s.product_id) AS total_sales
FROM
    menu AS m
LEFT JOIN
    sales AS s ON m.product_id = s.product_id
GROUP BY
    s.customer_id;
	--toplam harcamalar kişi bazlı değil
select sum(price) from menu as  m
left join sales as s on m.product_id = s.product_id;

--2)Her müşteri restoranı kaç gün ziyaret etti?
select customer_id,
count(distinct order_date)
from sales
group by 1;

select * from members;
select * from menu;
select * from sales;
--3)Her müşterinin satın aldığı menüden ilk ürün neydi?
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
select m.product_name,
count(s.product_id)
from menu as  m
left join sales as s on m.product_id = s.product_id
group by 1
limit 1;


--5)Her müşteri için en popüler ürün hangisiydi?

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

select * from members;
select * from menu;
select * from sales;

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
select customer_id,
sum(case when m.product_name = 'sushi' then price*20 else price*10 end ) as last_total
FROM
        menu AS m
    LEFT JOIN
        sales AS s ON m.product_id = s.product_id
group by 1


--10)Bir müşteri programa katıldıktan sonraki ilk haftada (katılma tarihi dahil) yalnızca suşide değil,
--tüm yiyeceklerde 2 kat puan kazanır - A ve B müşterisi Ocak ayının sonunda kaç puana sahip olur?
select customer_id,
order_date,
join_date,
product_id
case when join_date<=order_date then price



