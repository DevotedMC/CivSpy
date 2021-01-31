-- Review Notes
 -- 

-- Useful conjuctions:
CREATE OR REPLACE TABLE spy_stats_all_weeks_login as 
  SELECT id, stat_time, uuid FROM spy_stats_week_1 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_2 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_3 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_4 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_5 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_6 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_7 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_8 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_9 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_10 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_11 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_12 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_13 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_14 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_15 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_16 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_17 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_18 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_19 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_20 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_21 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_22 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_23 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_24 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_25 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_26 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_27 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_28 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_29 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats_week_30 WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
INSERT INTO spy_stats_all_weeks_login 
  SELECT id, stat_time, uuid FROM spy_stats WHERE stat_key='bungee.login' AND stat_time >='2016-09-17 10:00:00';
  
CREATE OR REPLACE VIEW spy_stats_all_weeks AS
  SELECT * FROM spy_stats_week_1 UNION ALL
  SELECT * FROM spy_stats_week_2 UNION ALL
  SELECT * FROM spy_stats_week_3 UNION ALL
  SELECT * FROM spy_stats_week_4 UNION ALL
  SELECT * FROM spy_stats_week_5 UNION ALL
  SELECT * FROM spy_stats_week_6 UNION ALL
  SELECT * FROM spy_stats_week_7 UNION ALL
  SELECT * FROM spy_stats_week_8 UNION ALL
  SELECT * FROM spy_stats_week_9 UNION ALL
  SELECT * FROM spy_stats_week_10 UNION ALL
  SELECT * FROM spy_stats_week_11 UNION ALL
  SELECT * FROM spy_stats_week_12 UNION ALL
  SELECT * FROM spy_stats_week_13 UNION ALL
  SELECT * FROM spy_stats_week_14 UNION ALL
  SELECT * FROM spy_stats_week_15 UNION ALL
  SELECT * FROM spy_stats_week_16 UNION ALL
  SELECT * FROM spy_stats_week_17 UNION ALL
  SELECT * FROM spy_stats_week_18 UNION ALL
  SELECT * FROM spy_stats_week_19 UNION ALL
  SELECT * FROM spy_stats_week_20 UNION ALL
  SELECT * FROM spy_stats_week_21 UNION ALL
  SELECT * FROM spy_stats_week_22 UNION ALL
  SELECT * FROM spy_stats_week_23 UNION ALL
  SELECT * FROM spy_stats_week_24 UNION ALL
  SELECT * FROM spy_stats_week_25 UNION ALL
  SELECT * FROM spy_stats_week_26 UNION ALL
  SELECT * FROM spy_stats_week_27 UNION ALL
  SELECT * FROM spy_stats_week_28 UNION ALL
  SELECT * FROM spy_stats_week_29 UNION ALL
  SELECT * FROM spy_stats_week_30 UNION ALL
  SELECT * FROM spy_stats;
-- Update weekly.

-- Generate used allweeks data.
CREATE INDEX spy_stats_all_weeks_login_idx ON spy_stats_all_weeks_login (stat_time, uuid);

