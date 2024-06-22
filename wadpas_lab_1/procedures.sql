use wadpas_lab;
go
CREATE OR ALTER PROCEDURE AddState
    @StateName NVARCHAR(100)
AS
BEGIN
    INSERT INTO States (StateName)
    VALUES (@StateName)
END;
go
CREATE OR ALTER PROCEDURE AddATE
    @AreaName NVARCHAR(100),
    @StateID_ATE INT
AS
BEGIN
    INSERT INTO ATE (AreaName, StateID_ATE)
    VALUES (@AreaName, @StateID_ATE)
END;
go
CREATE OR ALTER PROCEDURE AddCity
    @CityName NVARCHAR(100),
    @ATEID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Cities WHERE CityName = @CityName AND ATEID = @ATEID)
    BEGIN
        INSERT INTO Cities (CityName, ATEID)
        VALUES (@CityName, @ATEID)
    END
    ELSE
    BEGIN
        PRINT 'Error. [City already exists in the specified ATE].';
    END
END;
go
CREATE OR ALTER PROCEDURE AddAddress
    @Street NVARCHAR(255),
    @CityID INT,
    @ZipCode NVARCHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Addresses WHERE Street = @Street AND CityID = @CityID)
    BEGIN
        INSERT INTO Addresses (Street, CityID, ZipCode)
        VALUES (@Street, @CityID, @ZipCode)
    END
    ELSE
    BEGIN
        PRINT 'Error: [Street already exists in the specified city].';
    END
END;
go
CREATE OR ALTER PROCEDURE AddEquipment
    @EquipmentName NVARCHAR(100),
    @Description NVARCHAR(255),
    @RentalCost INT,
    @ManufacturerID INT,
    @AvailableOnStock INT
AS
BEGIN
    DECLARE @RentalRate DECIMAL(10, 2) = 0; 

    IF @RentalCost <= 0
    BEGIN
        PRINT 'Error: [RentalCost must be greater than zero].';
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1
        FROM Equipment
        WHERE EquipmentName = @EquipmentName
        AND ManufacturerID = @ManufacturerID
    )
    BEGIN
		IF (
			(SELECT ManufacturerName FROM Manufacturer WHERE ManufacturerID = @ManufacturerID) = 'Custom'
				AND (
				(
					@Description LIKE '+7[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
					OR @Description LIKE '+375[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
					OR @Description LIKE '+7[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
					OR @Description LIKE '+375[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
				)
					OR
					@Description LIKE '%_@__%.__%'
				)
			)
		BEGIN
		INSERT INTO Equipment (EquipmentName, Description, RentalCost, RentalRate, ManufacturerID, AvailableOnStock)
		VALUES (@EquipmentName, @Description, @RentalCost, @RentalRate, @ManufacturerID, @AvailableOnStock)
		END
		ELSE
		BEGIN
			PRINT 'Error: [Invalid Manufacturer or Description for Custom equipment. Description must contain a valid phone number or email].';
		END
    END
    ELSE
    BEGIN
        PRINT 'Error: [Equipment with the same name and manufacturer already exists].';
    END
END;
go
CREATE OR ALTER PROCEDURE AddManufacturer
    @ManufacturerName NVARCHAR(100),
    @ContactInfo NVARCHAR(255)
AS
BEGIN
    INSERT INTO Manufacturer (ManufacturerName, ContactInfo)
    VALUES (@ManufacturerName, @ContactInfo)
