-- 1. список клиентов с непрерывной историей за год, то есть каждый месяц на регулярной основе без пропусков за указанный годовой период,
-- средний чек за период с 01.06.2015 по 01.06.2016, средняя сумма покупок за месяц, количество всех операций по клиенту за период;
SELECT * FROM customer;
SELECT * FROM transactions;

SELECT t.ID_client
		, AVG(t.Sum_payment) as avg_check
        , AVG(c.Total_amount) as avg_month
        , COUNT(t.ID_client) as count_transactions
FROM transactions t 
JOIN customer c ON t.ID_client = c.ID_client
WHERE t.date_new BETWEEN '2015-06-01'
					AND '2016-06-01'
                    AND c.Tenure = 12
GROUP BY t.ID_client;


-- 2. информацию в разрезе месяцев:
-- средняя сумма чека в месяц;
-- среднее количество операций в месяц;
-- среднее количество клиентов, которые совершали операции;
-- долю от общего количества операций за год и долю в месяц от общей суммы операций;
-- вывести % соотношение M/F/NA в каждом месяце с их долей затрат;

SELECT month(t.date_new) as month
			, AVG(t.Sum_payment) as avg_payment_month
			, COUNT(t.Id_check) / COUNT(DISTINCT MONTH(t.date_new)) AS avg_count_transactions_month
			, COUNT(DISTINCT t.Id_client) / COUNT(DISTINCT MONTH(t.date_new)) AS avg_count_client_month
FROM transactions t
GROUP BY month;

SELECT MONTH(t.date_new) as month,
COUNT(t.Id_check) / (SELECT COUNT(Id_check) 
FROM transactions ) * 100 as transactions_share,
SUM(t.Sum_payment) / (SELECT SUM(Sum_payment) 
FROM transactions ) * 100 as payment_share
FROM transactions t
GROUP BY month
ORDER BY month;

SELECT MONTH(t.date_new) as month, 
	c.Gender, COUNT(t.ID_client) as count_clients, 
	COUNT(t.ID_client) / (SELECT COUNT(DISTINCT t2.ID_client) 
							FROM transactions t2) * 100 as client_share, 
	SUM(t.Sum_payment) / (SELECT SUM(t2.Sum_payment) 
							FROM transactions t2) * 100 as payment_share
FROM transactions t
JOIN customer c ON t.ID_client = c.ID_client
GROUP BY month, c.Gender
ORDER BY month;
            
            
            
-- 3. возрастные группы клиентов с шагом 10 лет и отдельно клиентов, у которых нет данной информации, 
-- с параметрами сумма и количество операций за весь период, и поквартально - средние показатели и %.
           
SELECT 
    CASE 
        WHEN c.Age IS NULL THEN 'Нет информации'
        WHEN c.Age BETWEEN 0 AND 9 THEN '0-9'
        WHEN c.Age BETWEEN 10 AND 19 THEN '10-19'
        WHEN c.Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN c.Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN c.Age BETWEEN 50 AND 59 THEN '50-59'
        WHEN c.Age BETWEEN 60 AND 69 THEN '60-69'
        WHEN c.Age BETWEEN 70 AND 79 THEN '70-79'
        ELSE '80+' 
    END AS Age_Group, 
    COUNT(t.ID_check) AS total_operations,  
    SUM(t.sum_payment) AS total_sum,  
    AVG(t.Sum_payment) AS avg_payment, 
    CONCAT(QUARTER(t.date_new), '-й квартал ', YEAR(t.date_new)) AS Quarter, 
    ROUND(SUM(t.Sum_payment) / (SELECT SUM(t2.Sum_payment) FROM transactions t2) * 100, 2) AS percentage_of_total
FROM customer c
JOIN transactions t ON c.ID_client = t.ID_client
GROUP BY Age_Group, Quarter 
ORDER BY Age_Group, Quarter;

                
                
                
	

