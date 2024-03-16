# Case Study #3 - Foodie-Fi :avocado: 

## Introduction

Danny realised that he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!
Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

This case study focuses on using subscription style digital data to answer important business questions.

Full description: [Case Study #3 - Foodie-Fi](https://8weeksqlchallenge.com/case-study-3/)

## Case Study Questions

### A. Customer Journey

#### 1. Based off the 8 sample customers provided in the sample from the `subscriptions` table, write a brief description about each customer’s onboarding journey.
#### Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

The sample table has plan IDs, join the plan table to show plan names.

- Customer with ID 1 started with a trial subscription and continued with a basic monthly subscription in 7 days after sign-up

- Customer with ID 2 started with a trial subscription and continued with a pro annual subscription in 7 days after sign-up

- Customer with ID 11 started with a trial subscription and has churned in 7 days after sign-up

- Customer with ID 13 started with a trial subscription, then purchased a basic monthly subscription in 7 days after sign-up and in 7 days after that has upgraded to a pro monthly subscription

- Customer with ID 15 started with a trial subscription, purchased a basic monthly subscription in 7 days after sign-up and has churned in a month

- Customer with ID 16 started with a trial subscription, purchased a basic monthly subscription in 7 days after sign-up and in 4 months after that has ugraded to a pro annual subscription

- Customer with ID 18 started with a trial subscription and continued with a pro monthly subscription in 7 days after sign-up

- Customer with ID 19 started with a trial subscription, continued with a pro monthly subscription in 7 days after sign-up and has upgraded to pro annual subscpription in 2 months

### B. Data Analysis Questions

#### 1. How many customers has Foodie-Fi ever had?

````sql
    SELECT
      COUNT(distinct customer_id) AS total_number_of_customers
    FROM
      subscriptions
````

| total_number_of_customers |
| ------------------------- |
| 1000                      |

