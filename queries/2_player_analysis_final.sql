-- We want to compare a number of things.
-- For a particular player:
--  1) # of eligible blocks mined
--  2) Generation and Drop events, by type, measuring size
--  3) # of ores mined
--  4) Within those event time slices, how many ores picked up

-- Approach:
--  1) Create data subset with ore and stone-type mining events
--  2) Create data subset with ore and special ore type pickup events
--  3) Combine

-- Outcome:
--   Day
--   Person

-- DROP TABLE IF EXISTS ss_day_player_pickups;
CREATE TABLE IF NOT EXISTS ss_day_player_pickups AS
 SELECT date(stat_time) as `Day`, b.player as `Person`, string_value AS `Item`, sum(numeric_value) as `Pickups` 
  FROM spy_stats_all_weeks a JOIN Name_player b on a.uuid = b.uuid 
  WHERE stat_key = 'player.pickup' AND
    string_value IN (
    'COAL:0', 'COAL_ORE:0', 'COAL:0/Lead{Lead T1}', 'COAL:0/Nickel{Nickel T2}', 'COAL:0/Oil{Oil T3}', 
    'IRON_ORE:0', 'IRON_INGOT:0/Steel{Steel T1}', 'IRON_INGOT:0/Aluminum{Aluminum T2}', 'IRON_INGOT:0/Silicon{Silicon T3}', 
    'GOLD_ORE:0', 'GOLD_INGOT:0/Silver{Silver T1}', 'GOLD_INGOT:0/Pearl{Pearl T2}', 'GOLD_INGOT:0/Artifact{Artifact T3}',
    'INK_SACK:4', 'LAPIS_ORE:0', 'INK_SACK:14/Bronze{Bronze T1}', 'INK_SACK:8/Pewter{Pewter T2}', 'INK_SACK:5/Fiberglass{Fiberglass T3}', 
    'REDSTONE:0', 'REDSTONE_ORE:0', 'REDSTONE:0/Copper{Copper T1}', 'REDSTONE:0/Brass{Brass T2}', 'REDSTONE:0/Graphite{Graphite T3}', 
    'DIAMOND:0', 'DIAMOND_ORE:0', 'DIAMOND:0/Titanium{Titanium T1}', 'DIAMOND:0/Platinum{Platinum T2}', 'DIAMOND:0/Carbon{Carbon T3}',  
    'EMERALD:0', 'EMERALD_ORE:0', 'EMERALD:0/Mercury{Mercury T1}', 'EMERALD:0/Enderite{Enderite T2}', 'EMERALD:0/Uranium{Uranium T3}' 
    ) AND 
    server = 'devoted' AND world = 'world'
  GROUP BY date(stat_time), b.player, string_value
  ORDER BY date(stat_time), b.player, string_value;

-- DROP TABLE IF EXISTS ss_day_player_mined;
CREATE TABLE IF NOT EXISTS ss_day_player_mined AS 
 SELECT date(stat_time) as `Day`, b.player as `Person`, string_value as `Item`, sum(numeric_value) as `Mined` 
  FROM spy_stats_all_weeks a JOIN Name_player b on a.uuid = b.uuid 
  WHERE stat_key = 'player.blockbreak' AND
    string_value IN (
    'STONE',
    'STONE:0',
    'STONE:1',
    'STONE:3',
    'STONE:5',
    'COAL_ORE',
    'IRON_ORE',
    'GOLD_ORE',
    'LAPIS_ORE',
    'REDSTONE_ORE',
    'DIAMOND_ORE',
    'EMERALD_ORE'
    ) AND 
    server = 'devoted' AND world = 'world'
  GROUP BY date(stat_time), b.player, string_value 
  ORDER BY date(stat_time), b.player, string_value;

-- DROP TABLE IF EXISTS ss_day_player_hiddenore;
CREATE TABLE IF NOT EXISTS ss_day_player_hiddenore AS
 SELECT date(event_time) as `Day`, name as `Person`, outcome as `Item`, h_type as `Item_Subtype`, 
    count(*) as `Events`, sum(node_size) as `Total`
  FROM hiddenore_data 
  GROUP BY date(event_time), name, outcome, h_type
  ORDER BY date(event_time), name, outcome, h_type;

