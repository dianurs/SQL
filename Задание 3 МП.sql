
-- 1. Выведите сколько пользователей добавили книгу 'Coraline', сколько пользователей прослушало больше 10%. 
select count(distinct a_c.user_id) as users_add_audiobook, count(distinct users_listened.user_id) as users_listen_10
	from audio_cards a_c
	join audiobooks a on a.uuid = a_c.audiobook_uuid
	left join (select l.user_id, l.audiobook_uuid
				from listenings l
				join audiobooks a on l.audiobook_uuid = a.uuid
				where a.title like 'Coraline'
				group by l.user_id, a.duration, l.audiobook_uuid
				having sum(l.position_to - l.position_from) > 0.1 * a.duration) as users_listened 
				on a_c.user_id = users_listened.user_id
				where a.title like 'Coraline';



-- 2. По каждой операционной системе и названию книги выведите количество пользователей, 
-- сумму прослушивания в часах, не учитывая тестовые прослушивания. 
select a.title, l.os_name, count(distinct l.user_id) as users, sum((l.position_to - l.position_from)/3600) as sum_hour
from listenings l
	join audiobooks a on a.uuid = l.audiobook_uuid
where l.is_test = 0
group by l.os_name, a.title


-- 3. Найдите книгу, которую слушает больше всего людей.
select ab.title, sum(progress) as max_progress
from audiobooks ab
join audio_cards ac on ac.audiobook_uuid = ab.uuid
group by ab.title
order by max_progress desc
limit 1;


-- 4. Найдите книгу, которую чаще всего дослушивают до конца.
select ab.title, count(state) 
from audiobooks ab
join audio_cards ac on ac.audiobook_uuid = ab.uuid
where ac.state = 'finished'
group by ab.title
order by count(state) desc
limit 1;



