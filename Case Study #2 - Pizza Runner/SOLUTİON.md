# Case Study #2 - Pizza Runner :pizza:

### Introduction

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

Full description: [Case Study #2 - Pizza Runner](https://8weeksqlchallenge.com/case-study-2/)

## Case Study Questions

### A. Pizza Metrics



### 1.How many pizzas were ordered?
- *Kaç tane pizza sipariş edildi?*
```sql
select 
count(order_id) as pizza_count
from customer_orders
```
| pizza_count |
| ----------- |
| 14          |

### 2.How many unique customer orders were made?
- *Kaç tane benzersiz müşteri siparişi verildi?*
```sql
SELECT
count(distinct customer_id) as unique_customer_count 
from customer_orders
```
| unique_customer_count |
| --------------------- |
| 5                     |

### 3.How many successful orders were delivered by each runner?
- *Her koşucu tarafından kaç başarılı sipariş teslim edildi?*
```sql
select runner_id,
count(order_id) as delivered_orders
from runner_orders 
where pickup_time != 'null'
and distance != 'null'
and duration != 'null'
group by 1
order by 1
```
| runner_id | delivered_orders |
| --------- | ---------------- |
| 1         | 4                |
| 2         | 3                |
| 3         | 1                |

### 4.How many of each type of pizza was delivered?
- *Her pizza türünden kaç adet teslim edildi?*
````sql
select c.pizza_id,
p.pizza_name,
count(c.order_id) as number_of_pizzas_delivered
from customer_orders as c left join pizza_names as p on p.pizza_id=c.pizza_id
                          left join runner_orders as r on r.order_id = c.order_id
WHERE
  pickup_time != 'null'
  AND distance != 'null'
  AND duration != 'null'
group by 1,2;

````
|pizza_id| pizza_name | number_of_pizzas_delivered |
|--------| ---------- | -------------------------- |
|    1   | Meatlovers | 9                          |
|    2   | Vegetarian | 3                          |

### 5.How many Vegetarian and Meatlovers were ordered by each customer?
- *Her müşteri kaç tane Vejetaryen ve Etsever sipariş etti?*
````sql
select c.customer_id,
p.pizza_name,
count(order_id) as number_of_pizzas_delivered
from customer_orders as c left join pizza_names as p on p.pizza_id=c.pizza_id
group by 1,2
order by 1;
````
  
| customer_id | pizza_name | number_of_pizzas_delivered |
| ----------- | ---------- | -------------------------- |
| 101         | Meatlovers | 2                          |
| 101         | Vegetarian | 1                          |
| 102         | Meatlovers | 2                          |
| 102         | Vegetarian | 1                          |
| 103         | Meatlovers | 3                          |
| 103         | Vegetarian | 1                          |
| 104         | Meatlovers | 3                          |
| 105         | Vegetarian | 1                          |


### 6.What was the maximum number of pizzas delivered in a single order?
- *Tek bir siparişte teslim edilen maksimum pizza sayısı ne kadardı?*
````sql
select 
c.order_id,
count(pizza_id) as items_in_order
from customer_orders as c 
           left join runner_orders as r on r.order_id = c.order_id
WHERE
  pickup_time != 'null'
  AND distance != 'null'
  AND duration != 'null'
  group by 1
  order by 2 desc
  limit 1;
 ````
| order_id | items_in_order |
| -------- | -------------- |
| 4        | 3              |

### 7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
- *Her müşteri için teslim edilen pizzalardan kaç tanesinde en az 1 değişiklik vardı ve kaç tanesinde değişiklik yoktu?*
````sql
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


````
| customer_id |  exclusions   |  extras   | number_of_pizzas|
| ----------- | ------------  | --------- | ----------------|
|   101	      | No exclusions | No extras |	2           |
|   102	      | No exclusions |	No extras |	1           |
|   102	      | No exclusions | No extras |	1           |
|   102	      | No exclusions | No extras |     1           |
|   103	      |     4         | No extras |	3           |
|   104	      | No exclusions | No extras |	1           |
|   104	      |     2, 6      |  1, 4	  |     1           |
|   104	      | No exclusions |	   1	  |     1           |
|   105	      | No exclusions |	   1	  |     1           |
### 8.How many pizzas were delivered that had both exclusions and extras?
- *Hem istisnalar hem de ekstralar içeren kaç pizza teslim edildi?*
````sql
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
````
|   exclusions  |   extras    | number_of_pizzas |
| ------------- | ----------- | ---------------- |
|     2, 6      |     1, 4    |       1          |
|      4        |  No extras  |       3          |
| No exclusions |    1        |       2          |
| No exclusions |  No extras  |       3          |
| No exclusions |  No extras  |       2          |
| No exclusions |  No extras  |       1          |

- *So,We only see this situation in a one pizza order*

### 9.What was the total volume of pizzas ordered for each hour of the day?
- *Günün her saati için sipariş edilen pizzaların toplam hacmi ne kadardı?*
````sql

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
````
| hour_of_day | total_pizzas |
| ----------  | -------------|
|    11       |      1       |
|    13       |      3       |
|    18       |      3       |
|    19       |      1       |
|    21       |      3       |
|    23       |      3       |

### 10.What was the volume of orders for each day of the week?
- *Haftanın her günü için sipariş hacmi neydi?*
````sql
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
EXTRACT(DOW FROM order_time))
````
|     days    | total_pizzas   |
| ----------- | -------------- |
| Wednesnday  | 5              |
| Thursday    | 3              |
| Friday      | 1              |
| Saturday    | 5              |
