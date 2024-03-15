### 1.How many pizzas were ordered?
#### 1.Kaç tane pizza sipariş edildi?
```sql
select 
count(order_id) as pizza_count
from customer_orders
```


### 2.How many unique customer orders were made?
#### 2.Kaç tane benzersiz müşteri siparişi verildi?
```sql
SELECT
count(distinct customer_id) as unique_customer_count 
from customer_orders
```


### 3.How many successful orders were delivered by each runner?
Her koşucu tarafından kaç başarılı sipariş teslim edildi?
```sql
select runner_id,
count(order_id)
from runner_orders 
where pickup_time != 'null'
and distance != 'null'
and duration != 'null'
group by 1
```


--4)How many of each type of pizza was delivered?
--Her pizza türünden kaç adet teslim edildi?
select c.pizza_id,
p.pizza_name,
count(c.order_id)
from customer_orders as c left join pizza_names as p on p.pizza_id=c.pizza_id
                          left join runner_orders as r on r.order_id = c.order_id
WHERE
  pickup_time != 'null'
  AND distance != 'null'
  AND duration != 'null'
group by 1,2;



--5)How many Vegetarian and Meatlovers were ordered by each customer?
--Her müşteri kaç tane Vejetaryen ve Etsever sipariş etti?
select c.customer_id,
p.pizza_name,
count(order_id)
from customer_orders as c left join pizza_names as p on p.pizza_id=c.pizza_id
group by 1,2
order by 1;




--6)What was the maximum number of pizzas delivered in a single order?
--Tek bir siparişte teslim edilen maksimum pizza sayısı ne kadardı?
select 
c.order_id,
count(pizza_id) as pizzas_count
from customer_orders as c 
           left join runner_orders as r on r.order_id = c.order_id
WHERE
  pickup_time != 'null'
  AND distance != 'null'
  AND duration != 'null'
  group by 1
  order by 2 desc
  limit 1;


--7)For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
--Her müşteri için teslim edilen pizzalardan kaç tanesinde en az 1 değişiklik vardı ve kaç tanesinde değişiklik yoktu?
  SELECT
    customer_id,
    CASE
      WHEN exclusions != '' AND exclusions != 'null' THEN exclusions
      ELSE 'No exclusions'
    END AS exclusions,
    CASE
      WHEN extras != '' AND extras != 'null' THEN extras
      ELSE 'No extras'
    END AS extras,
    COUNT(c.order_id) AS number_of_pizzas
  FROM
    customer_orders AS c
    JOIN runner_orders AS r ON c.order_id = r.order_id
  WHERE
    pickup_time != 'null'
    AND distance != 'null'
    AND duration != 'null'
  GROUP BY
    customer_id,
    exclusions,
    extras
	order by customer_id




--8)How many pizzas were delivered that had both exclusions and extras?
--Hem istisnalar hem de ekstralar içeren kaç pizza teslim edildi?
  SELECT
  CASE
    WHEN exclusions != '' and exclusions != 'null' THEN exclusions
    ELSE 'No exclusions'
  END AS exclusions,
  CASE
    WHEN extras != '' and extras!= 'null' THEN extras
    ELSE 'No extras'
  END AS extras,
  COUNT(c.order_id) AS number_of_pizzas
FROM
  customer_orders AS c
  JOIN runner_orders AS r ON c.order_id = r.order_id
WHERE
  pickup_time != 'null'
  AND distance != 'null'
  AND duration != 'null'
GROUP BY
  exclusions,
  extras;
--9)What was the total volume of pizzas ordered for each hour of the day?
--Günün her saati için sipariş edilen pizzaların toplam hacmi ne kadardı?

SELECT
  EXTRACT(HOUR FROM order_time) AS hour_of_day,
 count(order_id) AS total_pizzas
FROM
  customer_orders
WHERE
  order_time IS NOT NULL
GROUP BY
  hour_of_day
ORDER BY
hour_of_day;

--10)What was the volume of orders for each day of the week?
--Haftanın her günü için sipariş hacmi neydi?
select 
case when day_of_week=1 then 'Monday'
     when day_of_week =2 then 'Tuesday'
	 when day_of_week =3 then 'Wednesnday' --1ocak2020nin çarşambaya denk geldiğini sistem algılamış ve üstüne eklemiş 
	 when day_of_week =4 then 'Thursday'
	 when day_of_week =5 then 'Friday'
	 	 when day_of_week =6 then 'Saturday'
		 	 when day_of_week =0 then 'Sunday' end as days,
			 total_pizzas
			 from (
	
SELECT
  EXTRACT(DOW FROM order_time) AS day_of_week, --DOW, haftanın günlerini 0'dan 6'ya kadar temsil eder (Pazar'dan Cumartesi'ye kadar).
  count(order_id) AS total_pizzas
FROM
  customer_orders
WHERE
  order_time IS NOT NULL 
GROUP BY
  EXTRACT(DOW FROM order_time)
ORDER BY
  EXTRACT(DOW FROM order_time));
