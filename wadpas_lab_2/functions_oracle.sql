CREATE OR REPLACE FUNCTION COUNT_EQUIPMENT_BY_MANUFACTURER (
    p_manufacturerName IN NVARCHAR2
) RETURN INT AS
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Equipment e
    JOIN Manufacturer m ON e.ManufacturerID = m.ManufacturerID
    WHERE m.ManufacturerName = p_manufacturerName;

    RETURN v_count;
END COUNT_EQUIPMENT_BY_MANUFACTURER;
/
SELECT
    ManufacturerName,
    COUNT_EQUIPMENT_BY_MANUFACTURER(ManufacturerName) AS EquipmentCount
FROM Manufacturer;
/
CREATE OR REPLACE FUNCTION GET_AVAILABLE_EQUIPMENT RETURN SYS_REFCURSOR AS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT 
            e.EquipmentID,
            e.EquipmentName,
            e.Description,
            e.RentalRate,
            m.ManufacturerName,
            e.AvailableOnStock
        FROM Equipment e
        JOIN Manufacturer m ON e.ManufacturerID = m.ManufacturerID
        WHERE e.EquipmentID NOT IN (SELECT EquipmentID FROM Rentals)
            AND e.AvailableOnStock >= 1;

    RETURN v_cursor;
END GET_AVAILABLE_EQUIPMENT;
/
VAR available_equipment REFCURSOR;
EXEC :available_equipment := GET_AVAILABLE_EQUIPMENT;
PRINT available_equipment;
