create database users_adverts;
create table users
	(date date,
    users_id varchar(100),
    view_adverts int
    );
    
select * from users;

#1. Напишите запрос SQL, выводящий одним числом количество уникальных пользователей в этой таблице в период с 2023-11-07 по 2023-11-15.
select distinct count(users_id) as count
from users
where date between "2023-11-07" and "2023-11-15";

#2. Определите пользователя, который за весь период посмотрел наибольшее количество объявлений.
select users_id, sum(view_adverts) as max_view
from users
group by users_id
order by sum(view_adverts) desc
limit 1;


#3. Определите день с наибольшим средним количеством просмотренных рекламных объявлений на пользователя, 
#но учитывайте только дни с более чем 500 уникальными пользователями.
select date, avg(view_adverts) as avg_view
from users
group by date
having count(distinct users_id) > 500
order by avg(view_adverts) desc
limit 1;

                
#4. Напишите запрос возвращающий LT (продолжительность присутствия пользователя на сайте) по каждому пользователю. 
#Отсортировать LT по убыванию.
select users_id, count(distinct date) as active_days
from users
group by users_id
order by count(distinct date) desc;


#5. Для каждого пользователя подсчитайте среднее количество просмотренной рекламы за день, а затем выясните, 
#у кого самый высокий средний показатель среди тех, кто был активен как минимум в 5 разных дней.

with users_daily_ad_views as 
						(select users_id, date, count(view_adverts) as daily_ad_views
						from users
                        group by users_id, date),
users_avg_daily_ad as 
						(select users_id, avg(daily_ad_views) as avg_daily_ad_views, count(date) as active_days
						from users_daily_ad_views
                        group by users_id
                        having count(date) >= 5)
select users_id, avg_daily_ad_views
from users_avg_daily_ad
order by avg_daily_ad_views desc
limit 1;

 

