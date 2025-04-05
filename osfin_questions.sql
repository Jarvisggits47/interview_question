USE practice;
CREATE TABLE expenses (
    id INT PRIMARY KEY,
    amount DECIMAL(10,2),
    transaction_date TIMESTAMP
);
CREATE TABLE income (
    id INT PRIMARY KEY,
    amount DECIMAL(10,2),
    transaction_date TIMESTAMP
);
INSERT INTO expenses (id, amount, transaction_date) VALUES
(1, 120.50, '2024-03-02 10:15:00'),
(2, 80.00,  '2024-03-15 18:30:00'),
(3, 50.25,  '2024-02-20 09:00:00'),
(4, 300.00, '2024-03-20 14:10:00'),
(5, 45.75,  '2024-03-25 11:00:00'),
(6, 60.00,  '2024-03-05 09:20:00'),
(7, 200.00, '2024-03-28 19:45:00'),
(8, 15.00,  '2024-04-01 08:00:00');

INSERT INTO income (id, amount, transaction_date) VALUES
(1, 1500.00, '2024-03-01 09:00:00'),
(2, 800.00,  '2024-03-18 12:30:00'),
(3, 500.00,  '2024-04-01 11:45:00'),
(4, 250.00,  '2024-03-10 16:10:00'),
(5, 100.00,  '2024-03-23 08:55:00'),
(6, 1200.00, '2024-02-25 14:30:00'),
(7, 400.00,  '2024-03-31 23:59:00');
SELECT *FROM expenses;
SELECT *FROM income;
SELECT
    'Expenses' AS category,
    COUNT(*) AS total_transactions,
    FORMAT(COALESCE(SUM(amount), 0), 2) AS total_amount
FROM expenses
WHERE MONTH(transaction_date) = 3 AND YEAR(transaction_date) = 2024
UNION ALL
SELECT
    'Income' AS category,
    COUNT(*) AS total_transactions,
    FORMAT(COALESCE(SUM(amount), 0), 2) AS total_amount
FROM income
WHERE MONTH(transaction_date) = 3 AND YEAR(transaction_date) = 2024;


-- 1. Create Tables
CREATE TABLE customers1 (
    id INT PRIMARY KEY,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE income1 (
    id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers1(id)
);

CREATE TABLE expenses1 (
    id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers1(id)
);
SELECT *FROM customers1;
SELECT *FROM expenses1;
SELECT *FROM income1;
-- 2. Insert Sample Data

-- Customers
INSERT INTO customers1 (id, email) VALUES
(1, 'alice@example.com'),
(2, 'bob@example.com'),
(3, 'carol@example.com'),
(4, 'dave@example.com'),
(5, 'eva@example.com');

-- Income
INSERT INTO income1 (id, customer_id, amount) VALUES
(1, 1, 1000.00),
(2, 1, 500.00),
(3, 2, 800.00),
(4, 3, 200.00),
(5, 4, 1500.00),
(6, 5, 0.00);

-- Expenses
INSERT INTO expenses1 (id, customer_id, amount) VALUES
(1, 1, 1200.00),
(2, 1, 600.00),
(3, 2, 700.00),
(4, 3, 400.00),
(5, 4, 300.00),
(6, 5, 100.00);

-- 3. Final Query: Customers with Negative Balance Only



WITH balance_report AS (
    SELECT 
        c.email,
        ROUND(
            COALESCE(SUM(i.amount), 0) - COALESCE(SUM(e.amount), 0),
            2
        ) AS balance
    FROM customers1 c
    LEFT JOIN income1 i ON c.id = i.customer_id
    LEFT JOIN expenses1 e ON c.id = e.customer_id
    GROUP BY c.id, c.email
)
SELECT email, balance
FROM balance_report
WHERE balance < 0
ORDER BY email ASC;


-- 1. Create the traffic table
CREATE TABLE traffic (
    id INT PRIMARY KEY AUTO_INCREMENT,
    record_day DATE NOT NULL,
    count INT NOT NULL
);

-- 2. Insert sample data
INSERT INTO traffic (record_day, count) VALUES
('2017-01-01', 1200), ('2017-01-15', 1500), ('2017-01-20', 1300),
('2018-01-05', 1400), ('2018-01-25', 1600), ('2018-01-30', 1550), ('2018-01-12', 1500),
('2019-01-05', 1150), ('2019-01-10', 1250), ('2019-01-22', 1275), ('2019-01-28', 1350), ('2019-01-15', 1325),
('2020-01-02', 1300), ('2020-01-12', 1400), ('2020-01-18', 1420),
('2020-01-22', 1410), ('2020-01-26', 1440), ('2020-01-29', 1450),
('2017-02-01', 1000), ('2017-02-20', 1100), ('2017-02-25', 1050),
('2018-02-05', 1150), ('2018-02-15', 1200), ('2018-02-22', 1180), ('2018-02-18', 1220),
('2019-02-08', 1250), ('2019-02-12', 1230), ('2019-02-20', 1285),
('2019-02-24', 1295), ('2019-02-28', 1270),
('2020-02-03', 1300), ('2020-02-10', 1310), ('2020-02-15', 1325),
('2020-02-18', 1320), ('2020-02-21', 1330), ('2020-02-25', 1340);
SELECT *FROM traffic;
-- 3. Query: Monthly Median Per Year (Pivoted View)
WITH ranked_data AS (
    SELECT 
        MONTH(record_day) AS month,
        YEAR(record_day) AS year,
        count,
        ROW_NUMBER() OVER (PARTITION BY YEAR(record_day), MONTH(record_day) ORDER BY count) AS row_num,
        COUNT(*) OVER (PARTITION BY YEAR(record_day), MONTH(record_day)) AS total_rows
    FROM traffic
),
medians AS (
    SELECT 
        month,
        year,
        AVG(count) AS median
    FROM ranked_data
    WHERE row_num IN (
        FLOOR((total_rows + 1) / 2),
        CEIL((total_rows + 1) / 2)
    )
    GROUP BY month, year
)
SELECT 
    m.month,
    MAX(CASE WHEN year = 2017 THEN median END) AS median_2017,
    MAX(CASE WHEN year = 2018 THEN median END) AS median_2018,
    MAX(CASE WHEN year = 2019 THEN median END) AS median_2019,
    MAX(CASE WHEN year = 2020 THEN median END) AS median_2020
FROM medians m
GROUP BY m.month
ORDER BY m.month;
