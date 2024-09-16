create database mini_project;
CREATE TABLE t_tab1
	(
    ID INT UNIQUE,
    GOODS_TYPE VARCHAR (100),
    QUANTITY INT,
    AMOUNT INT,
    SELLER_NAME VARCHAR (100) 
    );

SELECT * FROM t_tab1;

INSERT INTO t_tab1 VALUES (1, "Mobile Phone", 2, 400000, "Mike");
INSERT INTO t_tab1 VALUES (2, "Keyboard", 1, 10000, "Mike");
INSERT INTO t_tab1 VALUES (3, "Mobile Phone", 1, 50000, "Jane");
INSERT INTO t_tab1 VALUES (4, "Monitor", 1, 110000, "Joe");
INSERT INTO t_tab1 VALUES (5, "Monitor", 2, 80000, "Jane");
INSERT INTO t_tab1 VALUES (6, "Mobile Phone", 1, 130000, "Joe");
INSERT INTO t_tab1 VALUES (7, "Mobile Phone", 1, 60000, "Anna");
INSERT INTO t_tab1 VALUES (8, "Printer", 1, 90000, "Anna");
INSERT INTO t_tab1 VALUES (9, "Keyboard", 2, 10000, "Anna");
INSERT INTO t_tab1 VALUES (10, "Printer", 1, 80000, "Mike");


CREATE TABLE t_tab2
	(
    ID INT UNIQUE,
    NAME VARCHAR(30),
    SALARY INT,
    AGE INT
    );
    
SELECT * FROM t_tab2;

INSERT INTO t_tab2 VALUES (1, "Anna", 110000, 27);
INSERT INTO t_tab2 VALUES (2, "Jane", 80000, 25);
INSERT INTO t_tab2 VALUES (3, "Mike", 120000, 25);
INSERT INTO t_tab2 VALUES (4, "Joe", 70000, 24);
INSERT INTO t_tab2 VALUES (5, "Rita", 120000, 29);



#1. Напишите запрос, который вернёт список уникальных категорий товаров (GOODS_TYPE). 
#Какое количество уникальных категорий товаров вернёт запрос?
SELECT DISTINCT GOODS_TYPE 
FROM t_tab1;				-- запрос вернул 4 типа уникальных товаров


#2.Напишите запрос, который вернет суммарное количество и суммарную стоимость проданных мобильных телефонов. 
#Какое суммарное количество и суммарную стоимость вернул запрос?
SELECT SUM(quantity) as sum_sales, SUM(amount) as sum_price
FROM t_tab1
WHERE goods_type = "Mobile Phone";      -- запрос вернул суммарное количество - 5, суммарную сумму продаж 640000


#3. Напишите запрос, который вернёт список сотрудников с заработной платой > 100000. Какое кол-во сотрудников вернул запрос?
SELECT name 
FROM t_tab2
WHERE salary > 100000;     -- запрос вернул трех сотрудников


#4. Напишите запрос, который вернёт минимальный и максимальный возраст сотрудников, а также минимальную и максимальную заработную плату.
SELECT max(age) as max_age, min(age) as min_age, min(salary) as min_salary, max(salary) as max_salary
FROM t_tab2;

#5. Напишите запрос, который вернёт среднее количество проданных клавиатур и принтеров.
SELECT goods_type, AVG(quantity) as avg_q
FROM t_tab1
WHERE goods_type IN ("Keyboard", "Printer")
GROUP BY goods_type;


#6. Напишите запрос, который вернёт имя сотрудника и суммарную стоимость проданных им товаров.
SELECT seller_name, sum(amount) as sum
FROM t_tab1
GROUP BY seller_name;


#7. Напишите запрос, который вернёт имя сотрудника, тип товара, кол-во товара, стоимость товара, заработную плату и возраст сотрудника MIKE.
SELECT a.seller_name, a.goods_type, a.amount, b.salary, b.age
FROM t_tab1 a 
JOIN t_tab2 b on a.seller_name = b.name
WHERE a.seller_name = "Mike";


#8. Напишите запрос, который вернёт имя и возраст сотрудника, который ничего не продал. Сколько таких сотрудников?
SELECT b.name, b.age 
FROM t_tab2 b
LEFT JOIN t_tab1 a on b.name = a.seller_name
WHERE a.seller_name is null; 


#9.Напишите запрос, который вернёт имя сотрудника и его заработную плату с возрастом меньше 26 лет? 
#Какое количество строк вернул запрос?
SELECT name, age, salary
FROM t_tab2
WHERE age < 26;


#10. Сколько строк вернёт следующий запрос:
SELECT * FROM T_TAB1 t
JOIN T_TAB2 t2 ON t2.name = t.seller_name
WHERE t2.name = 'RITA';						-- нет строк т.к. Рита не сделала продаж, соответственно ее данных нет в 1 таблице


