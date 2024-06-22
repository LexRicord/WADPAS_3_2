use wadpas_lab; 
go
CREATE VIEW view_ClientInfo AS
SELECT
    c.ClientID,
    c.FirstName,
    c.LastName,
    c.PhoneNumber,
    c.Email,
    a.Street AS AddressStreet,
    ci.CityName,
    s.StateName,
    a.ZipCode
FROM Clients c
INNER JOIN Addresses a ON c.AddressID = a.AddressID
INNER JOIN Cities ci ON a.CityID = ci.CityID
INNER JOIN ATE ate ON ci.ATEID = ate.ATEID
INNER JOIN States s ON ate.StateID_ATE = s.StateID;
go
CREATE VIEW view_RentalInfo AS
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
INNER JOIN Addresses a ON r.AddressID = a.AddressID;
go
CREATE OR ALTER VIEW EmployeeInfo AS
SELECT 
    e.FirstName AS FirstName,
    e.LastName AS LastName,
    e.PhoneNumber AS PhoneNumber,
    e.Email AS Email,
    c.CityName AS City,
    mn.ManufacturerName AS Manufacturer,
	m.NumberOfCompletedRentals as CompleteRentals,
	m.NumberOfReturnedRentals as ReturnedRentals
FROM Employees e
JOIN Cities c ON e.CityID = c.CityID
JOIN Masters m ON e.EmployeesID = m.EmployeesId
JOIN Manufacturer mn on mn.ManufacturerId = m.ManufacturerId;
go