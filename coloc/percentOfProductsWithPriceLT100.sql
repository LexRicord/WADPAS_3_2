use coloc_wadpas;

SELECT product_id, MFR_ID, price, 100 * COUNT(CASE WHEN p.price < 100 THEN 1 END) 
OVER ()/COUNT(*) OVER () AS percentOfProductsWithPriceLT100
FROM products p;