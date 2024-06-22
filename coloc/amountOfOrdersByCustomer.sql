use coloc_wadpas;

SELECT DISTINCT o.MFR,
    FIRST_VALUE(o.CUST) OVER (PARTITION BY o.MFR ORDER BY num_orders DESC) AS CUST,
    MAX(num_orders) OVER (PARTITION BY o.MFR) AS numOrders
FROM orders o
JOIN 
(
    SELECT o.MFR, o.CUST,
        COUNT(*) OVER (PARTITION BY o.MFR, o.CUST) AS num_orders
    FROM orders o
) t
ON o.MFR = t.MFR AND o.CUST = t.CUST;