DROP TABLE IF EXISTS ss_day_player_full;
CREATE TABLE IF NOT EXISTS ss_day_player_full AS 
  SELECT * FROM 
    ((SELECT `Day` FROM ss_day_player_pickups) 
      UNION
     (SELECT `Day` FROM ss_day_player_mined)
      UNION
     (SELECT `Day` FROM ss_day_player_hiddenore)) AS A
    CROSS JOIN
     ((SELECT `Person` FROM ss_day_player_mined GROUP BY `Person` ORDER BY sum(`Mined`) DESC LIMIT 100)
      UNION
     (SELECT `Person` FROM ss_day_player_hiddenore GROUP BY `Person` ORDER BY sum(`Events`) DESC LIMIT 100)) AS B
    ORDER BY `Person`, `Day`;

DROP TABLE IF EXISTS ss_day_basic_data;
DROP TABLE IF EXISTS ss_day_extended_data;

CREATE TEMPORARY TABLE ss_day_basic_data AS
 SELECT a.`Day`, a.`Person`, g1.`# Stone Mined`, g2.`# of HO Events`, g2.`Total Gen/Drops`, g3.`# Mined`, g4.`# Pickups`,
  c1.`Coal Ore Generated`, c2.`Coal Ore Mined`, c4.`Coal Ore Pickup`, c3.`Coal Pickup`,
  i1.`Iron Ore Generated`, i2.`Iron Ore Mined`, i3.`Iron Ore Pickup`, 
  j1.`Gold Ore Generated`, j2.`Gold Ore Mined`, j3.`Gold Ore Pickup`, 
  l1.`Lapis Ore Generated`, l2.`Lapis Ore Mined`, l4.`Lapis Ore Pickup`, l3.`Lapis Lazuli Pickup`,
  r1.`Redstone Ore Generated`, r2.`Redstone Ore Mined`, r4.`Redstone Ore Pickup`, r3.`Redstone Pickup`,
  d1.`Diamond Ore Generated`, d2.`Diamond Ore Mined`, d4.`Diamond Ore Pickup`, d3.`Diamond Pickup`,
  e1.`Emerald Ore Generated`, e2.`Emerald Ore Mined`, e4.`Emerald Ore Pickup`, e3.`Emerald Pickup`
  FROM ss_day_player_full a
  LEFT OUTER JOIN (
-- d   # of stone-types mined
SELECT `Day`, `Person`, sum(`Mined`) as `# Stone Mined` 
  FROM ss_day_player_mined 
  WHERE `Item` IN ('STONE', 'STONE:0', 'STONE:1', 'STONE:3', 'STONE:5')
  GROUP BY `Day`, `Person`
) AS g1 ON a.`Day` = g1.`Day` AND a.`Person` = g1.`Person`
  LEFT OUTER JOIN (
-- d   total # of generation/drop events
-- d   total size of all generation/drop events
SELECT `Day`, `Person`, sum(`Events`) as `# of HO Events`, sum(`Total`) as `Total Gen/Drops`
  FROM ss_day_player_hiddenore
  GROUP BY `Day`, `Person`
) AS g2 ON a.`Day` = g2.`Day` AND a.`Person` = g2.`Person`
  LEFT OUTER JOIN (
-- d   total # of same-type mined
SELECT `Day`, `Person`, sum(`Mined`) as `# Mined` 
  FROM ss_day_player_mined
  WHERE `Item` IN (
    'COAL_ORE',
    'IRON_ORE',
    'GOLD_ORE',
    'LAPIS_ORE',
    'REDSTONE_ORE',
    'DIAMOND_ORE',
    'EMERALD_ORE'
    )
  GROUP BY `Day`, `Person`
) AS g3 ON a.`Day` = g3.`Day` AND a.`Person` = g3.`Person`
  LEFT OUTER JOIN (
-- d   total # of same-type pickups
SELECT `Day`, `Person`, sum(`Pickups`) as `# Pickups` 
  FROM ss_day_player_pickups
  GROUP BY `Day`, `Person`
) AS g4 ON a.`Day` = g4.`Day` AND a.`Person` = g4.`Person`
  LEFT OUTER JOIN (
-- d   sum of Coal Ore generated
SELECT `Day`, `Person`, sum(`Total`) as `Coal Ore Generated`
  FROM ss_day_player_hiddenore WHERE `Item` IN ('COAL_ORE:0', 'Coal') and `Item_Subtype` = 1
  GROUP BY `Day`, `Person`
) AS c1 ON a.`Day` = c1.`Day` AND a.`Person` = c1.`Person`
  LEFT OUTER JOIN (
--   sum of Coal Ore mined
SELECT `Day`, `Person`, sum(`Mined`) as `Coal Ore Mined` 
  FROM ss_day_player_mined WHERE `Item` = 'COAL_ORE'
  GROUP BY `Day`, `Person`
) AS c2 ON a.`Day` = c2.`Day` AND a.`Person` = c2.`Person`
  LEFT OUTER JOIN (
--   sum of Coal Ore picked up
SELECT `Day`, `Person`, sum(`Pickups`) as `Coal Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'COAL:0' 
  GROUP BY `Day`, `Person`
) AS c3 ON a.`Day` = c3.`Day` AND a.`Person` = c3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Coal Ore Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'COAL_ORE:0' 
  GROUP BY `Day`, `Person`
) AS c4 ON a.`Day` = c4.`Day` AND a.`Person` = c4.`Person`
  LEFT OUTER JOIN (
--   sum of Iron Ore generated
SELECT `Day`, `Person`, sum(`Total`) as `Iron Ore Generated`
  FROM ss_day_player_hiddenore WHERE `Item` IN ('IRON_ORE:0', 'Iron') and `Item_Subtype` = 1
  GROUP BY `Day`, `Person`
) AS i1 ON a.`Day` = i1.`Day` AND a.`Person` = i1.`Person`
  LEFT OUTER JOIN (
--   sum of Iron Ore mined
SELECT `Day`, `Person`, sum(`Mined`) as `Iron Ore Mined` 
  FROM ss_day_player_mined WHERE `Item` = 'IRON_ORE'
  GROUP BY `Day`, `Person`
) AS i2 ON a.`Day` = i2.`Day` AND a.`Person` = i2.`Person`
  LEFT OUTER JOIN (
--   sum of Iron Ore picked up
SELECT `Day`, `Person`, sum(`Pickups`) as `Iron Ore Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'IRON_ORE:0' 
  GROUP BY `Day`, `Person`
) AS i3 ON a.`Day` = i3.`Day` AND a.`Person` = i3.`Person`
  LEFT OUTER JOIN (
--   sum of Gold Ore generated
SELECT `Day`, `Person`, sum(`Total`) as `Gold Ore Generated`
  FROM ss_day_player_hiddenore WHERE `Item` IN ('GOLD_ORE:0', 'Gold') and `Item_Subtype` = 1
  GROUP BY `Day`, `Person`
) AS j1 ON a.`Day` = j1.`Day` AND a.`Person` = j1.`Person`
  LEFT OUTER JOIN (
--   sum of Gold Ore mined
SELECT `Day`, `Person`, sum(`Mined`) as `Gold Ore Mined` 
  FROM ss_day_player_mined WHERE `Item` = 'GOLD_ORE'
  GROUP BY `Day`, `Person`
) AS j2 ON a.`Day` = j2.`Day` AND a.`Person` = j2.`Person`
  LEFT OUTER JOIN (
--   sum of Gold ore picked up
SELECT `Day`, `Person`, sum(`Pickups`) as `Gold Ore Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'GOLD_ORE:0' 
  GROUP BY `Day`, `Person`
) AS j3 ON a.`Day` = j3.`Day` AND a.`Person` = j3.`Person`
  LEFT OUTER JOIN (
--   ''' Lapis Lazuli Ore '''
SELECT `Day`, `Person`, sum(`Total`) as `Lapis Ore Generated`
  FROM ss_day_player_hiddenore WHERE `Item` IN ('LAPIS_ORE:0', 'Lapis') and `Item_Subtype` = 1
  GROUP BY `Day`, `Person`
) AS l1 ON a.`Day` = l1.`Day` AND a.`Person` = l1.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Mined`) as `Lapis Ore Mined` 
  FROM ss_day_player_mined WHERE `Item` = 'LAPIS_ORE'
  GROUP BY `Day`, `Person`
) AS l2 ON a.`Day` = l2.`Day` AND a.`Person` = l2.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Lapis Lazuli Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'INK_SACK:4' 
  GROUP BY `Day`, `Person`
) AS l3 ON a.`Day` = l3.`Day` AND a.`Person` = l3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Lapis Ore Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'LAPIS_ORE:0' 
  GROUP BY `Day`, `Person`
) AS l4 ON a.`Day` = l4.`Day` AND a.`Person` = l4.`Person`
  LEFT OUTER JOIN (
--   ''' Redstone Ore '''
SELECT `Day`, `Person`, sum(`Total`) as `Redstone Ore Generated`
  FROM ss_day_player_hiddenore WHERE `Item` IN ('REDSTONE_ORE:0', 'Redstone') and `Item_Subtype` = 1
  GROUP BY `Day`, `Person`
) AS r1 ON a.`Day` = r1.`Day` AND a.`Person` = r1.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Mined`) as `Redstone Ore Mined` 
  FROM ss_day_player_mined WHERE `Item` IN ( 'REDSTONE_ORE', 'GLOWING_REDSTONE_ORE' )
  GROUP BY `Day`, `Person`
) AS r2 ON a.`Day` = r2.`Day` AND a.`Person` = r2.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Redstone Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'REDSTONE:0' 
  GROUP BY `Day`, `Person`
) AS r3 ON a.`Day` = r3.`Day` AND a.`Person` = r3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Redstone Ore Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'REDSTONE_ORE:0' 
  GROUP BY `Day`, `Person`
) AS r4 ON a.`Day` = r4.`Day` AND a.`Person` = r4.`Person`
  LEFT OUTER JOIN (
--   ''' Diamond Ore '''
SELECT `Day`, `Person`, sum(`Total`) as `Diamond Ore Generated`
  FROM ss_day_player_hiddenore WHERE `Item` IN ('DIAMOND_ORE:0', 'Diamond') and `Item_Subtype` = 1
  GROUP BY `Day`, `Person`
) AS d1 ON a.`Day` = d1.`Day` AND a.`Person` = d1.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Mined`) as `Diamond Ore Mined` 
  FROM ss_day_player_mined WHERE `Item` = 'DIAMOND_ORE'
  GROUP BY `Day`, `Person`
) AS d2 ON a.`Day` = d2.`Day` AND a.`Person` = d2.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Diamond Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'DIAMOND:0' 
  GROUP BY `Day`, `Person`
) AS d3 ON a.`Day` = d3.`Day` AND a.`Person` = d3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Diamond Ore Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'DIAMOND_ORE:0' 
  GROUP BY `Day`, `Person`
) AS d4 ON a.`Day` = d4.`Day` AND a.`Person` = d4.`Person`
  LEFT OUTER JOIN (
--   ''' Emerald Ore '''
SELECT `Day`, `Person`, sum(`Total`) as `Emerald Ore Generated`
  FROM ss_day_player_hiddenore WHERE `Item` IN ('EMERALD_ORE:0', 'Emerald') and `Item_Subtype` = 1
  GROUP BY `Day`, `Person`
) AS e1 ON a.`Day` = e1.`Day` AND a.`Person` = e1.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Mined`) as `Emerald Ore Mined` 
  FROM ss_day_player_mined WHERE `Item` = 'EMERALD_ORE'
  GROUP BY `Day`, `Person`
) AS e2 ON a.`Day` = e2.`Day` AND a.`Person` = e2.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Emerald Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'EMERALD:0' 
  GROUP BY `Day`, `Person`
) AS e3 ON a.`Day` = e3.`Day` AND a.`Person` = e3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Emerald Ore Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'EMERALD_ORE:0' 
  GROUP BY `Day`, `Person`
) AS e4 ON a.`Day` = e4.`Day` AND a.`Person` = e4.`Person`
  GROUP BY `Day`, `Person`
  ORDER BY `Person`, `Day`;

CREATE TEMPORARY TABLE ss_day_extended_data AS
 SELECT a.`Day`, a.`Person`,
  cc1.`Lead Dropped`, cc2.`Lead Pickup`, cc3.`Nickel Dropped`, cc4.`Nickel Pickup`, cc5.`Oil Dropped`, cc6.`Oil Pickup`,
  ii1.`Steel Dropped`, ii2.`Steel Pickup`, ii3.`Aluminum Dropped`, ii4.`Aluminum Pickup`, ii5.`Silicon Dropped`, ii6.`Silicon Pickup`,
  jj1.`Bronze Dropped`, jj2.`Bronze Pickup`, jj3.`Pewter Dropped`, jj4.`Pewter Pickup`, jj5.`Fiberglass Dropped`, jj6.`Fiberglass Pickup`,
  ll1.`Silver Dropped`, ll2.`Silver Pickup`, ll3.`Pearl Dropped`, ll4.`Pearl Pickup`, ll5.`Artifact Dropped`, ll6.`Artifact Pickup`,
  rr1.`Copper Dropped`, rr2.`Copper Pickup`, rr3.`Brass Dropped`, rr4.`Brass Pickup`, rr5.`Graphite Dropped`, rr6.`Graphite Pickup`,
  dd1.`Titanium Dropped`, dd2.`Titanium Pickup`, dd3.`Platinum Dropped`, dd4.`Platinum Pickup`, dd5.`Carbon Dropped`, dd6.`Carbon Pickup`,
  ee1.`Mercury Dropped`, ee2.`Mercury Pickup`, ee3.`Enderite Dropped`, ee4.`Enderite Pickup`, ee5.`Uranium Dropped`, ee6.`Uranium Pickup`
  FROM ss_day_player_full a
  LEFT OUTER JOIN (
--   sum of Lead generated
SELECT `Day`, `Person`, sum(`Total`) as `Lead Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Lead' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS cc1 ON a.`Day` = cc1.`Day` AND a.`Person` = cc1.`Person`
  LEFT OUTER JOIN (
--   sum of Lead picked up
SELECT `Day`, `Person`, sum(`Pickups`) as `Lead Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'COAL:0/Lead{Lead T1}' 
  GROUP BY `Day`, `Person`
) AS cc2 ON a.`Day` = cc2.`Day` AND a.`Person` = cc2.`Person`
  LEFT OUTER JOIN (
--   sum of Nickel generated
SELECT `Day`, `Person`, sum(`Total`) as `Nickel Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Nickel' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS cc3 ON a.`Day` = cc3.`Day` AND a.`Person` = cc3.`Person`
  LEFT OUTER JOIN (
--   sum of Nickel picked up
SELECT `Day`, `Person`, sum(`Pickups`) as `Nickel Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'COAL:0/Nickel{Nickel T2}' 
  GROUP BY `Day`, `Person`
) AS cc4 ON a.`Day` = cc4.`Day` AND a.`Person` = cc4.`Person`
  LEFT OUTER JOIN (
--   sum of Oil generated
SELECT `Day`, `Person`, sum(`Total`) as `Oil Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Oil' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS cc5 ON a.`Day` = cc5.`Day` AND a.`Person` = cc5.`Person`
  LEFT OUTER JOIN (
--   sum of Oil picked up
SELECT `Day`, `Person`, sum(`Pickups`) as `Oil Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'COAL:0/Oil{Oil T3}' 
  GROUP BY `Day`, `Person`
) AS cc6 ON a.`Day` = cc6.`Day` AND a.`Person` = cc6.`Person`
  LEFT OUTER JOIN (
--   sum of Steel generated
SELECT `Day`, `Person`, sum(`Total`) as `Steel Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Steel' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS ii1 ON a.`Day` = ii1.`Day` AND a.`Person` = ii1.`Person`
  LEFT OUTER JOIN (
--   sum of Steel picked up
SELECT `Day`, `Person`, sum(`Pickups`) as `Steel Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'IRON_INGOT:0/Steel{Steel T1}' 
  GROUP BY `Day`, `Person`
) AS ii2 ON a.`Day` = ii2.`Day` AND a.`Person` = ii2.`Person`
  LEFT OUTER JOIN (
--   ''' Aluminum '''
SELECT `Day`, `Person`, sum(`Total`) as `Aluminum Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Aluminum' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS ii3 ON a.`Day` = ii3.`Day` AND a.`Person` = ii3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Aluminum Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'IRON_INGOT:0/Aluminum{Aluminum T2}' 
  GROUP BY `Day`, `Person`
) AS ii4 ON a.`Day` = ii4.`Day` AND a.`Person` = ii4.`Person`
  LEFT OUTER JOIN (
--   ''' Silicon '''
SELECT `Day`, `Person`, sum(`Total`) as `Silicon Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Silicon' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS ii5 ON a.`Day` = ii5.`Day` AND a.`Person` = ii5.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Silicon Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'IRON_INGOT:0/Silicon{Silicon T3}' 
  GROUP BY `Day`, `Person`
) AS ii6 ON a.`Day` = ii6.`Day` AND a.`Person` = ii6.`Person`
  LEFT OUTER JOIN (
--   ''' Bronze '''
SELECT `Day`, `Person`, sum(`Total`) as `Bronze Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Bronze' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS jj1 ON a.`Day` = jj1.`Day` AND a.`Person` = jj1.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Bronze Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'INK_SACK:14/Bronze{Bronze T1}' 
  GROUP BY `Day`, `Person`
) AS jj2 ON a.`Day` = jj2.`Day` AND a.`Person` = jj2.`Person`
  LEFT OUTER JOIN (
--   ''' Pewter '''
SELECT `Day`, `Person`, sum(`Total`) as `Pewter Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Pewter' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS jj3 ON a.`Day` = jj3.`Day` AND a.`Person` = jj3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Pewter Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'INK_SACK:8/Pewter{Pewter T2}' 
  GROUP BY `Day`, `Person`
) AS jj4 ON a.`Day` = jj4.`Day` AND a.`Person` = jj4.`Person`
  LEFT OUTER JOIN (
--   ''' Fiberglass '''
SELECT `Day`, `Person`, sum(`Total`) as `Fiberglass Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Fiberglass' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS jj5 ON a.`Day` = jj5.`Day` AND a.`Person` = jj5.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Fiberglass Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'INK_SACK:5/Fiberglass{Fiberglass T3}' 
  GROUP BY `Day`, `Person`
) AS jj6 ON a.`Day` = jj6.`Day` AND a.`Person` = jj6.`Person`
  LEFT OUTER JOIN (
--   ''' Silver '''
SELECT `Day`, `Person`, sum(`Total`) as `Silver Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Silver' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS ll1 ON a.`Day` = ll1.`Day` AND a.`Person` = ll1.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Silver Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'GOLD_INGOT:0/Silver{Silver T1}' 
  GROUP BY `Day`, `Person`
) AS ll2 ON a.`Day` = ll2.`Day` AND a.`Person` = ll2.`Person`
  LEFT OUTER JOIN (
--   ''' Pearl '''
SELECT `Day`, `Person`, sum(`Total`) as `Pearl Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Pearl' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS ll3 ON a.`Day` = ll3.`Day` AND a.`Person` = ll3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Pearl Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'GOLD_INGOT:0/Pearl{Pearl T2}' 
  GROUP BY `Day`, `Person`
) AS ll4 ON a.`Day` = ll4.`Day` AND a.`Person` = ll4.`Person`
  LEFT OUTER JOIN (
--   ''' Artifact '''
SELECT `Day`, `Person`, sum(`Total`) as `Artifact Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Artifact' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS ll5 ON a.`Day` = ll5.`Day` AND a.`Person` = ll5.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Artifact Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'GOLD_INGOT:0/Artifact{Artifact T3}' 
  GROUP BY `Day`, `Person`
) AS ll6 ON a.`Day` = ll6.`Day` AND a.`Person` = ll6.`Person`
  LEFT OUTER JOIN (
--   ''' Copper '''
SELECT `Day`, `Person`, sum(`Total`) as `Copper Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Copper' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS rr1 ON a.`Day` = rr1.`Day` AND a.`Person` = rr1.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Copper Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'REDSTONE:0/Copper{Copper T1}' 
  GROUP BY `Day`, `Person`
) AS rr2 ON a.`Day` = rr2.`Day` AND a.`Person` = rr2.`Person`
  LEFT OUTER JOIN (
--   ''' Brass '''
SELECT `Day`, `Person`, sum(`Total`) as `Brass Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Brass' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS rr3 ON a.`Day` = rr3.`Day` AND a.`Person` = rr3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Brass Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'REDSTONE:0/Brass{Brass T2}' 
  GROUP BY `Day`, `Person`
) AS rr4 ON a.`Day` = rr4.`Day` AND a.`Person` = rr4.`Person`
  LEFT OUTER JOIN (
--   ''' Graphite '''
SELECT `Day`, `Person`, sum(`Total`) as `Graphite Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Graphite' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS rr5 ON a.`Day` = rr5.`Day` AND a.`Person` = rr5.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Graphite Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'REDSTONE:0/Graphite{Graphite T3}' 
  GROUP BY `Day`, `Person`
) AS rr6 ON a.`Day` = rr6.`Day` AND a.`Person` = rr6.`Person`
  LEFT OUTER JOIN (
--   ''' Titanium '''
SELECT `Day`, `Person`, sum(`Total`) as `Titanium Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Titanium' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS dd1 ON a.`Day` = dd1.`Day` AND a.`Person` = dd1.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Titanium Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'DIAMOND:0/Titanium{Titanium T1}' 
  GROUP BY `Day`, `Person`
) AS dd2 ON a.`Day` = dd2.`Day` AND a.`Person` = dd2.`Person`
  LEFT OUTER JOIN (
--   ''' Platinum '''
SELECT `Day`, `Person`, sum(`Total`) as `Platinum Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Platinum' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS dd3 ON a.`Day` = dd3.`Day` AND a.`Person` = dd3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Platinum Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'DIAMOND:0/Platinum{Platinum T2}' 
  GROUP BY `Day`, `Person`
) AS dd4 ON a.`Day` = dd4.`Day` AND a.`Person` = dd4.`Person`
  LEFT OUTER JOIN (
--   ''' Carbon '''
SELECT `Day`, `Person`, sum(`Total`) as `Carbon Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Carbon' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS dd5 ON a.`Day` = dd5.`Day` AND a.`Person` = dd5.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Carbon Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'DIAMOND:0/Carbon{Carbon T3}' 
  GROUP BY `Day`, `Person`
) AS dd6 ON a.`Day` = dd6.`Day` AND a.`Person` = dd6.`Person`
  LEFT OUTER JOIN (
--   ''' Mercury '''
SELECT `Day`, `Person`, sum(`Total`) as `Mercury Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Mercury' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS ee1 ON a.`Day` = ee1.`Day` AND a.`Person` = ee1.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Mercury Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'EMERALD:0/Mercury{Mercury T1}' 
  GROUP BY `Day`, `Person`
) AS ee2 ON a.`Day` = ee2.`Day` AND a.`Person` = ee2.`Person`
  LEFT OUTER JOIN (
--   ''' Enderite '''
SELECT `Day`, `Person`, sum(`Total`) as `Enderite Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Enderite' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS ee3 ON a.`Day` = ee3.`Day` AND a.`Person` = ee3.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Enderite Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'EMERALD:0/Enderite{Enderite T2}' 
  GROUP BY `Day`, `Person`
) AS ee4 ON a.`Day` = ee4.`Day` AND a.`Person` = ee4.`Person`
  LEFT OUTER JOIN (
--   ''' Uranium '''
SELECT `Day`, `Person`, sum(`Total`) as `Uranium Dropped`
  FROM ss_day_player_hiddenore WHERE `Item` = 'Uranium' and `Item_Subtype` = 0
  GROUP BY `Day`, `Person`
) AS ee5 ON a.`Day` = ee5.`Day` AND a.`Person` = ee5.`Person`
  LEFT OUTER JOIN (
SELECT `Day`, `Person`, sum(`Pickups`) as `Uranium Pickup` 
  FROM ss_day_player_pickups WHERE `Item` = 'EMERALD:0/Uranium{Uranium T3}' 
  GROUP BY `Day`, `Person`
) AS ee6 ON a.`Day` = ee6.`Day` AND a.`Person` = ee6.`Person`
  GROUP BY `Day`, `Person`
  ORDER BY `Person`, `Day`;

-- TODO add titles



( SELECT 'Day', 'Person', '# Stone Mined', '# of HO Events', 'Total Gen/Drops', '# Mined', '# Pickups',
  'Coal Ore Generated', 'Coal Ore Mined', 'Coal Ore Pickup', 'Coal Pickup',
  'Iron Ore Generated', 'Iron Ore Mined', 'Iron Ore Pickup', 
  'Gold Ore Generated', 'Gold Ore Mined', 'Gold Ore Pickup', 
  'Lapis Ore Generated', 'Lapis Ore Mined', 'Lapis Ore Pickup', 'Lapis Lazuli Pickup',
  'Redstone Ore Generated', 'Redstone Ore Mined', 'Redstone Ore Pickup', 'Redstone Pickup',
  'Diamond Ore Generated', 'Diamond Ore Mined', 'Diamond Ore Pickup', 'Diamond Pickup',
  'Emerald Ore Generated', 'Emerald Ore Mined', 'Emerald Ore Pickup', 'Emerald Pickup',
  'Lead Dropped', 'Lead Pickup', 'Nickel Dropped', 'Nickel Pickup', 'Oil Dropped', 'Oil Pickup',
  'Steel Dropped', 'Steel Pickup', 'Aluminum Dropped', 'Aluminum Pickup', 'Silicon Dropped', 'Silicon Pickup',
  'Silver Dropped', 'Silver Pickup', 'Pearl Dropped', 'Pearl Pickup', 'Artifact Dropped', 'Artifact Pickup',
  'Bronze Dropped', 'Bronze Pickup', 'Pewter Dropped', 'Pewter Pickup', 'Fiberglass Dropped', 'Fiberglass Pickup',
  'Copper Dropped', 'Copper Pickup', 'Brass Dropped', 'Brass Pickup', 'Graphite Dropped', 'Graphite Pickup',
  'Titanium Dropped', 'Titanium Pickup', 'Platinum Dropped', 'Platinum Pickup', 'Carbon Dropped', 'Carbon Pickup',
  'Mercury Dropped', 'Mercury Pickup', 'Enderite Dropped', 'Enderite Pickup', 'Uranium Dropped', 'Uranium Pickup' )
UNION
( SELECT a.`Day`, a.`Person`, a.`# Stone Mined`, a.`# of HO Events`, a.`Total Gen/Drops`, a.`# Mined`, a.`# Pickups`,
  a.`Coal Ore Generated`, a.`Coal Ore Mined`, a.`Coal Ore Pickup`, a.`Coal Pickup`,
  a.`Iron Ore Generated`, a.`Iron Ore Mined`, a.`Iron Ore Pickup`, 
  a.`Gold Ore Generated`, a.`Gold Ore Mined`, a.`Gold Ore Pickup`, 
  a.`Lapis Ore Generated`, a.`Lapis Ore Mined`, a.`Lapis Ore Pickup`, a.`Lapis Lazuli Pickup`,
  a.`Redstone Ore Generated`, a.`Redstone Ore Mined`, a.`Redstone Ore Pickup`, a.`Redstone Pickup`,
  a.`Diamond Ore Generated`, a.`Diamond Ore Mined`, a.`Diamond Ore Pickup`, a.`Diamond Pickup`,
  a.`Emerald Ore Generated`, a.`Emerald Ore Mined`, a.`Emerald Ore Pickup`, a.`Emerald Pickup`,
  b.`Lead Dropped`, b.`Lead Pickup`, b.`Nickel Dropped`, b.`Nickel Pickup`, b.`Oil Dropped`, b.`Oil Pickup`,
  b.`Steel Dropped`, b.`Steel Pickup`, b.`Aluminum Dropped`, b.`Aluminum Pickup`, b.`Silicon Dropped`, b.`Silicon Pickup`,
  b.`Silver Dropped`, b.`Silver Pickup`, b.`Pearl Dropped`, b.`Pearl Pickup`, b.`Artifact Dropped`, b.`Artifact Pickup`,
  b.`Bronze Dropped`, b.`Bronze Pickup`, b.`Pewter Dropped`, b.`Pewter Pickup`, b.`Fiberglass Dropped`, b.`Fiberglass Pickup`,
  b.`Copper Dropped`, b.`Copper Pickup`, b.`Brass Dropped`, b.`Brass Pickup`, b.`Graphite Dropped`, b.`Graphite Pickup`,
  b.`Titanium Dropped`, b.`Titanium Pickup`, b.`Platinum Dropped`, b.`Platinum Pickup`, b.`Carbon Dropped`, b.`Carbon Pickup`,
  b.`Mercury Dropped`, b.`Mercury Pickup`, b.`Enderite Dropped`, b.`Enderite Pickup`, b.`Uranium Dropped`, b.`Uranium Pickup`
  FROM ss_day_basic_data a
  LEFT OUTER JOIN ss_day_extended_data b
  ON a.`Day` = b.`Day` AND a.`Person` = b.`Person`
  GROUP BY a.`Day`, a.`Person`
  ORDER BY a.`Person`, a.`Day`
  INTO OUTFILE '/tmp/INTERNAL_full_mining_analysis.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n');


