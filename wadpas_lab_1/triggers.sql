use wadpas_labs;
go
CREATE OR ALTER TRIGGER UpdateRentalStatesCounter
ON Rentals
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE rs
    SET StateCounter = StateCounter - 1
    FROM RentalStates rs
    INNER JOIN deleted d ON rs.RentalStateID = d.RentalStateID;

    UPDATE rs
    SET StateCounter = StateCounter + 1
    FROM RentalStates rs
    INNER JOIN inserted i ON rs.RentalStateID = i.RentalStateID;
END;

