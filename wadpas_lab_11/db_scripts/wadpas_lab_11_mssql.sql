use wadpas_lab;
go
CREATE OR ALTER FUNCTION dbo.GetRentalInfoByPeriod
(
    @StartDate VARCHAR(23), -- Размерность может варьироваться в зависимости от точности времени
    @EndDate VARCHAR(23)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT
        r.RentalID,
        c.FirstName AS ClientFirstName,
        c.LastName AS ClientLastName,
        e.FirstName AS EmployeeFirstName,
        e.LastName AS EmployeeLastName,
        eq.EquipmentName,
        rs.StateName AS RentalState,
        r.RentalStartDate,
        r.RentalEndDate,
        r.TotalCost,
        a.Street AS RentalAddress
    FROM Rentals r
    INNER JOIN Clients c ON r.ClientID = c.ClientID
    INNER JOIN Employees e ON r.EmployeeID = e.EmployeesID
    INNER JOIN Equipment eq ON r.EquipmentID = eq.EquipmentID
    INNER JOIN RentalStates rs ON r.RentalStateID = rs.RentalStateID
    INNER JOIN Addresses a ON r.AddressID = a.AddressID
    WHERE 
        r.RentalStartDate BETWEEN CONVERT(DATETIME2, @StartDate) AND CONVERT(DATETIME2, @EndDate)
);
go
SELECT * FROM dbo.GetRentalInfoByPeriod('2023-01-01 00:00:00.000', '2025-05-31 23:59:59.999');
go
--sqlcmd -S ROG -d wadpas_lab -U wadpas4_login -P 123456 -Q "SET NOCOUNT ON; SELECT * FROM dbo.GetRentalInfoByPeriod('2023-01-01', '2025-03-31') FOR XML AUTO, ROOT('Root'), ELEMENTS" -o "C:\Users\User\Downloads\mssql_export\rental_data.json"
--sqlcmd -S ROG -d wadpas_lab -U wadpas4_login -P 123456 -Q "SET NOCOUNT ON; SELECT * FROM dbo.GetRentalInfoByPeriod('2022-01-01', '2025-03-31') FOR XML AUTO, ROOT('Root'), ELEMENTS" -o "C:\Users\User\Downloads\mssql_export\rental_data.xml"


smallint
int
int
int
int
datetime
datetime
datetime
decimal(10, 2)
int