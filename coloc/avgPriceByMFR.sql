use coloc_wadpas;

select product_id, MFR_ID, PRICE, avg(PRICE) 
over (partition by MFR_ID)/avg(PRICE) 
over () *100 as avgPriceByMFR
from PRODUCTS;