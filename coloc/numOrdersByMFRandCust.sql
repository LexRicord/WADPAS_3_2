use coloc_wadpas;

SELECT o.MFR, o.CUST,
	COUNT(*) OVER (PARTITION BY o.MFR,o.CUST) AS numOrdersByMFRandCust
FROM orders o;