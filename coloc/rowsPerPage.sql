use coloc_wadpas;

--5.Продемонстрируйте применение функции ранжирования 
--ROW_NUMBER() для разбиения результатов запроса на страницы (по 20 строк на каждую страницу).

declare @rowsPerPage int = 20;

SELECT * FROM 
(
  SELECT product_id, MFR_ID, price, ROW_NUMBER() 
	OVER (ORDER BY product_id) AS row_num
  FROM products
) AS numbered_rows
WHERE row_num BETWEEN 0 AND @rowsPerPage;