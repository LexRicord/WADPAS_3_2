SELECT *
FROM ticker MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        STRT.tstamp AS start_tstamp,
        LAST(DOWN1.tstamp) AS bottom1_tstamp,
        LAST(UP1.tstamp) AS peak1_tstamp,
        LAST(DOWN2.tstamp) AS bottom2_tstamp,
        LAST(UP2.tstamp) AS peak2_tstamp
    ONE ROW PER MATCH
    PATTERN (STRT DOWN1+ UP1 DOWN2+ UP2)
    DEFINE
        DOWN1 AS DOWN1.price < PREV(DOWN1.price),
        UP1 AS UP1.price > PREV(UP1.price),
        DOWN2 AS DOWN2.price < PREV(DOWN2.price),
        UP2 AS UP2.price > PREV(UP2.price)
) MR
ORDER BY MR.symbol, MR.start_tstamp;
--версия с отображением значений котировок
SELECT 
    MR.symbol,
    TO_CHAR(MR.start_tstamp, 'DD.MM.YY') AS start_ts,
    TO_CHAR(MR.bottom1_tstamp, 'DD.MM.YY') AS bottom1_ts,
    TO_CHAR(MR.peak1_tstamp, 'DD.MM.YY') AS peak1_ts,
    TO_CHAR(MR.bottom2_tstamp, 'DD.MM.YY') AS bottom2_ts,
    TO_CHAR(MR.peak2_tstamp, 'DD.MM.YY') AS peak2_tst,
    TICKER1.price AS bottom1_price,
    TICKER2.price AS peak1_price,
    TICKER3.price AS bottom2_price,
    TICKER4.price AS peak2_price
FROM ticker MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        STRT.tstamp AS start_tstamp,
        LAST(DOWN1.tstamp) AS bottom1_tstamp,
        LAST(UP1.tstamp) AS peak1_tstamp,
        LAST(DOWN2.tstamp) AS bottom2_tstamp,
        LAST(UP2.tstamp) AS peak2_tstamp
    ONE ROW PER MATCH
    PATTERN (STRT DOWN1+ UP1 DOWN2+ UP2)
    DEFINE
        DOWN1 AS DOWN1.price < PREV(DOWN1.price),
        UP1 AS UP1.price > PREV(UP1.price),
        DOWN2 AS DOWN2.price < PREV(DOWN2.price),
        UP2 AS UP2.price > PREV(UP2.price)
) MR
JOIN ticker TICKER1 ON MR.symbol = TICKER1.symbol AND MR.bottom1_tstamp = TICKER1.tstamp
JOIN ticker TICKER2 ON MR.symbol = TICKER2.symbol AND MR.peak1_tstamp = TICKER2.tstamp
JOIN ticker TICKER3 ON MR.symbol = TICKER3.symbol AND MR.bottom2_tstamp = TICKER3.tstamp
JOIN ticker TICKER4 ON MR.symbol = TICKER4.symbol AND MR.peak2_tstamp = TICKER4.tstamp
ORDER BY MR.symbol, MR.start_tstamp;