END;
go
CREATE OR ALTER PROCEDURE AddClients
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @PhoneNumber NVARCHAR(15),
    @Email NVARCHAR(50),
    @AddressID INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Clients
        WHERE PhoneNumber = @PhoneNumber
    )
    BEGIN
        IF (
            (SELECT StateName FROM States WHERE StateID = (SELECT StateID FROM Addresses WHERE AddressID = @AddressID)) = 'Belarus'
            AND @PhoneNumber LIKE '+375[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        )
        OR
        (
            (SELECT StateName FROM States WHERE StateID = (SELECT StateID FROM Addresses WHERE AddressID = @AddressID)) = 'Russia'
            AND @PhoneNumber LIKE '+7[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        )
        OR
        (
            (SELECT StateName FROM States WHERE StateID = (SELECT StateID FROM Addresses WHERE AddressID = @AddressID)) = 'Kazakhstan'
            AND @PhoneNumber LIKE '+7[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        )
        BEGIN
            INSERT INTO Clients (FirstName, LastName, PhoneNumber, Email, AddressID)
            VALUES (@FirstName, @LastName, @PhoneNumber, @Email, @AddressID)
        END
        ELSE
        BEGIN
            PRINT 'Error:[Invalid phone number format for the specified state].';
        END
    END
    ELSE
    BEGIN
        PRINT 'Error:[Client with the same phone number already exists].';
    END
END;
go
CREATE OR ALTER PROCEDURE AddMaster(
    @in_name NVARCHAR(50),
    @in_surname NVARCHAR(50),
    @in_phone NVARCHAR(15),
    @in_empllogin NVARCHAR(50),
    @in_manufacturer NVARCHAR(100)
)
AS
BEGIN
    DECLARE @invaliddata INT;
    DECLARE @curr_master_exists INT;
    DECLARE @empl_id INT;
    DECLARE @manufacturer_id INT;

    IF @in_name IS NULL OR @in_surname IS NULL OR @in_phone IS NULL
       OR @in_empllogin IS NULL OR @in_manufacturer IS NULL
    BEGIN
        SET @invaliddata = 1;
        THROW @invaliddata, 'Check input data', 1;
        RETURN;
    END;

    SELECT @manufacturer_id = ManufacturerID
    FROM Manufacturer
    WHERE ManufacturerName = @in_manufacturer;

    SELECT @empl_id = EmployeesID
    FROM Employees
    WHERE FirstName = @in_name AND LastName = @in_surname
          AND PhoneNumber = @in_phone AND Email = @in_empllogin;

    IF @empl_id IS NULL
    BEGIN
        SET @invaliddata = 1;
        THROW @invaliddata, 'Employee data not found', 1;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM Masters WHERE EmployeesId = @empl_id AND ManufacturerID = @manufacturer_id)
    BEGIN
        SET @curr_master_exists = 1;
        THROW @curr_master_exists, 'Master already exists', 1;
        RETURN;
    END;

    INSERT INTO Masters(NumberOfCompletedRentals, NumberOfReturnedRentals, MastersRating, EmployeesId, ManufacturerID)
    VALUES (0, 0, 0, @empl_id, @manufacturer_id);

    PRINT 'Master added successfully.';
END;
go
CREATE OR ALTER PROCEDURE AddRentalStates
    @StateName NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM RentalStates WHERE StateName = @StateName)
    BEGIN
        INSERT INTO RentalStates (StateName)
        VALUES (@StateName)
    END
    ELSE
    BEGIN
        PRINT 'StateName already exists.';
    END
END;
go
CREATE OR ALTER PROCEDURE AddEmployees
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @PhoneNumber NVARCHAR(15),
    @Email NVARCHAR(50),
    @CityID INT
AS
BEGIN
    DECLARE @CityExists INT;
    SELECT @CityExists = COUNT(*) FROM Cities WHERE CityID = @CityID;
    
    IF @CityExists = 0
    BEGIN
        PRINT 'CityID does not exist.';
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE Email = @Email)
    BEGIN
        INSERT INTO Employees (FirstName, LastName, PhoneNumber, Email, CityID)
        VALUES (@FirstName, @LastName, @PhoneNumber, @Email, @CityID);
        PRINT 'Employee inserted successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Email already exists.';
    END
END;
go
CREATE OR ALTER PROCEDURE AddRentalByClient
    @ClientID INT,
    @EquipmentID INT,
    @RentalStateID INT,
    @TotalCost DECIMAL(10, 2),
    @AddressID INT
AS
BEGIN
    DECLARE @RentalStartDate DATETIME = GETDATE();
    DECLARE @RentalEndDate DATETIME = GETDATE();

    IF NOT EXISTS (SELECT 1 FROM Clients WHERE ClientID = @ClientID)
    BEGIN
        PRINT 'Error: [Client does not exist].';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM Equipment WHERE EquipmentID = @EquipmentID)
    BEGIN
        PRINT 'Error: [Equipment does not exist].';
        RETURN;
    END;

    INSERT INTO Rentals (ClientID, EquipmentID, RentalStateID, RentalStartDate, RentalEndDate, TotalCost, AddressID)
    VALUES (@ClientID, @EquipmentID, @RentalStateID, @RentalStartDate, @RentalEndDate, @TotalCost, @AddressID)
END;
go          
CREATE OR ALTER PROCEDURE AddRental
    @EmployeeID INT,
    @RentalID INT,
    @NumberOfDays INT
