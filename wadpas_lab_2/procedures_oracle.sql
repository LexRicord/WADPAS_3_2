CREATE OR REPLACE PROCEDURE AddState (
    StateName IN NVARCHAR2
)
AS
BEGIN
    INSERT INTO States (StateName)
    VALUES (StateName);
END;
/

CREATE OR REPLACE PROCEDURE AddATE (
    AreaName IN NVARCHAR2,
    StateID_ATE IN INT
)
AS
BEGIN
    INSERT INTO ATE (AreaName, StateID_ATE)
    VALUES (AreaName, StateID_ATE);
END;
/

CREATE OR REPLACE PROCEDURE AddCity (
    CityName IN NVARCHAR2,
    ATEID IN INT
)
AS
    CityExists INT;
BEGIN
    SELECT COUNT(*) INTO CityExists
    FROM Cities
    WHERE CityName = CityName AND ATEID = ATEID;
    
    IF CityExists = 0 THEN
        INSERT INTO Cities (CityName, ATEID)
        VALUES (CityName, ATEID);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error. [City already exists in the specified ATE].');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE AddAddress (
    Street IN NVARCHAR2,
    CityID IN INT,
    ZipCode IN NVARCHAR2,
    Result OUT NVARCHAR2
)
AS
    AddressExists INT;
BEGIN
    SELECT COUNT(*) INTO AddressExists
    FROM Addresses
    WHERE Street = Street AND CityID = CityID;
    
    IF AddressExists = 0 THEN
        INSERT INTO Addresses (Street, CityID, ZipCode)
        VALUES (Street, CityID, ZipCode);
        Result := 'Address added successfully.';
    ELSE
        Result := 'Error: [Street already exists in the specified city].';
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE AddEquipment (
    EquipmentName IN NVARCHAR2,
    Description IN NVARCHAR2,
    RentalCost IN NUMBER,
    ManufacturerID IN INT,
    AvailableOnStock IN INT
)
AS
    RentalRate NUMBER(10, 2) := 0;
    ManufacturerName NVARCHAR2(100);
    EquipmentExists INT;
BEGIN
    SELECT ManufacturerName INTO ManufacturerName
    FROM Manufacturer
    WHERE ManufacturerID = ManufacturerID;

    SELECT COUNT(*) INTO EquipmentExists
    FROM Equipment
    WHERE EquipmentName = EquipmentName
    AND ManufacturerID = ManufacturerID;

    IF RentalCost <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: [RentalCost must be greater than zero].');
    ELSIF EquipmentExists = 0 THEN
        IF ManufacturerName = 'Custom' THEN
            IF (
                REGEXP_LIKE(Description, '\+7[0-9]{10}') OR
                REGEXP_LIKE(Description, '\+375[0-9]{9}') OR
                REGEXP_LIKE(Description, '\+7[0-9]{3}-[0-9]{7}') OR
                REGEXP_LIKE(Description, '\+375[0-9]{3}-[0-9]{7}') OR
                REGEXP_LIKE(Description, '[_@__%.__%]')
            ) THEN
                INSERT INTO Equipment (EquipmentName, Description, RentalCost, RentalRate, ManufacturerID, AvailableOnStock)
                VALUES (EquipmentName, Description, RentalCost, RentalRate, ManufacturerID, AvailableOnStock);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error: [Invalid Manufacturer or Description for Custom equipment. Description must contain a valid phone number or email].');
            END IF;
        ELSE
            INSERT INTO Equipment (EquipmentName, Description, RentalCost, RentalRate, ManufacturerID, AvailableOnStock)
            VALUES (EquipmentName, Description, RentalCost, RentalRate, ManufacturerID, AvailableOnStock);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: [Equipment with the same name and manufacturer already exists].');
    END IF;
END;
/


CREATE OR REPLACE PROCEDURE AddManufacturer (
    ManufacturerName IN NVARCHAR2,
    ContactInfo IN NVARCHAR2
)
AS
BEGIN
    INSERT INTO Manufacturer (ManufacturerName, ContactInfo)
    VALUES (ManufacturerName, ContactInfo);
END;
/

CREATE OR REPLACE PROCEDURE AddEquipment (
    EquipmentName IN NVARCHAR2,
    Description IN NVARCHAR2,
    RentalCost IN NUMBER,
    ManufID IN INT,
    AvailableOnStock IN INT
)
AS
    RentalRate NUMBER(10, 2) := 0;
    ManufacturerName NVARCHAR2(100);
    EquipmentExists INT;