-- General stats gathered
SELECT 'stat_key', 'count'
UNION
SELECT stat_key, count(*) FROM spy_stats GROUP BY stat_key
INTO OUTFILE '/tmp/overall_statistic_counts.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Player count by world over time
SELECT 'time', 'server', 'playercount'
UNION
SELECT stat_time, server, numeric_value as count FROM spy_stats WHERE stat_key='server.playercount'
INTO OUTFILE '/tmp/server_playercount.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Player count network wide over time
SELECT 'time', 'network_playercount'
UNION
SELECT stat_time, numeric_value as count FROM spy_stats WHERE stat_key='bungee.playercount'
INTO OUTFILE '/tmp/network_playercount.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Unique players during reporting period
SELECT 'unique_players_in_period'
UNION
SELECT count(distinct uuid) as unique_players_all_time FROM spy_stats WHERE stat_key='bungee.login'
INTO OUTFILE '/tmp/unique_players_period.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Unique players all time
SELECT 'unique_players_all_time'
UNION
SELECT count(distinct uuid) as unique_players_all_time FROM spy_stats_all_weeks_login
INTO OUTFILE '/tmp/unique_players_total.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Unique players per day
(SELECT 'day', 'unique_players')
UNION ALL
(SELECT date(stat_time) as day, count(distinct uuid) as unique_players 
  FROM spy_stats_all_weeks_login
  GROUP BY day
  ORDER BY day
INTO OUTFILE '/tmp/unique_players_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Unique players per week
(SELECT 'year', 'week', 'unique_players')
UNION ALL
(SELECT year(stat_time) as `year`, week(stat_time) as `week`, count(distinct uuid) as unique_players 
  FROM spy_stats_all_weeks_login
  GROUP BY `year`, `week`
  ORDER BY `year`, `week`
INTO OUTFILE '/tmp/unique_players_by_week.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Unique players per month
(SELECT 'year', 'month', 'unique_players')
UNION ALL
(SELECT year(stat_time) as `year`, month(stat_time) as `month`, count(distinct uuid) as unique_players 
  FROM spy_stats_all_weeks_login
  GROUP BY `year`, `month`
  ORDER BY `year`, `month`
INTO OUTFILE '/tmp/unique_players_by_month.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Player typical session time (across all players)
SELECT 'session_min', 'session_avg', 'session_max'
UNION
SELECT min(numeric_value) as session_min, avg(numeric_value) as session_avg, max(numeric_value) as session_max FROM spy_stats WHERE stat_key='bungee.session'
INTO OUTFILE '/tmp/session_profile_universal.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Player session profiles; session count, play time lengths, unique days in reporting period, and average playtime on days of play
(SELECT 'player', 'session_count', 'total_playtime', 'unique_days_online', 'avg_daily_playtime')
UNION
(SELECT uuid, count(*) as num_sessions, sum(numeric_value) as total_playtime, count(distinct date(stat_time)) as unique_days, 
    round(sum(numeric_value) / count( distinct date(stat_time)),0) as avg_daily_playtime 
  FROM spy_stats WHERE stat_key = 'bungee.session' 
  GROUP BY uuid HAVING total_playtime > 300000 
  ORDER BY avg_daily_playtime DESC
  LIMIT 10
INTO OUTFILE '/tmp/significant_player_session_distribution.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Player session time distribution by when it started
SELECT 'day', 'session_start_hour', 'session_min (s)', 'session_avg (s)', 'session_max (s)'
UNION
SELECT DATE(session_start) as session_date, HOUR(session_start) as session_hour_began,
    MIN(session_length) as min, round(AVG(session_length),0) as average, MAX(session_length) as max
  FROM 
    (SELECT DATE_SUB(stat_time, INTERVAL numeric_value / 1000 SECOND) as session_start, round(numeric_value / 1000, 0) as session_length, stat_time as 
      session_end FROM spy_stats WHERE stat_key='bungee.session'
    ) as session
  GROUP BY session_date, session_hour_began
INTO OUTFILE '/tmp/session_profiles_by_day_and_starthour.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';
  
-- Player session time distribution by hour began ignoring day
SELECT 'session_start_hour', 'session_min (s)', 'session_avg (s)', 'session_max (s)'
UNION
SELECT HOUR(session_start) as session_hour_began,
      MIN(session_length) as min, round(AVG(session_length),0) as average, MAX(session_length) as max
    FROM 
      (SELECT DATE_SUB(stat_time, INTERVAL numeric_value / 1000 SECOND) as session_start, round(numeric_value / 1000, 0) as session_length, stat_time as 
        session_end FROM spy_stats WHERE stat_key='bungee.session'
      ) as session
  GROUP BY session_hour_began
INTO OUTFILE '/tmp/session_profiles_by_starthour_only.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';
  
-- Player session time frequency map by session start day
SELECT 'day', 'session_length_bucket (10m granularity)', 'count_in_bucket', 'avg_session_length_in_bucket (s)'
UNION
SELECT DATE(session_start) as session_date, round(session_length / 600,0) as ten_minute_bucket, count(*) as freq, round(avg(session_length),0) as bucket_avg_s
    FROM
      (SELECT DATE_SUB(stat_time, INTERVAL numeric_value / 1000 SECOND) as session_start, round(numeric_value / 1000, 0) as session_length, stat_time as 
        session_end FROM spy_stats WHERE stat_key='bungee.session'
      ) as session
  GROUP BY session_date, ten_minute_bucket
INTO OUTFILE '/tmp/histogram_session_length_frequency_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';
  
-- Player session time frequency map ignoring start day (very useful)
SELECT 'session_length_bucket (10m granularity)', 'count_in_bucket', 'avg_session_length_in_bucket (s)'
UNION
SELECT round(session_length / 600,0) as ten_minute_bucket, count(*) as freq, round(avg(session_length),0) as bucket_avg_s
    FROM
      (SELECT DATE_SUB(stat_time, INTERVAL numeric_value / 1000 SECOND) as session_start, round(numeric_value / 1000, 0) as session_length, stat_time as 
        session_end FROM spy_stats WHERE stat_key='bungee.session'
      ) as session
  GROUP BY ten_minute_bucket
INTO OUTFILE '/tmp/histogram_session_length_frequency.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'; 

-- New (first time) unique players by day
SELECT 'day', 'first_time_uniques_count'
UNION
SELECT DATE(first) as day, count(*) as uniques
    FROM
      (SELECT min(stat_time) as first, uuid FROM spy_stats_all_weeks_login GROUP BY uuid
      ) as starts
  GROUP BY day
INTO OUTFILE '/tmp/first_time_players_by_first_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';  
  
-- Tick length by server (should be 50ms for "normal" tick)
SELECT 'time', 'server', 'tick_min_length (ms)'
UNION
SELECT stat_time, server, numeric_value as tick_min FROM spy_stats WHERE stat_key = "server.tick.min"
INTO OUTFILE '/tmp/tick_minimum_by_server.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';  

SELECT 'time', 'server', 'tick_avg_length (ms)'
UNION
SELECT stat_time, server, numeric_value as tick_average FROM spy_stats WHERE stat_key = "server.tick.average"
INTO OUTFILE '/tmp/tick_average_by_server.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';  

SELECT 'time', 'server', 'tick_max_length (ms)'
UNION
SELECT stat_time, server, numeric_value as tick_max FROM spy_stats WHERE stat_key = "server.tick.max"
INTO OUTFILE '/tmp/tick_maximum_by_server.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';  

-- Player deaths by cause

SELECT 'day', 'cause', 'players_died', 'unique_players_died'
UNION
SELECT DATE(stat_time) as day, string_value as cause, sum(numeric_value) as num_killed, count(distinct uuid) as unique_killed
  FROM spy_stats WHERE stat_key = "player.died" GROUP BY day, cause
INTO OUTFILE '/tmp/players_died_naturally_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Player loot on death
(SELECT 'day', 'item_dropped_on_player_death', 'number_dropped')
UNION
(SELECT DATE(stat_time) as day, string_value as death_dropped_item, sum(numeric_value) as num_dropped_on_death
  FROM spy_stats WHERE stat_key = "player.died.drop"
  GROUP BY day, death_dropped_item
  HAVING num_dropped_on_death > 1
  ORDER BY day, num_dropped_on_death DESC
INTO OUTFILE '/tmp/players_died_death_drops_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
-- Leave out the having for "everything"


-- Player Killed by Mobs
(SELECT 'day', 'mob_killer', 'players_killed', 'unique_players_killed')
UNION
(SELECT DATE(stat_time) as day, string_value as killer, sum(numeric_value) as num_killed, count(distinct uuid) as uniq_killed
  FROM spy_stats WHERE stat_key = "player.killed" AND NOT string_value LIKE '%-%-%-%-%'
  GROUP BY day, killer
  ORDER BY day, num_killed DESC
INTO OUTFILE '/tmp/players_killed_by_mobs_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Player Killed by Players (top 5 killers per day)
(SELECT 'day', 'killer', 'players_killed', 'unique_players_killed')
UNION
(SELECT day, killer, num_killed, uniq_killed
 FROM (
  SELECT day, killer, num_killed, uniq_killed, @num := if(@day = day, @num + 1, 1) as row_number, @day := day as dummy
   FROM (
    SELECT DATE(stat_time) as day, string_value as killer, sum(numeric_value) as num_killed, count(distinct uuid) as uniq_killed
      FROM spy_stats WHERE stat_key = "player.killed" AND string_value LIKE '%-%-%-%-%'
      GROUP BY day, killer
      ORDER BY day, num_killed DESC
    ) AS d
  ) AS c
  WHERE row_number < 6
INTO OUTFILE '/tmp/players_killed_by_players_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Player loot on murder
(SELECT 'day', 'item_dropped_on_player_murder', 'number_dropped')
UNION
(SELECT DATE(stat_time) as day, string_value as killed_dropped_item, sum(numeric_value) as num_dropped_on_killed
  FROM spy_stats WHERE stat_key = "player.killed.drop"
  GROUP BY day, killed_dropped_item
  HAVING num_dropped_on_killed > 1
  ORDER BY day, num_dropped_on_killed DESC
INTO OUTFILE '/tmp/players_killed_death_drops_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
-- Leave out the having for "everything"

-- Top Diers by Natural causes (top 5 per day)
(SELECT 'day', 'player', 'natural_deaths', 'unique_natural_deaths')
UNION
(SELECT day, uuid, num_deaths, uniq_ways
 FROM (
  SELECT day, uuid, num_deaths, uniq_ways, @num := if(@day = day, @num + 1, 1) as row_number, @day := day as dummy
   FROM (
    SELECT DATE(stat_time) as day, uuid, sum(numeric_value) as num_deaths, count(distinct string_value) as uniq_ways
      FROM spy_stats WHERE stat_key = "player.died" 
      GROUP BY day, uuid
      ORDER BY day, num_deaths DESC
    ) AS d
  ) AS c
  WHERE row_number < 6
INTO OUTFILE '/tmp/top_players_by_natural_deaths_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
      
-- Top Diers by Mobs (top 5 per day)
(SELECT 'day', 'player', 'deaths_by_mobs', 'unique_mob_killers')
UNION
(SELECT day, uuid, num_deaths, uniq_killers
 FROM (
  SELECT day, uuid, num_deaths, uniq_killers, @num := if(@day = day, @num + 1, 1) as row_number, @day := day as dummy
   FROM (
    SELECT DATE(stat_time) as day, uuid, sum(numeric_value) as num_deaths, count(distinct string_value) as uniq_killers
      FROM spy_stats WHERE stat_key = "player.killed" AND NOT string_value LIKE '%-%-%-%-%'
      GROUP BY day, uuid
      ORDER BY day, num_deaths DESC
    ) AS d
  ) AS c
  WHERE row_number < 6
INTO OUTFILE '/tmp/top_players_by_mob_deaths_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Top Diers by Players (top 5 per day)
(SELECT 'day', 'player', 'deaths_by_players', 'unique_murderers')
UNION
(SELECT day, uuid, num_deaths, uniq_killers
 FROM (
  SELECT day, uuid, num_deaths, uniq_killers, @num := if(@day = day, @num + 1, 1) as row_number, @day := day as dummy
   FROM (
    SELECT DATE(stat_time) as day, uuid, sum(numeric_value) as num_deaths, count(distinct string_value) as uniq_killers
      FROM spy_stats WHERE stat_key = "player.killed" AND string_value LIKE '%-%-%-%-%'
      GROUP BY day, uuid
      ORDER BY day, num_deaths DESC
    ) AS d
  ) AS c
  WHERE row_number < 6
INTO OUTFILE '/tmp/top_players_by_murders_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- What weapons kill Players? (This is new statistic)
(SELECT 'day', 'weapon', 'player_kills', 'unique_player_kills')
UNION
(SELECT DATE(stat_time) as day, string_value as weapon, sum(numeric_value) as kill_count, count(distinct uuid) as uniq_killed
  FROM spy_stats WHERE server='devoted' AND stat_key = 'player.killed.by' 
  GROUP BY day, string_value
  ORDER BY day, kill_count DESC
INTO OUTFILE '/tmp/murderous_weapons_by_day_by_weapon.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Mob death 
(SELECT 'day', 'mob_killed', 'mob_name', 'number_killed', 'unique_killer_count')
UNION
(SELECT DATE(stat_time) as day, stat_key as killed, string_value as name, sum(numeric_value) as num_killed, count(distinct uuid) as unique_killers
  FROM spy_stats WHERE stat_key like "entity.death.%" AND NOT stat_key like "entity.death.drop.%" and not stat_key like "entity.death.xp.%"
  GROUP BY day, killed, name
  ORDER BY day, num_killed DESC
INTO OUTFILE '/tmp/top_mobs_killed_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Mob loot on death
(SELECT 'day', 'mob_killed', 'item_dropped_on_death', 'dropped_count')
UNION
(SELECT DATE(stat_time) as day, stat_key as killed, string_value as death_dropped_item, sum(numeric_value) as num_dropped_on_death
  FROM spy_stats WHERE stat_key like "entity.death.drop.%"
  GROUP BY day, stat_key, death_dropped_item
  HAVING num_dropped_on_death > 1
  ORDER BY day, stat_key, num_dropped_on_death DESC
INTO OUTFILE '/tmp/mob_kills_death_drops_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- XP dropped by mobs per hour
(SELECT 'day', 'hour', 'total_xp_dropped')
UNION
(SELECT DATE(stat_time) as day, HOUR(stat_time) as hour, sum(numeric_value) as xp_dropped
  FROM spy_stats WHERE stat_key like "entity.death.xp.%"
  GROUP BY day, hour
  ORDER BY day, hour, xp_dropped DESC
INTO OUTFILE '/tmp/xp_dropped_by_mobs_by_day_by_hour.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Fun Facts - distance

-- Total distance travelled by all players
(SELECT 'day', 'total_distance')
UNION
(SELECT DATE(stat_time) as day, round(sum(numeric_value),2) as distance
  FROM spy_stats WHERE stat_key = "player.movement"
  GROUP BY day
  ORDER BY day
INTO OUTFILE '/tmp/total_distance_travelled_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Player distance travelled by conveyance
(SELECT 'day', 'vehicle/mode', 'total_distance')
UNION
(SELECT DATE(stat_time) as day, string_value as mode, round(sum(numeric_value),2) as distance
  FROM spy_stats WHERE stat_key = "player.movement"
  GROUP BY day, mode
  ORDER BY day, distance DESC
INTO OUTFILE '/tmp/total_distance_travelled_by_day_by_mode.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- How many chunks did players traverse using each conveyance
(SELECT 'day', 'vehicle/mode', 'total_unique_chunks_visited')
UNION
(SELECT DATE(stat_time) as day, string_value as mode, count(distinct world, chunk_x, chunk_z) as chunks
  FROM spy_stats WHERE stat_key = "player.movement"
  GROUP BY day, mode
  ORDER BY day, chunks DESC
INTO OUTFILE '/tmp/total_chunks_travelled_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Most well travelled players (top 5 per day)
(SELECT 'day', 'player', 'total_distance')
UNION
(SELECT day, player, distance
 FROM (
  SELECT day, player, distance, @num := if(@day = day, @num + 1, 1) as row_number, @day := day as dummy
   FROM (
    SELECT DATE(stat_time) as day, uuid as player, round(sum(numeric_value), 2) as distance
      FROM spy_stats WHERE stat_key = "player.movement"
      GROUP BY day, player
      ORDER BY day, distance DESC
    ) AS d
  ) AS c
  WHERE row_number < 6
INTO OUTFILE '/tmp/player_distance_travelled_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Fun Facts - block breaks

-- Total blocks broken by all players
(SELECT 'day', 'number_blocks_broken')
UNION
(SELECT DATE(stat_time) as day, sum(numeric_value) as blocks_broken
  FROM spy_stats WHERE stat_key = "player.blockbreak"
  GROUP BY day
  ORDER BY day
INTO OUTFILE '/tmp/blocks_broken_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Player breaks by broken type
(SELECT 'day', 'block_type', 'number_broken', 'unique_breakers')
UNION
(SELECT DATE(stat_time) as day, string_value as broken, sum(numeric_value) as blocks_broken, count(distinct uuid) as unique_breakers
  FROM spy_stats WHERE stat_key = "player.blockbreak"
  GROUP BY day, broken
  ORDER BY day, blocks_broken DESC
INTO OUTFILE '/tmp/blocks_broken_by_day_and_type.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- How many chunks did players break blocks in

(SELECT 'day', 'unique_chunks')
UNION
(SELECT DATE(stat_time) as day, count(distinct world, chunk_x, chunk_z) as chunks
  FROM spy_stats WHERE stat_key = "player.blockbreak"
  GROUP BY day
  ORDER BY day
INTO OUTFILE '/tmp/chunks_with_block_breaks_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Most prolific block breaking players (top 5 per day)
(SELECT 'day', 'player', 'number_broken', 'number_types_broken')
UNION
(SELECT day, player, blocks_broken, unique_blocks
 FROM (
  SELECT day, player, blocks_broken, unique_blocks, @num := if(@day = day, @num + 1, 1) as row_number, @day := day as dummy
   FROM (
    SELECT DATE(stat_time) as day, uuid as player, sum(numeric_value) as blocks_broken, count(distinct string_value) as unique_blocks
      FROM spy_stats WHERE stat_key = "player.blockbreak"
      GROUP BY day, player
      ORDER BY day, blocks_broken DESC
    ) AS d
  ) AS c
  WHERE row_number < 6
INTO OUTFILE '/tmp/top_block_breakers_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Fun Facts - block placement

-- Total blocks placed by all players
(SELECT 'day', 'number_blocks_placed')
UNION
(SELECT DATE(stat_time) as day, sum(numeric_value) as blocks_placed
  FROM spy_stats WHERE stat_key = "player.blockplace"
  GROUP BY day
  ORDER BY day
INTO OUTFILE '/tmp/blocks_placed_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Player placements by broken type
(SELECT 'day', 'block_type', 'number_placed', 'unique_players')
UNION
(SELECT DATE(stat_time) as day, string_value as placed, sum(numeric_value) as blocks_placed, count(distinct uuid) as unique_placers
  FROM spy_stats WHERE stat_key = "player.blockplace"
  GROUP BY day, placed
  ORDER BY day, blocks_placed DESC
INTO OUTFILE '/tmp/blocks_placed_by_day_and_type.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- How many chunks did players place blocks in
(SELECT 'day', 'unique_chunks')
UNION
(SELECT DATE(stat_time) as day, count(distinct world, chunk_x, chunk_z) as chunks
  FROM spy_stats WHERE stat_key = "player.blockplace"
  GROUP BY day
  ORDER BY day, chunks DESC
INTO OUTFILE '/tmp/chunks_with_blocks_placed_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Most prolific block placing players (top 5 per day)
(SELECT 'day', 'player', 'number_placed', 'number_types_placed')
UNION
(SELECT day, player, blocks_placed, unique_blocks
 FROM (
  SELECT day, player, blocks_placed, unique_blocks, @num := if(@day = day, @num + 1, 1) as row_number, @day := day as dummy
   FROM (
    SELECT DATE(stat_time) as day, uuid as player, sum(numeric_value) as blocks_placed, count(distinct string_value) as unique_blocks
      FROM spy_stats WHERE stat_key = "player.blockplace"
      GROUP BY day, player
      ORDER BY day, blocks_placed DESC
    ) AS d
  ) AS c
  WHERE row_number < 6
INTO OUTFILE '/tmp/top_block_placers_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Fun Facts - crafting

-- Favorite things to craft
(SELECT 'day', 'craft_outcome', 'crafting_count', 'unique_crafters')
UNION
(SELECT DATE(stat_time) as day, string_value as outcome, sum(numeric_value) as recipe_runs, count(distinct uuid) as unique_crafters
  FROM spy_stats WHERE stat_key = "player.craft"
  GROUP BY day, outcome
  ORDER BY day, recipe_runs DESC
INTO OUTFILE '/tmp/crafting_by_day_and_outcome.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Most prolific crafter (top 5 per day)
(SELECT 'day', 'player', 'crafts_made', 'unique_crafts')
UNION
(SELECT day, player, recipe_runs, unique_recipes
 FROM (
  SELECT day, player, recipe_runs, unique_recipes, @num := if(@day = day, @num + 1, 1) as row_number, @day := day as dummy
   FROM (
    SELECT DATE(stat_time) as day, uuid as player, sum(numeric_value) as recipe_runs, count(distinct string_value) as unique_recipes
      FROM spy_stats WHERE stat_key = "player.craft"
      GROUP BY day, player
      ORDER BY day, recipe_runs DESC
    ) AS d
  ) AS c
  WHERE row_number < 6
INTO OUTFILE '/tmp/crafting_by_day_by_player.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Fun Facts - What do players throw away?
(SELECT 'day', 'dropped item', 'item drops counted')
UNION
(SELECT DATE(stat_time) as day, string_value as trash, sum(numeric_value) as dropped_count
  FROM spy_stats WHERE stat_key = "player.drop"
  GROUP BY day, trash
  ORDER BY day, dropped_count DESC
INTO OUTFILE '/tmp/player_item_drop_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Fun Facts - What do players pick up?
(SELECT 'day', 'picked item', 'item pickup count')
UNION
(SELECT DATE(stat_time) as day, string_value as pick, sum(numeric_value) as picked_count
  FROM spy_stats WHERE stat_key = "player.drop"
  GROUP BY day, pick
  ORDER BY day, picked_count DESC
INTO OUTFILE '/tmp/player_item_pickedup_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');

-- Fun Facts - What do players reinforce?
(SELECT 'day', 'reinforcement_type', 'block reinforced', 'use count')
UNION
(SELECT DATE(stat_time) as day, stat_key as reinf_type, string_value as what_reinforced, sum(numeric_value) how_many
  FROM spy_stats WHERE stat_key like "player.citadel.create.%" and not stat_key = "player.citadel.create.group"
  GROUP BY day, stat_key, what_reinforced
  ORDER BY day, stat_key, how_many DESC
INTO OUTFILE '/tmp/reinforcement_applied_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Fun Facts - What do players damage reinforcement on?
(SELECT 'day', 'reinforcement_type', 'what_reinforced', 'damaged count')
UNION
(SELECT DATE(stat_time) as day, stat_key as reinf_type, string_value as what_was_reinforced, sum(numeric_value) how_many
  FROM spy_stats WHERE stat_key like "player.citadel.damage.%" and not stat_key = "player.citadel.damage.group"
  GROUP BY day, stat_key, what_was_reinforced
  ORDER BY day, stat_key, how_many DESC
INTO OUTFILE '/tmp/reinforcements_damaged_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Fun Facts - What do players fish out of the water?
(SELECT 'day', 'fished item', 'item fished count')
UNION
(SELECT DATE(stat_time) as day, string_value as fished, sum(numeric_value) as fished_count
  FROM spy_stats WHERE stat_key = "player.fish"
  GROUP BY day, fished
  ORDER BY day, fished_count DESC
INTO OUTFILE '/tmp/player_item_fish_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
  
-- Fun Facts - What do players consume?
(SELECT 'day', 'consumed item', 'item consume count')
UNION
(SELECT DATE(stat_time) as day, string_value as consumed, sum(numeric_value) as consumed_count
  FROM spy_stats WHERE stat_key = "player.consume"
  GROUP BY day, consumed
  ORDER BY day, consumed_count DESC
INTO OUTFILE '/tmp/player_item_consumed_by_day.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n');
