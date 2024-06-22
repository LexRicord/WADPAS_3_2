use coloc_wadpas;

declare @ordersAmount int = 6;
--8 Return [sumOfAmount] for last N orders
SELECT * FROM 
(
    SELECT ORDER_NUM,ORDER_DATE,AMOUNT, 
	ROW_NUMBER() OVER (ORDER BY ORDER_DATE) AS rowNum,
    SUM(AMOUNT) OVER (ORDER BY ORDER_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sumAmount
    FROM orders
) subquery
WHERE rowNum = @ordersAmount;