AS
BEGIN
    DECLARE @EquipmentID INT;
    DECLARE @RentalCost DECIMAL(10, 2);
    DECLARE @RentalStartDate DATETIME;
    DECLARE @RentalEndDate DATETIME;
    DECLARE @TotalCost DECIMAL(10, 2);

    SELECT @EquipmentID = Rentals.EquipmentID, @RentalCost = RentalCost
    FROM Rentals
    INNER JOIN Equipment ON Rentals.EquipmentID = Equipment.EquipmentID
    WHERE RentalID = @RentalID;

    IF @EquipmentID IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM Equipment
            WHERE EquipmentID = @EquipmentID AND AvailableOnStock > 0
        )
        BEGIN
            UPDATE Equipment
            SET AvailableOnStock = AvailableOnStock - 1
            WHERE EquipmentID = @EquipmentID;

            UPDATE Rentals
            SET RentalStateID = 1
            WHERE RentalID = @RentalID AND RentalStateID = 0;

            SET @RentalStartDate = GETDATE();

            SET @RentalEndDate = DATEADD(DAY, (@NumberOfDays / 7) * 7, @RentalStartDate);

            SET @TotalCost = (@NumberOfDays / 7) * @RentalCost;

            UPDATE Rentals
            SET RentalStartDate = @RentalStartDate,
                RentalEndDate = @RentalEndDate,
                TotalCost = @TotalCost
            WHERE RentalID = @RentalID;
        END
        ELSE
        BEGIN
            PRINT 'Оборудование с ID ' + CAST(@EquipmentID AS NVARCHAR(10)) + ' отсутствует на складе.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Аренды с указанным ID не существует.';
    END
END;
go
CREATE PROCEDURE CloseRental
    @RentalID INT
AS
BEGIN
    DECLARE @EmployeeID INT;
    DECLARE @EquipmentID INT;

    SELECT @EmployeeID = EmployeeID, @EquipmentID = EquipmentID
    FROM Rentals
    WHERE RentalID = @RentalID;

    IF EXISTS (
        SELECT 1
        FROM Rentals
        WHERE RentalID = @RentalID AND RentalStateID = 1
    )
    BEGIN
        UPDATE Rentals
        SET RentalStateID = 4
        WHERE RentalID = @RentalID;

        UPDATE Masters
        SET NumberOfCompletedRentals = NumberOfCompletedRentals + 1
        WHERE EmployeesID = @EmployeeID;

        PRINT 'Аренда с RentalID ' + CAST(@RentalID AS NVARCHAR(10)) + ' успешно закрыта.';
    END
    ELSE
    BEGIN
        PRINT 'Невозможно закрыть аренду. Аренда с RentalID ' + CAST(@RentalID AS NVARCHAR(10)) + ' не найдена или уже закрыта.';
    END
END;
go
CREATE OR ALTER PROCEDURE RentalExtension
    @RentalID INT,
    @NumberOfDays INT
AS
BEGIN
    DECLARE @EquipmentID INT;
    DECLARE @RentalCost DECIMAL(10, 2);
    DECLARE @CurrentTotalCost DECIMAL(10, 2);
    DECLARE @ExtensionTotalCost DECIMAL(10, 2);

    SELECT @EquipmentID = EquipmentID, @RentalCost = RentalCost
    FROM Rentals
    INNER JOIN Equipment ON Rentals.EquipmentID = Equipment.EquipmentID
    WHERE RentalID = @RentalID;

    IF EXISTS (
        SELECT 1
        FROM Rentals
        WHERE RentalID = @RentalID AND RentalStateID = 1
    )
    BEGIN
        SELECT @CurrentTotalCost = TotalCost
        FROM Rentals
        WHERE RentalID = @RentalID;

        SET @ExtensionTotalCost = @CurrentTotalCost + @RentalCost * (@NumberOfDays / 7);

        UPDATE Rentals
        SET TotalCost = @ExtensionTotalCost,
            RentalExtensionDate = GETDATE(),
            RentalEndDate = DATEADD(DAY, @NumberOfDays, RentalEndDate)
        WHERE RentalID = @RentalID;

        PRINT 'Аренда с RentalID ' + CAST(@RentalID AS NVARCHAR(10)) + ' успешно продлена на ' + CAST(@NumberOfDays AS NVARCHAR(10)) + ' дней.';
    END
    ELSE
    BEGIN
        PRINT 'Невозможно запросить продление. Аренда с RentalID ' + CAST(@RentalID AS NVARCHAR(10)) + ' не найдена или уже закрыта.';
    END
END;
go