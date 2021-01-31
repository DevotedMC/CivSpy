-- Heatmap setup
CREATE TABLE IF NOT EXISTS chunkmap (chunk int(11) NOT NULL);

DELIMITER ;;
CREATE PROCEDURE IF NOT EXISTS stuffchunks()
BEGIN
  DECLARE i INT(11) DEFAULT -313;
  WHILE i < 313 DO
    INSERT chunkmap (chunk) VALUES (i);
    SET i = i + 1;
  END WHILE;
END;;
DELIMITER ;
TRUNCATE chunkmap;
CALL stuffchunks();

CREATE TABLE IF NOT EXISTS chunkenum (chunk_x int(11) NOT NULL, chunk_z int(11) NOT NULL) AS 
  SELECT a.chunk as chunk_x, b.chunk as chunk_z
  FROM chunkmap a JOIN chunkmap b;

CREATE INDEX IF NOT EXISTS chunkenumcoord ON chunkenum (chunk_x, chunk_z);

-- CHUNK level data mapping

DROP TABLE IF EXISTS spy_stats_day_main;
CREATE TABLE IF NOT EXISTS spy_stats_day_main AS 
  SELECT date(stat_time) AS stat_day, stat_key, chunk_x, chunk_z, uuid, string_value, sum(numeric_value) as numeric_value
   FROM spy_stats
   WHERE (server = 'devoted' AND world='world') OR (server is null and world is null)
   GROUP BY date(stat_time), stat_key, chunk_x, chunk_z, uuid, string_value;

CREATE INDEX IF NOT EXISTS ssdm1 ON spy_stats_day_main (stat_day, stat_key);
CREATE INDEX IF NOT EXISTS ssdm2 ON spy_stats_day_main (chunk_x, chunk_z);
CREATE INDEX IF NOT EXISTS ssdm3 ON spy_stats_day_main (uuid);

DROP TABLE IF EXISTS chunkdayenum;
CREATE TABLE IF NOT EXISTS chunkdayenum AS 
  SELECT * FROM ( SELECT DISTINCT stat_day FROM spy_stats_day_main ) a CROSS JOIN chunkenum;

CREATE INDEX IF NOT EXISTS chunkdayenumcoord ON chunkdayenum (stat_day, chunk_x, chunk_z);

-- REGION level data mapping

DROP TABLE IF EXISTS spy_stats_day_main_region;
CREATE TABLE IF NOT EXISTS spy_stats_day_main_region AS 
  SELECT date(stat_time) AS stat_day, stat_key, round(chunk_x/16,0) as region_x, round(chunk_z/16,0) as region_z,
     uuid, string_value, sum(numeric_value) as numeric_value
   FROM spy_stats
   WHERE (server = 'devoted' AND world='world') OR (server is null and world is null)
   GROUP BY date(stat_time), stat_key, region_x, region_z, uuid, string_value;

CREATE INDEX IF NOT EXISTS ssdm1 ON spy_stats_day_main_region (stat_day, stat_key);
CREATE INDEX IF NOT EXISTS ssdm2 ON spy_stats_day_main_region (region_x, region_z);
CREATE INDEX IF NOT EXISTS ssdm3 ON spy_stats_day_main_region (uuid);

DROP TABLE IF EXISTS regiondayenum;
CREATE TABLE IF NOT EXISTS regiondayenum AS 
  SELECT DISTINCT stat_day, round(chunk_x/16,0) as region_x, round(chunk_z/16,0) as region_z FROM ( SELECT DISTINCT stat_day FROM spy_stats_day_main_region ) a CROSS JOIN chunkenum;

CREATE INDEX IF NOT EXISTS regiondayenumcoord ON regiondayenum (stat_day, region_x, region_z);


-- NOW on to the queries


SET SESSION group_concat_max_len = 5000000;


-- CHUNK stuff first

