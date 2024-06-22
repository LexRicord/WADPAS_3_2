INSERT INTO States(StateID, StateName) VALUES (1, 'Belarus');
INSERT INTO States(StateID, StateName) VALUES (2, 'Russia');
INSERT INTO States(StateID, StateName) VALUES (3, 'Kazakhstan');

INSERT INTO ATE(ATEID, AreaName, StateID_ATE) VALUES (1, 'Minsk Region', 1);
INSERT INTO ATE(ATEID, AreaName, StateID_ATE) VALUES (2, 'Pinsk Region', 1);
INSERT INTO ATE(ATEID, AreaName, StateID_ATE) VALUES (3, 'Minsk', 1);
INSERT INTO ATE(ATEID, AreaName, StateID_ATE) VALUES (4, 'Moskva Region', 2);
INSERT INTO ATE(ATEID, AreaName, StateID_ATE) VALUES (5, 'Moskva', 2);
INSERT INTO ATE(ATEID, AreaName, StateID_ATE) VALUES (6, 'Alma-Ata region', 3);

INSERT INTO Cities (CityID, CityName, ATEID) VALUES (1, 'Minsk', 3);
INSERT INTO Cities (CityID, CityName, ATEID) VALUES (2, 'Borisov', 1);
INSERT INTO Cities (CityID, CityName, ATEID) VALUES (3, 'Pinsk', 2);
INSERT INTO Cities (CityID, CityName, ATEID) VALUES (4, 'Ivanovo', 2);
INSERT INTO Cities (CityID, CityName, ATEID) VALUES (5, 'Lobnya', 4);
INSERT INTO Cities (CityID, CityName, ATEID) VALUES (6, 'Mytishchi', 4);
INSERT INTO Cities (CityID, CityName, ATEID) VALUES (7, 'Khimki', 4);
INSERT INTO Cities (CityID, CityName, ATEID) VALUES (8, 'Almaty', 6);
INSERT INTO Cities (CityID, CityName, ATEID) VALUES (9, 'Moscow', 5);

INSERT INTO Manufacturer (ManufacturerID, ManufacturerName, ContactInfo) VALUES (1, 'LG Electronics', 'lg@example.com');
INSERT INTO Manufacturer (ManufacturerID, ManufacturerName, ContactInfo) VALUES (2, 'Atlant', 'atlant@example.com');
INSERT INTO Manufacturer (ManufacturerID, ManufacturerName, ContactInfo) VALUES (3, 'Bosch', 'bosch@example.com');
INSERT INTO Manufacturer (ManufacturerID, ManufacturerName, ContactInfo) VALUES (4, 'Sony', 'sony@example.com');
INSERT INTO Manufacturer (ManufacturerID, ManufacturerName, ContactInfo) VALUES (5, 'Samsung', 'samsung@example.com');
INSERT INTO Manufacturer (ManufacturerID, ManufacturerName, ContactInfo) VALUES (6, 'Microsoft', 'microsoft@example.com');
INSERT INTO Manufacturer (ManufacturerID, ManufacturerName, ContactInfo) VALUES (7, 'Apple', 'apple@example.com');
INSERT INTO Manufacturer (ManufacturerID, ManufacturerName, ContactInfo) VALUES (8, 'Toyota', 'toyota@example.com');
INSERT INTO Manufacturer (ManufacturerID, ManufacturerName, ContactInfo) VALUES (9, 'Custom', 'null@mail.ru');

INSERT INTO Equipment (EquipmentName, Description, RentalCost, ManufacturerID, AvailableOnStock) 
VALUES ('Ultra HD Smart TV', '65-inch Ultra HD Smart TV with HDR support', 40.00, 1, 3);
INSERT INTO Equipment (EquipmentName, Description, RentalCost, ManufacturerID, AvailableOnStock) 
VALUES ('French Door Refrigerator', 'Stainless steel French door refrigerator with water dispenser', 30.00, 2, 4);
INSERT INTO Equipment (EquipmentName, Description, RentalCost, ManufacturerID, AvailableOnStock) 
VALUES ('Silent Series Dishwasher', 'Silent series dishwasher with advanced cleaning technology', 35.00, 3, 12);
INSERT INTO Equipment (EquipmentName, Description, RentalCost, ManufacturerID, AvailableOnStock) 
VALUES ('Mirrorless DSLR Camera', 'Mirrorless DSLR camera with 24MP sensor and 4K video recording', 25.00, 4, 1);
INSERT INTO Equipment (EquipmentName, Description, RentalCost, ManufacturerID, AvailableOnStock) 
VALUES ('Front-Load Washer', 'Front-load washer with steam cleaning and smart technology', 28.00, 5, 3);
INSERT INTO Equipment (EquipmentName, Description, RentalCost, ManufacturerID, AvailableOnStock) 
VALUES ('Surface Laptop', 'Microsoft Surface Laptop with touchscreen and high-performance specs', 45.00, 6, 0);
INSERT INTO Equipment (EquipmentName, Description, RentalCost, ManufacturerID, AvailableOnStock) 
VALUES ('iPhone Pro Max', 'Latest iPhone Pro Max with advanced camera and 5G support', 50.00, 7, 3);
INSERT INTO Equipment (EquipmentName, Description, RentalCost, ManufacturerID, AvailableOnStock) 
VALUES ('Hybrid SUV', 'Hybrid SUV with spacious interior and advanced safety features', 60.00, 8, 39);

