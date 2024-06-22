USE wadpas_lab;
SELECT 
    YEAR(RentalStartDate) AS Год,
    MONTH(RentalStartDate) AS Месяц,
    'Год' AS Период,
    CASE
        WHEN MONTH(RentalStartDate) BETWEEN 1 AND 3 THEN '1-й квартал'
        WHEN MONTH(RentalStartDate) BETWEEN 4 AND 6 THEN '2-й квартал'
        WHEN MONTH(RentalStartDate) BETWEEN 7 AND 9 THEN '3-й квартал'
        WHEN MONTH(RentalStartDate) BETWEEN 10 AND 12 THEN '4-й квартал'
        ELSE NULL
    END AS Квартал,
    CASE
        WHEN MONTH(RentalStartDate) BETWEEN 1 AND 6 THEN '1-я половина'
        WHEN MONTH(RentalStartDate) BETWEEN 7 AND 12 THEN '2-я половина'
        ELSE NULL
    END AS Половина_года,
    AVG(TotalCost) AS Средняя_стоимость_аренды
FROM Rentals
GROUP BY 
    YEAR(RentalStartDate),
    MONTH(RentalStartDate),
    CASE
        WHEN MONTH(RentalStartDate) BETWEEN 1 AND 3 THEN '1-й квартал'
        WHEN MONTH(RentalStartDate) BETWEEN 4 AND 6 THEN '2-й квартал'
        WHEN MONTH(RentalStartDate) BETWEEN 7 AND 9 THEN '3-й квартал'
        WHEN MONTH(RentalStartDate) BETWEEN 10 AND 12 THEN '4-й квартал'
        ELSE NULL
    END,
    CASE
        WHEN MONTH(RentalStartDate) BETWEEN 1 AND 6 THEN '1-я половина'
        WHEN MONTH(RentalStartDate) BETWEEN 7 AND 12 THEN '2-я половина'
        ELSE NULL
    END
HAVING COUNT(*) > 0
ORDER BY Год, Месяц, Период, Квартал;
--task6
DECLARE @EquipmentID INT = 2; 
DECLARE @UserID INT = 9;
DECLARE @StartDate DATETIME = '2023-01-01T00:00:00';
DECLARE @EndDate DATETIME = '2025-12-31T23:59:59';

-- Вычисление общего объема услуг для заданного вида и пользователя за заданный период
DECLARE @TotalServicesCount INT;
SELECT @TotalServicesCount = COUNT(*)
FROM Rentals
WHERE EquipmentID = @EquipmentID
AND RentalStartDate BETWEEN @StartDate AND @EndDate;

-- Вычисление количества услуг для заданного пользователя и вида за заданный период
DECLARE @UserServicesCount INT;
SELECT @UserServicesCount = COUNT(*)
FROM Rentals
WHERE EquipmentID = @EquipmentID
AND RentalStartDate BETWEEN @StartDate AND @EndDate
AND ClientID = @UserID;

-- Вычисление процента от общего объема услуг
DECLARE @PercentageOfTotal DECIMAL(5, 2);
SET @PercentageOfTotal = (CAST(@UserServicesCount AS DECIMAL(10, 2)) / NULLIF(@TotalServicesCount, 0)) * 100;

-- Вычисление наибольшего объема услуг
DECLARE @MaxServicesCount INT;
SELECT @MaxServicesCount = MAX(ServiceCount)
FROM (
    SELECT COUNT(*) AS ServiceCount
    FROM Rentals
    WHERE EquipmentID = @EquipmentID
    AND RentalStartDate BETWEEN @StartDate AND @EndDate
    GROUP BY ClientID
) AS MaxServiceCounts;

-- Вычисление процента от наибольшего объема услуг
DECLARE @PercentageOfMax DECIMAL(5, 2);
SET @PercentageOfMax = (CAST(@UserServicesCount AS DECIMAL(10, 2)) / NULLIF(@MaxServicesCount, 0)) * 100;

-- Вывод результатов
SELECT 
    @UserServicesCount AS Объем_услуг_пользователя,
    @TotalServicesCount AS Общий_объем_услуг,
    CONCAT(@PercentageOfTotal, '%') AS Процент_от_общего_объема,
    CONCAT(@PercentageOfMax, '%') AS Процент_от_наибольшего_объема;
--task7
SELECT 
    C.ClientID,
    C.FirstName AS Имя,
    C.LastName AS Фамилия,
    YEAR(R.RentalStartDate) AS Год,
    MONTH(R.RentalStartDate) AS Месяц,
    SUM(R.TotalCost) AS Сумма_аренды
FROM Clients C
INNER JOIN Rentals R ON C.ClientID = R.ClientID
WHERE R.RentalStartDate >= DATEADD(MONTH, -6, GETDATE())
GROUP BY C.ClientID, C.FirstName, C.LastName, YEAR(R.RentalStartDate), MONTH(R.RentalStartDate)
ORDER BY Год DESC, Месяц DESC;
--task8
SELECT
    C.ClientID,
    E.EquipmentName AS Вид_техники,
    MAX(ServiceCount) AS Максимальное_количество_предоставлений
FROM Clients C
INNER JOIN Rentals R ON C.ClientID = R.ClientID
INNER JOIN Equipment E ON R.EquipmentID = E.EquipmentID
INNER JOIN (
    SELECT EquipmentID, COUNT(*) AS ServiceCount
    FROM Rentals
    GROUP BY EquipmentID
) AS MaxServiceCounts ON R.EquipmentID = MaxServiceCounts.EquipmentID
GROUP BY C.ClientID, E.EquipmentName
ORDER BY C.ClientID;


