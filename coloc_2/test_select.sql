--угол вниз
select *
from Ticker MATCH_RECOGNIZE (
	PARTITION BY symbol
	order by tstamp
	measures strt.tstamp as start_tstamp,
		 last(DOWN.tstamp) as bottom_tstampo,
		 last(UP.tstamp) as end_tstamp
	one row per match
	after match skip to last up
	pattern (strt down+ up+)
	define
		DOWN as DOWN.price < PREV(DOWN.price),
		UP as UP.price > PREV(UP.price)
	) MR
ORDER BY MR.symbol, MR.start_tstamp;
--угол вверх
select *
from Ticker MATCH_RECOGNIZE (
	PARTITION BY symbol
	order by tstamp
	measures strt.tstamp as start_tstamp,
		 last(UP.tstamp) as peak_tstampo,
		 last(DOWN.tstamp) as end_tstamp
	one row per match
	after match skip to last up
	pattern (strt down+ up+)
	define
		DOWN as DOWN.price < PREV(DOWN.price),
		UP as UP.price > PREV(UP.price)
	) MR
ORDER BY MR.symbol, MR.start_tstamp;