BEGIN
    SELECT ManufacturerName INTO ManufacturerName
    FROM Manufacturer
    WHERE ManufacturerID = ManufID;

    SELECT COUNT(*) INTO EquipmentExists
    FROM Equipment
    WHERE EquipmentName = EquipmentName
    AND ManufacturerID = ManufID;

    IF RentalCost <= 0 THEN
        raise_application_error(-20001, 'Error: RentalCost must be greater than zero');
    ELSIF EquipmentExists = 0 THEN
        IF ManufacturerName = 'Custom' THEN
            IF (
                REGEXP_LIKE(Description, '\+7[0-9]{10}') OR
                REGEXP_LIKE(Description, '\+375[0-9]{9}') OR
                REGEXP_LIKE(Description, '\+7[0-9]{3}-[0-9]{7}') OR
                REGEXP_LIKE(Description, '\+375[0-9]{3}-[0-9]{7}') OR
                REGEXP_LIKE(Description, '[_@__%.__%]')
            ) THEN
                INSERT INTO Equipment (EquipmentName, Description, RentalCost, RentalRate, ManufacturerID, AvailableOnStock)
                VALUES (EquipmentName, Description, RentalCost, RentalRate, ManufID, AvailableOnStock);
            ELSE
                raise_application_error(-20002, 'Error: Invalid Manufacturer or Description for Custom equipment. Description must contain a valid phone number or email');
            END IF;
        ELSE
            INSERT INTO Equipment (EquipmentName, Description, RentalCost, RentalRate, ManufacturerID, AvailableOnStock)
            VALUES (EquipmentName, Description, RentalCost, RentalRate, ManufID, AvailableOnStock);
        END IF;
    ELSE
        raise_application_error(-20003, 'Error: Equipment with the same name and manufacturer already exists');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE AddMaster (
    in_name IN NVARCHAR2,
    in_surname IN NVARCHAR2,
    in_phone IN NVARCHAR2,
    in_empllogin IN NVARCHAR2,
    in_manufacturer IN NVARCHAR2
)
AS
    invaliddata EXCEPTION;
    curr_master_exists EXCEPTION;
    empl_id INT;
    manufacturer_id INT;
    master_count INT;
BEGIN
    IF in_name IS NULL OR in_surname IS NULL OR in_phone IS NULL OR in_empllogin IS NULL OR in_manufacturer IS NULL
    THEN
        RAISE invaliddata;
    END IF;

    SELECT ManufacturerID INTO manufacturer_id
    FROM Manufacturer
    WHERE ManufacturerName = in_manufacturer;

    SELECT EmployeesID INTO empl_id
    FROM Employees
    WHERE FirstName = in_name AND LastName = in_surname AND PhoneNumber = in_phone AND Email = in_empllogin;

    IF empl_id IS NULL THEN
        RAISE invaliddata;
    END IF;

    SELECT COUNT(*)
    INTO master_count
    FROM Masters
    WHERE EmployeesId = empl_id AND ManufacturerID = manufacturer_id;

    IF master_count > 0 THEN
        RAISE curr_master_exists;
    END IF;

    INSERT INTO Masters (NumberOfCompletedRentals, NumberOfReturnedRentals, MastersRating, EmployeesId, ManufacturerID)
    VALUES (0, 0, 0, empl_id, manufacturer_id);

    DBMS_OUTPUT.PUT_LINE('Master added successfully.');
EXCEPTION
    WHEN invaliddata THEN
        DBMS_OUTPUT.PUT_LINE('Check input data');
    WHEN curr_master_exists THEN
        DBMS_OUTPUT.PUT_LINE('Master already exists');
END;
/

CREATE OR REPLACE PROCEDURE AddRentalStates (
    StateName IN NVARCHAR2
)
AS
    state_exists INT;
BEGIN
    SELECT COUNT(*) INTO state_exists
    FROM RentalStates
    WHERE StateName = StateName;

    IF state_exists = 0 THEN
        INSERT INTO RentalStates (StateName)
        VALUES (StateName);
    ELSE
        DBMS_OUTPUT.PUT_LINE('StateName already exists.');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE AddEmployees (
    FirstName IN NVARCHAR2,
    LastName IN NVARCHAR2,
    PhoneNumber IN NVARCHAR2,
    Email IN NVARCHAR2,
    CityID IN INT
)
AS
    CityExists INT;
    EmailExists INT;
BEGIN
    SELECT COUNT(*) INTO CityExists FROM Cities WHERE CityID = CityID;
    
    IF CityExists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('CityID does not exist.');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO EmailExists
    FROM Employees
    WHERE Email = Email;

    IF EmailExists = 0 THEN
        INSERT INTO Employees (FirstName, LastName, PhoneNumber, Email, CityID)
        VALUES (FirstName, LastName, PhoneNumber, Email, CityID);
        DBMS_OUTPUT.PUT_LINE('Employee inserted successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Email already exists.');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE AddRentalByClient (
    ClientID IN INT,
    EquipmentID IN INT,
    RentalStateID IN INT,
    TotalCost IN NUMBER,
    AddressID IN INT
)
AS
    RentalStartDate DATE := SYSDATE;
    RentalEndDate DATE := SYSDATE;
    ClientExists INT; 
    EquipmentExists INT;
