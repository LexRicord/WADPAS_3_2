CREATE OR REPLACE TRIGGER UpdateRentalStatesCounter
AFTER UPDATE ON Rentals
FOR EACH ROW
BEGIN
    UPDATE RentalStates rs
    SET StateCounter = StateCounter - 1
    WHERE rs.RentalStateID = :OLD.RentalStateID;

    UPDATE RentalStates rs
    SET StateCounter = StateCounter + 1
    WHERE rs.RentalStateID = :NEW.RentalStateID;
END;
/
