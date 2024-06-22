--task1-3
SELECT
    EXTRACT(YEAR FROM RentalStartDate) AS Год,
    TO_CHAR(RentalStartDate, 'YYYY-MM') AS Месяц,
    'Год' AS Период,
    CASE
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 1 AND 3 THEN '1-й квартал'
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 4 AND 6 THEN '2-й квартал'
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 7 AND 9 THEN '3-й квартал'
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 10 AND 12 THEN '4-й квартал'
        ELSE NULL
    END AS Квартал,
    CASE
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 1 AND 6 THEN '1-я половина'
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 7 AND 12 THEN '2-я половина'
        ELSE NULL
    END AS Половина_года,
    AVG(TotalCost) AS Средняя_стоимость_аренды
FROM Rentals
GROUP BY 
    EXTRACT(YEAR FROM RentalStartDate),
    TO_CHAR(RentalStartDate, 'YYYY-MM'),
    CASE
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 1 AND 3 THEN '1-й квартал'
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 4 AND 6 THEN '2-й квартал'
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 7 AND 9 THEN '3-й квартал'
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 10 AND 12 THEN '4-й квартал'
        ELSE NULL
    END,
    CASE
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 1 AND 6 THEN '1-я половина'
        WHEN EXTRACT(MONTH FROM RentalStartDate) BETWEEN 7 AND 12 THEN '2-я половина'
        ELSE NULL
    END
HAVING COUNT(*) > 0
ORDER BY Год, Месяц, Период, Квартал;
--task6
DECLARE
    EquipmentID NUMBER := 2;
    UserID NUMBER := 4;
    StartDate DATE := TO_DATE('2023-01-01T00:00:00', 'YYYY-MM-DD"T"HH24:MI:SS');
    EndDate DATE := TO_DATE('2025-12-31T23:59:59', 'YYYY-MM-DD"T"HH24:MI:SS');
    TotalServicesCount NUMBER;
    UserServicesCount NUMBER;
    PercentageOfTotal NUMBER;
    MaxServicesCount NUMBER;
    PercentageOfMax NUMBER;
BEGIN
    -- Вычисление общего объема услуг для заданного вида за указанный период
    SELECT COUNT(*) INTO TotalServicesCount
    FROM Rentals
    WHERE EquipmentID = EquipmentID
    AND RentalStartDate BETWEEN StartDate AND EndDate;

    -- Вычисление количества услуг для заданного пользователя за указанный период
    SELECT COUNT(*) INTO UserServicesCount
    FROM Rentals
    WHERE EquipmentID = EquipmentID
    AND RentalStartDate BETWEEN StartDate AND EndDate
    AND ClientID = UserID;

    -- Вычисление процента от общего объема услуг
    PercentageOfTotal := (UserServicesCount * 100.0) / NULLIF(TotalServicesCount, 0);

    -- Вычисление наибольшего объема услуг
    SELECT MAX(ServiceCount) INTO MaxServicesCount
    FROM (
        SELECT COUNT(*) AS ServiceCount
        FROM Rentals
        WHERE EquipmentID = EquipmentID
        AND RentalStartDate BETWEEN StartDate AND EndDate
        GROUP BY ClientID
    );

    -- Вычисление процента от наибольшего объема услуг
    PercentageOfMax := (UserServicesCount * 100.0) / NULLIF(MaxServicesCount, 0);

    -- Вывод результатов
    DBMS_OUTPUT.PUT_LINE('Объем услуг пользователя: ' || UserServicesCount);
    DBMS_OUTPUT.PUT_LINE('Общий объем услуг: ' || TotalServicesCount);
    DBMS_OUTPUT.PUT_LINE('Процент от общего объема: ' || PercentageOfTotal || '%');
    DBMS_OUTPUT.PUT_LINE('Процент от наибольшего объема: ' || PercentageOfMax || '%');
END;
/
--task7
SELECT 
    C.ClientID,
    C.FirstName AS Имя,
    C.LastName AS Фамилия,
    EXTRACT(YEAR FROM R.RentalStartDate) AS Год,
    EXTRACT(MONTH FROM R.RentalStartDate) AS Месяц,
    SUM(R.TotalCost) AS Сумма_аренды
FROM Clients C
INNER JOIN Rentals R ON C.ClientID = R.ClientID
WHERE R.RentalStartDate >= ADD_MONTHS(SYSDATE, -6)
GROUP BY 
    C.ClientID, 
    C.FirstName, 
    C.LastName, 
    EXTRACT(YEAR FROM R.RentalStartDate), 
    EXTRACT(MONTH FROM R.RentalStartDate)
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
) MaxServiceCounts ON R.EquipmentID = MaxServiceCounts.EquipmentID
GROUP BY C.ClientID, E.EquipmentName
ORDER BY C.ClientID;