BEGIN
    SELECT COUNT(*) INTO ClientExists
    FROM Clients
    WHERE ClientID = ClientID;

    IF ClientExists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: [Client does not exist].');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO EquipmentExists
    FROM Equipment
    WHERE EquipmentID = EquipmentID;

    IF EquipmentExists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: [Equipment does not exist].');
        RETURN;
    END IF;

    INSERT INTO Rentals (ClientID, EquipmentID, RentalStateID, RentalStartDate, RentalEndDate, TotalCost, AddressID)
    VALUES (ClientID, EquipmentID, RentalStateID, RentalStartDate, RentalEndDate, TotalCost, AddressID);
END;
/   

CREATE OR REPLACE PROCEDURE AddRental (
    EmployeeID IN INT,
    RentalID IN INT,
    NumberOfDays IN INT
)
AS
    v_EquipmentID INT;
    v_RentalCost DECIMAL(10, 2);
    v_RentalStartDate DATE;
    v_RentalEndDate DATE;
    v_TotalCost DECIMAL(10, 2);
    v_EquipmentCount INT;
BEGIN
    SELECT Equipment.EquipmentID, RentalCost 
    INTO v_EquipmentID, v_RentalCost
    FROM Rentals
    INNER JOIN Equipment ON Rentals.EquipmentID = Equipment.EquipmentID
    WHERE Rentals.RentalID = RentalID;

    IF v_EquipmentID IS NOT NULL THEN
        SELECT COUNT(*) INTO v_EquipmentCount
        FROM Equipment
        WHERE EquipmentID = v_EquipmentID AND AvailableOnStock > 0;

        IF v_EquipmentCount > 0 THEN
            UPDATE Equipment
            SET AvailableOnStock = AvailableOnStock - 1
            WHERE EquipmentID = v_EquipmentID;

            UPDATE Rentals
            SET RentalStateID = 1
            WHERE RentalID = RentalID AND RentalStateID = 0;

            v_RentalStartDate := SYSDATE;

            v_RentalEndDate := TRUNC(ADD_MONTHS(v_RentalStartDate, NumberOfDays / 30));

            v_TotalCost := (NumberOfDays / 30) * v_RentalCost;

            UPDATE Rentals
            SET RentalStartDate = v_RentalStartDate,
                RentalEndDate = v_RentalEndDate,
                TotalCost = v_TotalCost
            WHERE RentalID = RentalID;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Оборудование с ID ' || v_EquipmentID || ' отсутствует на складе.');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Аренды с указанным ID не существует.');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE CloseRental (
    RentalID IN INT
)
AS
    EmployeeID INT;
    EquipmentID INT;
    v_RentalStateID INT;
BEGIN
    SELECT EmployeeID, EquipmentID, RentalStateID
    INTO EmployeeID, EquipmentID, v_RentalStateID
    FROM Rentals
    WHERE RentalID = RentalID;

    IF v_RentalStateID = 1 THEN
        UPDATE Rentals
        SET RentalStateID = 4
        WHERE RentalID = RentalID;

        UPDATE Masters
        SET NumberOfCompletedRentals = NumberOfCompletedRentals + 1
        WHERE EmployeesID = EmployeeID;

        DBMS_OUTPUT.PUT_LINE('Аренда с RentalID ' || RentalID || ' успешно закрыта.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Невозможно закрыть аренду. Аренда с RentalID ' || RentalID || ' не найдена или уже закрыта.');
    END IF;
END;
/
CREATE OR REPLACE PROCEDURE RentalExtension (
    RentalID IN INT,
    NumberOfDays IN INT
)
AS
    EquipmentID INT;
    RentalCost DECIMAL(10, 2);
    CurrentTotalCost DECIMAL(10, 2);
    ExtensionTotalCost DECIMAL(10, 2);
    RentalExists INT;
BEGIN
    SELECT COUNT(*)
    INTO RentalExists
    FROM Rentals
    WHERE RentalID = RentalID AND RentalStateID = 1;

    IF RentalExists > 0 THEN
        SELECT r.EquipmentID, e.RentalCost
        INTO EquipmentID, RentalCost
        FROM Rentals r
        INNER JOIN Equipment e ON r.EquipmentID = e.EquipmentID
        WHERE r.RentalID = RentalID;

        SELECT TotalCost INTO CurrentTotalCost
        FROM Rentals
        WHERE RentalID = RentalID;

        ExtensionTotalCost := CurrentTotalCost + RentalCost * (NumberOfDays / 30);

        UPDATE Rentals
        SET TotalCost = ExtensionTotalCost,
            RentalExtensionDate = SYSDATE,
            RentalEndDate = ADD_MONTHS(RentalEndDate, NumberOfDays)
        WHERE RentalID = RentalID;

        DBMS_OUTPUT.PUT_LINE('Аренда с RentalID ' || RentalID || ' успешно продлена на ' || NumberOfDays || ' дней.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Невозможно запросить продление. Аренда с RentalID ' || RentalID || ' не найдена или уже закрыта.');
    END IF;
END;
/


