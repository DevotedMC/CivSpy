-- index
create index ssw_serv on spy_stats(server, stat_key);

-- datapoints
select min(stat_time), max(stat_time), count(*) from spy_stats where server is null or server = "devoted";

-- kinds of datapoints
select count(distinct stat_key, string_value), count(distinct stat_key) from spy_stats where server is null or server = "devoted";

-- uptime
select timestampdiff(MINUTE,min(stat_time), max(stat_time)), count(*) from spy_stats where stat_key = "server.tick.average" and server = "devoted";

-- playercounts
select max(numeric_value), avg(numeric_value) from spy_stats where stat_key = "server.playercount" and server="devoted";

-- session profiles
select max(numeric_value) / 1000 / 60 / 60, avg(numeric_value) / 1000 / 60 from spy_stats where stat_key = "bungee.session";

-- new & rejoin numbers
SELECT count(*) as joins, sum(case when join_days > 1 then 1 else 0 end) as recapture_within_next_week,
  sum(case when join_days / possible_days_rejoin > 6 / 7 then 1 else 0 end) as dedicated_through_next_week
FROM ( SELECT date(min(stat_time)) as first, uuid, count(distinct date(stat_time) ) as join_days,
   (datediff( '2017-06-23' , date(min(stat_time))) + 1) as possible_days_rejoin
  FROM spy_stats_all_weeks_login
   WHERE stat_time < '2017-06-24 00:00:00'
  GROUP BY uuid
   HAVING min(stat_time) >= '2017-06-10 00:00:00' AND min(stat_time) < '2017-06-17 00:00:00'
 ) b;

-- all time rejoin & dedicated
SELECT count(*) as all_joins, sum(case when join_days > 1 then 1 else 0 end) as recaptured,
  sum(case when join_days / possible_days_rejoin > 6 / 7 then 1 else 0 end) as dedicated
FROM ( SELECT date(min(stat_time)) as first, uuid, count(distinct date(stat_time) ) as join_days,
   (datediff( '2017-06-23' , date(min(stat_time))) + 1) as possible_days_rejoin
  FROM spy_stats_all_weeks_login
   WHERE stat_time < '2017-06-24 00:00:00'
  GROUP BY uuid
   HAVING min(stat_time) < '2017-06-17 00:00:00'
 ) b;

-- breakdown by join week, dedicated
SELECT week, count(*) as all_joins, sum(case when join_days > 1 then 1 else 0 end) as recaptured,
  sum(case when join_days > 2 then 1 else 0 end) as recaptured_2,
  sum(case when join_days > 3 then 1 else 0 end) as recaptured_3,
  sum(case when join_days > 4 then 1 else 0 end) as recaptured_4,
  sum(case when join_days / possible_days_rejoin <= 1 / 7 AND join_days > 1 then 1 else 0 end) as bare_dedicated,
  sum(case when join_days / possible_days_rejoin > 1 / 7 AND join_days > 1 then 1 else 0 end) as 1_7_dedicated,
  sum(case when join_days / possible_days_rejoin > 2 / 7 then 1 else 0 end) as 2_7_dedicated,
  sum(case when join_days / possible_days_rejoin > 3 / 7 then 1 else 0 end) as half_dedicated,
  sum(case when join_days / possible_days_rejoin > 4 / 7 then 1 else 0 end) as 4_7_dedicated,
  sum(case when join_days / possible_days_rejoin > 5 / 7 then 1 else 0 end) as 5_7_dedicated,
  sum(case when join_days / possible_days_rejoin > 6 / 7 then 1 else 0 end) as dedicated,
  sum(case when join_weeks > (23 - week) / 2 then 1 else 0 end) as half_weeks,
  sum(case when join_weeks > (23 - week - 1) then 1 else 0 end) as all_weeks
FROM ( SELECT floor(datediff(date(min(stat_time)), '2016-09-17')/7) as week,
   date(min(stat_time)) as first, uuid, count(distinct date(stat_time) ) as join_days,
   count(distinct floor(datediff(date(stat_time), '2016-09-17')/7) ) as join_weeks,
   (datediff( '2017-06-23' , date(min(stat_time))) + 1) as possible_days_rejoin
  FROM spy_stats_all_weeks_login
   WHERE stat_time < '2017-06-24 00:00:00'
  GROUP BY uuid
   HAVING min(stat_time) < '2017-06-17 00:00:00'
 ) b
GROUP BY week;