INSERT INTO Addresses (AddressID, Street, CityID, ZipCode) VALUES (1, 'Central Avenue', 1, '220012');
INSERT INTO Addresses (AddressID, Street, CityID, ZipCode) VALUES (2, 'Lenin Street', 2, '220001');
INSERT INTO Addresses (AddressID, Street, CityID, ZipCode) VALUES (3, 'Pushkin Street', 3, '225710');
INSERT INTO Addresses (AddressID, Street, CityID, ZipCode) VALUES (4, 'Gagarin Avenue', 4, '153012');
INSERT INTO Addresses (AddressID, Street, CityID, ZipCode) VALUES (5, 'Tverskaya Street', 5, '101000');
INSERT INTO Addresses (AddressID, Street, CityID, ZipCode) VALUES (6, 'Al-Farabi Avenue', 6, '050040');

INSERT INTO Clients (ClientID, FirstName, LastName, PhoneNumber, Email, AddressID) VALUES (1, 'Иван', 'Иванов', '+77778889999', 'ivan.ivanov@example.com', 5);
INSERT INTO Clients (ClientID, FirstName, LastName, PhoneNumber, Email, AddressID) VALUES (2, 'Екатерина', 'Смирнова', '+79991112222', 'ekaterina.smirnova@example.com', 4);
INSERT INTO Clients (ClientID, FirstName, LastName, PhoneNumber, Email, AddressID) VALUES (3, 'Александр', 'Лукашенко', '+375291234567', 'alexander.ivanovich@example.com', 2);
INSERT INTO Clients (ClientID, FirstName, LastName, PhoneNumber, Email, AddressID) VALUES (4, 'Ольга', 'Парушкевич', '+375339876543', 'olga.sergeevna@example.com', 3);
INSERT INTO Clients (ClientID, FirstName, LastName, PhoneNumber, Email, AddressID) VALUES (5, 'Нуржан', 'Токтаров', '+77011234567', 'nurzhan.toktarov@example.com', 6);
INSERT INTO Clients (ClientID, FirstName, LastName, PhoneNumber, Email, AddressID) VALUES (6, 'Айгерим', 'Смагулова', '+77029876543', 'aigerim.smagulova@example.com', 6);

INSERT INTO RentalStates (RentalStateID, StateName, StateCounter) VALUES (1, 'В рассмотрении', 0);
INSERT INTO RentalStates (RentalStateID, StateName, StateCounter) VALUES (2, 'Арендовано', 0);
INSERT INTO RentalStates (RentalStateID, StateName, StateCounter) VALUES (3, 'Клиент разорвал контакт', 0);
INSERT INTO RentalStates (RentalStateID, StateName, StateCounter) VALUES (4, 'Контракт закрыт', 0);
INSERT INTO RentalStates (RentalStateID, StateName, StateCounter) VALUES (5, 'Техобслуживание', 0);
INSERT INTO RentalStates (RentalStateID, StateName, StateCounter) VALUES (6, 'Арендовано(Продление)', 0);

INSERT INTO Employees (EmployeesID, FirstName, LastName, PhoneNumber, Email, CityID) VALUES (1, 'Александр', 'Герман', '+375291234567', 'german1@example.com', 1);
INSERT INTO Employees (EmployeesID, FirstName, LastName, PhoneNumber, Email, CityID) VALUES (2, 'Иван', 'Сусанин', '+77011234567', 'boloto.polyaki.rus@example.com', 9);
INSERT INTO Employees (EmployeesID, FirstName, LastName, PhoneNumber, Email, CityID) VALUES (3, 'Алгыз', 'Нурсултанов', '+77011234567', 'altin.kz@example.com', 8);

INSERT INTO Rentals (RentalID, ClientID, EquipmentID, RentalStateID, RentalStartDate, RentalEndDate, TotalCost, AddressID) 
VALUES (1, 3, 2, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP - INTERVAL '30' DAY, 75.00, 2);
INSERT INTO Rentals (RentalID, ClientID, EquipmentID, RentalStateID, RentalStartDate, RentalEndDate, TotalCost, AddressID) 
VALUES (2, 4, 3, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP - INTERVAL '30' DAY, 450.00, 5);
----------
DECLARE
    name NVARCHAR2(50) := 'Александр';
    surname NVARCHAR2(50) := 'Герман';
    secondname NVARCHAR2(15) := '+375291234567';
    empllogin NVARCHAR2(50) := 'german1@example.com';
    manufacturer NVARCHAR2(100) := 'Atlant';
BEGIN
    GAE_1.AddMaster(
        in_name => name,
        in_surname => surname,
        in_phone => secondname,
        in_empllogin => empllogin,
        in_manufacturer => manufacturer
    );
END;
/

DECLARE
    name NVARCHAR2(50) := 'Александр';
    surname NVARCHAR2(50) := 'Герман';
    secondname NVARCHAR2(50) := '+375291234567';
    empllogin NVARCHAR2(50) := 'german1@example.com';
    manufacturer NVARCHAR2(100) := 'Microsoft';
BEGIN
    AddMaster(
        in_name => name,
        in_surname => surname,
        in_phone => secondname,
        in_empllogin => empllogin,
        in_manufacturer => manufacturer
    );
END;
/

DECLARE
    name NVARCHAR2(50) := 'Иван';
    surname NVARCHAR2(50) := 'Сусанин';
    secondname NVARCHAR2(15) := '+77011234567';
    empllogin NVARCHAR2(50) := 'boloto.polyaki.rus@example.com';
    manufacturer NVARCHAR2(100) := 'Toyota';
BEGIN
    AddMaster(
        in_name => name,
        in_surname => surname,
        in_phone => secondname,
        in_empllogin => empllogin,
        in_manufacturer => manufacturer
    );
END;
/

