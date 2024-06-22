use wadpas_lab;
go
CREATE OR ALTER FUNCTION COUNT_EQUIPMENT_BY_MANUFACTURER (@manufacturerName NVARCHAR(100)) RETURNS INT AS
BEGIN
    DECLARE @count INT;

    SELECT @count = COUNT(*)
    FROM Equipment
    WHERE ManufacturerID IN (SELECT ManufacturerID FROM Manufacturer WHERE ManufacturerName = @manufacturerName);

    RETURN @count;
END;
go
SELECT
    ManufacturerName,
    dbo.COUNT_EQUIPMENT_BY_MANUFACTURER(ManufacturerName) AS EquipmentCount
FROM Manufacturer;
go
CREATE OR ALTER FUNCTION GET_AVAILABLE_EQUIPMENT () RETURNS TABLE AS RETURN
(
    SELECT 
        EquipmentID,
        EquipmentName,
        Description,
        RentalRate,
        ManufacturerName,
		AvailableOnStock
    FROM Equipment
    INNER JOIN Manufacturer ON Equipment.ManufacturerID = Manufacturer.ManufacturerID
    WHERE EquipmentID NOT IN (SELECT EquipmentID FROM Rentals)
        AND AvailableOnStock >= 1  -- Добавлено условие для AvailableOnStock
);
GO
SELECT * FROM dbo.GET_AVAILABLE_EQUIPMENT();
GO