(SELECT 'day', 'chunk xz', chunk_xs
 FROM (
  SELECT stat_day, chunk_z, group_concat(chunk_x order by chunk_x SEPARATOR ';') as chunk_xs from chunkdayenum group by stat_day, chunk_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.chunk_z, group_concat(IFNULL(point_value,0) order by a.chunk_x SEPARATOR ';') as chunk_xs
 FROM chunkdayenum a LEFT OUTER JOIN (
  SELECT stat_day, chunk_z, chunk_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main
  WHERE stat_key = 'player.blockplace'
  GROUP BY stat_day, chunk_z, chunk_x
 ) AS s ON s.stat_day = a.stat_day AND s.chunk_z = a.chunk_z AND s.chunk_x = a.chunk_x
 GROUP BY a.stat_day, a.chunk_z
 ORDER BY a.stat_day, a.chunk_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_blockplace_by_day_chunk_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'chunk xz', chunk_xs
 FROM (
  SELECT stat_day, chunk_z, group_concat(chunk_x order by chunk_x SEPARATOR ';') as chunk_xs from chunkdayenum group by stat_day, chunk_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.chunk_z, group_concat(IFNULL(point_value,0) order by a.chunk_x SEPARATOR ';') as chunk_xs
 FROM chunkdayenum a LEFT OUTER JOIN (
  SELECT stat_day, chunk_z, chunk_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main
  WHERE stat_key = 'player.blockbreak'
  GROUP BY stat_day, chunk_z, chunk_x
 ) AS s ON s.stat_day = a.stat_day AND s.chunk_z = a.chunk_z AND s.chunk_x = a.chunk_x
 GROUP BY stat_day, a.chunk_z
 ORDER BY stat_day, a.chunk_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_blockbreak_by_day_chunk_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'chunk xz', chunk_xs
 FROM (
  SELECT stat_day, chunk_z, group_concat(chunk_x order by chunk_x SEPARATOR ';') as chunk_xs from chunkdayenum group by stat_day, chunk_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.chunk_z, group_concat(IFNULL(point_value,0) order by a.chunk_x SEPARATOR ';') as chunk_xs
 FROM chunkdayenum a LEFT OUTER JOIN (
  SELECT stat_day, chunk_z, chunk_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main
  WHERE stat_key = 'player.movement'
  GROUP BY stat_day, chunk_z, chunk_x
 ) AS s ON s.stat_day = a.stat_day AND s.chunk_z = a.chunk_z AND s.chunk_x = a.chunk_x
 GROUP BY stat_day, a.chunk_z
 ORDER BY stat_day, a.chunk_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_movement_by_day_chunk_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'chunk xz', chunk_xs
 FROM (
  SELECT stat_day, chunk_z, group_concat(chunk_x order by chunk_x SEPARATOR ';') as chunk_xs from chunkdayenum group by stat_day, chunk_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.chunk_z, group_concat(IFNULL(point_value,0) order by a.chunk_x SEPARATOR ';') as chunk_xs
 FROM chunkdayenum a LEFT OUTER JOIN (
  SELECT stat_day, chunk_z, chunk_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main
  WHERE stat_key = 'player.blockbreak' and string_value like '%CHEST%'
  GROUP BY stat_day, chunk_z, chunk_x
 ) AS s ON s.stat_day = a.stat_day AND s.chunk_z = a.chunk_z AND s.chunk_x = a.chunk_x
 GROUP BY stat_day, a.chunk_z
 ORDER BY stat_day, a.chunk_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_chest_breaking_by_day_chunk_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'chunk xz', chunk_xs
 FROM (
  SELECT stat_day, chunk_z, group_concat(chunk_x order by chunk_x SEPARATOR ';') as chunk_xs from chunkdayenum group by stat_day, chunk_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.chunk_z, group_concat(IFNULL(point_value,0) order by a.chunk_x SEPARATOR ';') as chunk_xs
 FROM chunkdayenum a LEFT OUTER JOIN (
  SELECT stat_day, chunk_z, chunk_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main
  WHERE stat_key LIKE 'entity.death.%' AND NOT stat_key LIKE 'entity.death.xp.%' AND NOT stat_key LIKE 'entity.death.drop.%'
  GROUP BY stat_day, chunk_z, chunk_x
 ) AS s ON s.stat_day = a.stat_day AND s.chunk_z = a.chunk_z AND s.chunk_x = a.chunk_x
 GROUP BY stat_day, a.chunk_z
 ORDER BY stat_day, a.chunk_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_entity_slaughter_by_day_chunk_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'chunk xz', chunk_xs
 FROM (
  SELECT stat_day, chunk_z, group_concat(chunk_x order by chunk_x SEPARATOR ';') as chunk_xs from chunkdayenum group by stat_day, chunk_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.chunk_z, group_concat(IFNULL(point_value,0) order by a.chunk_x SEPARATOR ';') as chunk_xs
 FROM chunkdayenum a LEFT OUTER JOIN (
  SELECT stat_day, chunk_z, chunk_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main
  WHERE stat_key = 'player.died' OR stat_key = 'player.killed'
  GROUP BY stat_day, chunk_z, chunk_x
 ) AS s ON s.stat_day = a.stat_day AND s.chunk_z = a.chunk_z AND s.chunk_x = a.chunk_x
 GROUP BY stat_day, a.chunk_z
 ORDER BY stat_day, a.chunk_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_playerdeath_by_day_chunk_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'chunk xz', chunk_xs
 FROM (
  SELECT stat_day, chunk_z, group_concat(chunk_x order by chunk_x SEPARATOR ';') as chunk_xs from chunkdayenum group by stat_day, chunk_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.chunk_z, group_concat(IFNULL(point_value,0) order by a.chunk_x SEPARATOR ';') as chunk_xs
 FROM chunkdayenum a LEFT OUTER JOIN (
  SELECT stat_day, chunk_z, chunk_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main
  WHERE stat_key = 'player.died' OR (stat_key = 'player.killed' AND NOT string_value LIKE '%-%-%-%-%')
  GROUP BY stat_day, chunk_z, chunk_x
 ) AS s ON s.stat_day = a.stat_day AND s.chunk_z = a.chunk_z AND s.chunk_x = a.chunk_x
 GROUP BY stat_day, a.chunk_z
 ORDER BY stat_day, a.chunk_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_playerenvironmentdeath_by_day_chunk_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'chunk xz', chunk_xs
 FROM (
  SELECT stat_day, chunk_z, group_concat(chunk_x order by chunk_x SEPARATOR ';') as chunk_xs from chunkdayenum group by stat_day, chunk_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.chunk_z, group_concat(IFNULL(point_value,0) order by a.chunk_x SEPARATOR ';') as chunk_xs
 FROM chunkdayenum a LEFT OUTER JOIN (
  SELECT stat_day, chunk_z, chunk_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main
  WHERE stat_key = 'player.killed' AND string_value LIKE '%-%-%-%-%'
  GROUP BY stat_day, chunk_z, chunk_x
 ) AS s ON s.stat_day = a.stat_day AND s.chunk_z = a.chunk_z AND s.chunk_x = a.chunk_x
 GROUP BY stat_day, a.chunk_z
 ORDER BY stat_day, a.chunk_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_playervsplayerdeath_by_day_chunk_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);


-- Invasive internal queries

(SELECT 'first day', 'player', 'days online', 'possible days online')
UNION ALL
(SELECT date(min(stat_time)) as first, uuid, count(distinct date(stat_time) ) as join_days, 
 (datediff((SELECT max(date(stat_time)) FROM spy_stats_all_weeks_login), date(min(stat_time)))+1) as possible_days_rejoin
FROM spy_stats_all_weeks_login GROUP BY uuid
ORDER BY first, join_days DESC
INTO OUTFILE '/tmp/INTERNAL_first_time_players_by_first_day_with_extra.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
);


-- REGION stuff next

(SELECT 'day', 'region xz', region_xs
 FROM (
  SELECT stat_day, region_z, group_concat(region_x order by region_x SEPARATOR ';') as region_xs from regiondayenum group by stat_day, region_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.region_z, group_concat(IFNULL(point_value,0) order by a.region_x SEPARATOR ';') as region_xs
 FROM regiondayenum a LEFT OUTER JOIN (
  SELECT stat_day, region_z, region_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main_region
  WHERE stat_key = 'player.blockplace'
  GROUP BY stat_day, region_z, region_x
 ) AS s ON s.stat_day = a.stat_day AND s.region_z = a.region_z AND s.region_x = a.region_x
 GROUP BY a.stat_day, a.region_z
 ORDER BY a.stat_day, a.region_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_blockplace_by_day_region_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'region xz', region_xs
 FROM (
  SELECT stat_day, region_z, group_concat(region_x order by region_x SEPARATOR ';') as region_xs from regiondayenum group by stat_day, region_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.region_z, group_concat(IFNULL(point_value,0) order by a.region_x SEPARATOR ';') as region_xs
 FROM regiondayenum a LEFT OUTER JOIN (
  SELECT stat_day, region_z, region_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main_region
  WHERE stat_key = 'player.blockbreak'
  GROUP BY stat_day, region_z, region_x
 ) AS s ON s.stat_day = a.stat_day AND s.region_z = a.region_z AND s.region_x = a.region_x
 GROUP BY stat_day, a.region_z
 ORDER BY stat_day, a.region_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_blockbreak_by_day_region_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'region xz', region_xs
 FROM (
  SELECT stat_day, region_z, group_concat(region_x order by region_x SEPARATOR ';') as region_xs from regiondayenum group by stat_day, region_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.region_z, group_concat(IFNULL(point_value,0) order by a.region_x SEPARATOR ';') as region_xs
 FROM regiondayenum a LEFT OUTER JOIN (
  SELECT stat_day, region_z, region_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main_region
  WHERE stat_key = 'player.movement'
  GROUP BY stat_day, region_z, region_x
 ) AS s ON s.stat_day = a.stat_day AND s.region_z = a.region_z AND s.region_x = a.region_x
 GROUP BY stat_day, a.region_z
 ORDER BY stat_day, a.region_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_movement_by_day_region_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'region xz', region_xs
 FROM (
  SELECT stat_day, region_z, group_concat(region_x order by region_x SEPARATOR ';') as region_xs from regiondayenum group by stat_day, region_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.region_z, group_concat(IFNULL(point_value,0) order by a.region_x SEPARATOR ';') as region_xs
 FROM regiondayenum a LEFT OUTER JOIN (
  SELECT stat_day, region_z, region_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main_region
  WHERE stat_key = 'player.blockbreak' and string_value like '%CHEST%'
  GROUP BY stat_day, region_z, region_x
 ) AS s ON s.stat_day = a.stat_day AND s.region_z = a.region_z AND s.region_x = a.region_x
 GROUP BY stat_day, a.region_z
 ORDER BY stat_day, a.region_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_chest_breaking_by_day_region_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'region xz', region_xs
 FROM (
  SELECT stat_day, region_z, group_concat(region_x order by region_x SEPARATOR ';') as region_xs from regiondayenum group by stat_day, region_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.region_z, group_concat(IFNULL(point_value,0) order by a.region_x SEPARATOR ';') as region_xs
 FROM regiondayenum a LEFT OUTER JOIN (
  SELECT stat_day, region_z, region_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main_region
  WHERE stat_key LIKE 'entity.death.%' AND NOT stat_key LIKE 'entity.death.xp.%' AND NOT stat_key LIKE 'entity.death.drop.%'
  GROUP BY stat_day, region_z, region_x
 ) AS s ON s.stat_day = a.stat_day AND s.region_z = a.region_z AND s.region_x = a.region_x
 GROUP BY stat_day, a.region_z
 ORDER BY stat_day, a.region_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_entity_slaughter_by_day_region_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'region xz', region_xs
 FROM (
  SELECT stat_day, region_z, group_concat(region_x order by region_x SEPARATOR ';') as region_xs from regiondayenum group by stat_day, region_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.region_z, group_concat(IFNULL(point_value,0) order by a.region_x SEPARATOR ';') as region_xs
 FROM regiondayenum a LEFT OUTER JOIN (
  SELECT stat_day, region_z, region_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main_region
  WHERE stat_key = 'player.died' OR stat_key = 'player.killed'
  GROUP BY stat_day, region_z, region_x
 ) AS s ON s.stat_day = a.stat_day AND s.region_z = a.region_z AND s.region_x = a.region_x
 GROUP BY stat_day, a.region_z
 ORDER BY stat_day, a.region_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_playerdeath_by_day_region_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'region xz', region_xs
 FROM (
  SELECT stat_day, region_z, group_concat(region_x order by region_x SEPARATOR ';') as region_xs from regiondayenum group by stat_day, region_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.region_z, group_concat(IFNULL(point_value,0) order by a.region_x SEPARATOR ';') as region_xs
 FROM regiondayenum a LEFT OUTER JOIN (
  SELECT stat_day, region_z, region_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main_region
  WHERE stat_key = 'player.died' OR (stat_key = 'player.killed' AND NOT string_value LIKE '%-%-%-%-%')
  GROUP BY stat_day, region_z, region_x
 ) AS s ON s.stat_day = a.stat_day AND s.region_z = a.region_z AND s.region_x = a.region_x
 GROUP BY stat_day, a.region_z
 ORDER BY stat_day, a.region_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_playerenvironmentdeath_by_day_region_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

(SELECT 'day', 'region xz', region_xs
 FROM (
  SELECT stat_day, region_z, group_concat(region_x order by region_x SEPARATOR ';') as region_xs from regiondayenum group by stat_day, region_z limit 1
 ) AS a)
UNION ALL
(SELECT a.stat_day, a.region_z, group_concat(IFNULL(point_value,0) order by a.region_x SEPARATOR ';') as region_xs
 FROM regiondayenum a LEFT OUTER JOIN (
  SELECT stat_day, region_z, region_x, sum(numeric_value) as point_value
  FROM spy_stats_day_main_region
  WHERE stat_key = 'player.killed' AND string_value LIKE '%-%-%-%-%'
  GROUP BY stat_day, region_z, region_x
 ) AS s ON s.stat_day = a.stat_day AND s.region_z = a.region_z AND s.region_x = a.region_x
 GROUP BY stat_day, a.region_z
 ORDER BY stat_day, a.region_z
INTO OUTFILE '/tmp/INTERNAL_heatmap_playervsplayerdeath_by_day_region_granularity.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
);

