# SQL Interview Questions – Osfin.ai Prep

A small set of real SQL interview questions recently encountered during an interview with **Osfin.ai**. Focused on practical logic, aggregations, and reporting.

## Tables Overview

You are working with the following tables:

### 1. `customers`
- `id` (INT, PK)
- `email` (VARCHAR)

### 2. `income`
- `id` (INT, PK)
- `customer_id` (FK → customers.id)
- `amount` (DECIMAL)
- `transaction_date` (TIMESTAMP)

### 3. `expenses`
- `id` (INT, PK)
- `customer_id` (FK → customers.id)
- `amount` (DECIMAL)
- `transaction_date` (TIMESTAMP)

---

## Question 1

Write a SQL query to list customers with a negative balance, based on the difference between their total income and total expenses.  
Show the result with columns: `email`, `balance`  
Round the balance to 2 decimal places  
Sort the result by `email` in ascending order

---

## Question 2

Write a SQL query to show the total number of transactions and total amount for income and expenses for the month of March 2024.  
Display columns: `category`, `total_transactions`, `total_amount`  
Format the total amount to 2 decimal places

---

## Question 3

You are given a `traffic` table with the following structure:

### `traffic`
- `id` (INT, PK)
- `record_day` (DATE)
- `count` (INT)

Write a SQL query to calculate the **monthly median** of `count` for each year.  
Return a pivoted result with one row per month, and columns:  
`month`, `median_2017`, `median_2018`, `median_2019`, `median_2020`  
Order the result by month (1–12)

---

> ✅ These questions test real-world SQL: window functions, aggregation logic, and analytical reporting.

