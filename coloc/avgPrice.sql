use coloc_wadpas;

SELECT product_id, MFR_ID, price, AVG(price) 
OVER () AS avg_price 
FROM products;