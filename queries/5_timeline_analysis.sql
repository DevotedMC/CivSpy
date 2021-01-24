-- Some light queries investigating the relationship of events over time.

CREATE OR REPLACE FUNCTION quarter_hour (to_convert DATETIME)
 RETURNS DATETIME
 LANGUAGE SQL
 DETERMINISTIC
 SQL SECURITY INVOKER
 COMMENT 'Returns the same datetime but adjusted to nearest 15min boundary'
  RETURN str_to_date(
    concat(date(to_convert), " ",
    lpad(hour(to_convert),2,'0'), ":", lpad(round(floor(minute(to_convert) / 15),0)*15,2,'0')), "%Y-%m-%d %H:%i");

DROP TABLE spy_stats_quarterhour;
CREATE OR REPLACE TABLE spy_stats_quarterhour AS
 SELECT quarter_hour(stat_time) as `stat_time`, stat_key, string_value, sum(numeric_value) as `numeric_value`,
   count(numeric_value) as `v_count`, min(numeric_value) as `v_min`, max(numeric_value) as 'v_max',
   avg(numeric_value) as 'v_avg'
 FROM spy_stats
 WHERE server = 'devoted'
 GROUP BY quarter_hour(stat_time), stat_key, string_value;

CREATE OR REPLACE INDEX spy_stats_quarterhour_idx ON spy_stats_quarterhour (stat_time, stat_key);
CREATE OR REPLACE INDEX spy_stats_quarterhour_idx2 ON spy_stats_quarterhour (stat_key);

(SELECT 'When', 'Player Count', 'Avg Tick', 'Min Tick', 'Max Tick', 'Breaks', 'Places', 'Consume', 'Crafts', 'Moves (m)', 'Pickups',
  'Redstone', 'Drops')
UNION ALL
(SELECT a.stat_time, a.v_max, b.v_avg, c.v_min, d.v_max, e.numeric_value, f.numeric_value, g.numeric_value, h.numeric_value,
  i.numeric_value, j.numeric_value, k.numeric_value, l.numeric_value
 FROM
 ( SELECT stat_time, v_max FROM spy_stats_quarterhour WHERE stat_key = 'server.playercount' ) a
  LEFT JOIN 
 ( SELECT stat_time, round(v_avg,2) as `v_avg` FROM spy_stats_quarterhour WHERE stat_key = 'server.tick.average' ) b ON a.stat_time = b.stat_time
  LEFT JOIN 
 ( SELECT stat_time, v_min FROM spy_stats_quarterhour WHERE stat_key = 'server.tick.min' ) c ON a.stat_time = c.stat_time
  LEFT JOIN
 (SELECT stat_time, v_max FROM spy_stats_quarterhour WHERE stat_key = 'server.tick.max' ) d ON a.stat_time = d.stat_time
  LEFT JOIN
 (SELECT stat_time, sum(numeric_value) as `numeric_value` FROM spy_stats_quarterhour WHERE stat_key = 'player.blockbreak'
   GROUP BY stat_time ) e ON a.stat_time = e.stat_time
  LEFT JOIN
 (SELECT stat_time, sum(numeric_value) as `numeric_value` FROM spy_stats_quarterhour WHERE stat_key = 'player.blockplace'
   GROUP BY stat_time ) f ON a.stat_time = f.stat_time
  LEFT JOIN
 (SELECT stat_time, sum(numeric_value) as `numeric_value` FROM spy_stats_quarterhour WHERE stat_key = 'player.consume'
   GROUP BY stat_time ) g ON a.stat_time = g.stat_time
  LEFT JOIN
 (SELECT stat_time, sum(numeric_value) as `numeric_value` FROM spy_stats_quarterhour WHERE stat_key IN ('player.craft', 'player.craft.custom')
   GROUP BY stat_time) h ON a.stat_time = h.stat_time
  LEFT JOIN
 (SELECT stat_time, round(sum(numeric_value),0) as `numeric_value` FROM spy_stats_quarterhour WHERE stat_key = 'player.movement'
   GROUP BY stat_time ) i ON a.stat_time = i.stat_time
  LEFT JOIN
 (SELECT stat_time, sum(numeric_value) as `numeric_value` FROM spy_stats_quarterhour WHERE stat_key = 'player.pickup'
   GROUP BY stat_time ) j ON a.stat_time = j.stat_time
  LEFT JOIN
 (SELECT stat_time, sum(numeric_value) as `numeric_value` FROM spy_stats_quarterhour WHERE stat_key IN 
    ('redstone.current.decrease', 'redstone.current.increase', 'redstone.current.stable')
   GROUP BY stat_time) k ON a.stat_time = k.stat_time
  LEFT JOIN
 (SELECT stat_time, sum(numeric_value) as `numeric_value` FROM spy_stats_quarterhour WHERE stat_key = 'player.drop' 
   GROUP BY stat_time) l ON a.stat_time = l.stat_time
 INTO OUTFILE '/tmp/INTERNAL_performance_over_activity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);
