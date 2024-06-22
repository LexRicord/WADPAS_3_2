use coloc_wadpas;

SELECT product_id, MFR_ID, price, AVG(price) 
OVER ()/ MAX(price) 
OVER () *100 AS avgPriceMax
FROM products;