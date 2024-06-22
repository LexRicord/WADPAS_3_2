use coloc_wadpas;

SELECT ORDER_NUM, ORDER_DATE, COUNT(*) 
  OVER (PARTITION BY MONTH(order_date)) AS ordersCountByMonth
FROM orders;