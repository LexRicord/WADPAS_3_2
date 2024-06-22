use wadpas_lab;

INSERT INTO States(StateName) VALUES
('Belarus'),
('Russia'),
('Kazakhstan');

INSERT INTO ATE(AreaName, StateID_ATE) VALUES
('Minsk Region', 1),
('Pinsk Region', 1),
('Minsk', 1),
('Moskva Region', 2),
('Moskva', 2),
('Alma-Ata region', 3);

INSERT INTO Cities (CityName, ATEID) VALUES
('Minsk', 3),
('Borisov', 1),
('Pinsk', 2),
('Ivanovo', 2),
('Lobnya', 4),
('Mytishchi', 4),
('Khimki', 4),
('Almaty', 6),
('Moscow', 5);

INSERT INTO Manufacturer (ManufacturerName, ContactInfo) VALUES
('LG Electronics', 'lg@example.com'),
('Atlant', 'atlant@example.com'),
('Bosch', 'bosch@example.com'),
('Sony', 'sony@example.com'),
('Samsung', 'samsung@example.com'),
('Microsoft', 'microsoft@example.com'),
('Apple', 'apple@example.com'),
('Toyota', 'toyota@example.com'),
('Custom', 'null@mail.ru');
go
INSERT INTO Equipment (EquipmentName, Description, RentalCost, ManufacturerID, AvailableOnStock) VALUES
('Ultra HD Smart TV', '65-inch Ultra HD Smart TV with HDR support', 40.00, 1, 3),         
('French Door Refrigerator', 'Stainless steel French door refrigerator with water dispenser', 30.00, 2, 4),  
('Silent Series Dishwasher', 'Silent series dishwasher with advanced cleaning technology', 35.00, 3, 12), 
('Mirrorless DSLR Camera', 'Mirrorless DSLR camera with 24MP sensor and 4K video recording', 25.00, 4, 1),  
('Front-Load Washer', 'Front-load washer with steam cleaning and smart technology', 28.00, 5, 3),  
('Surface Laptop', 'Microsoft Surface Laptop with touchscreen and high-performance specs', 45.00, 6, 0),  
('iPhone Pro Max', 'Latest iPhone Pro Max with advanced camera and 5G support', 50.00, 7, 3), 
('Hybrid SUV', 'Hybrid SUV with spacious interior and advanced safety features', 60.00, 8, 39);  
go

INSERT INTO Clients (FirstName, LastName, PhoneNumber, Email, AddressID) VALUES
('Иван', 'Иванов', '+77778889999', 'ivan.ivanov@example.com', 5), 
('Екатерина', 'Смирнова', '+79991112222', 'ekaterina.smirnova@example.com', 4),  
('Александр', 'Лукашенко', '+375291234567', 'alexander.ivanovich@example.com', 2),
('Ольга', 'Парушкевич', '+375339876543', 'olga.sergeevna@example.com', 3),
('Нуржан', 'Токтаров', '+77011234567', 'nurzhan.toktarov@example.com', 6), 
('Айгерим', 'Смагулова', '+77029876543', 'aigerim.smagulova@example.com', 6);  

INSERT INTO RentalStates (StateName, StateCounter) VALUES
('В рассмотрении', 0),
('Арендовано', 0),
('Клиент разорвал контакт', 0),
('Контракт закрыт', 0),
('Техобслуживание', 0),
('Арендовано(Продление)', 0);

INSERT INTO Employees (FirstName, LastName, PhoneNumber, Email, CityID) VALUES
('Александр', 'Герман', '+375291234567', 'german1@example.com', 1),
('Иван', 'Сусанин', '+77011234567', 'boloto.polyaki.rus@example.com', 9),
('Алгыз', 'Нурсултанов', '+77011234567', 'altin.kz@example.com', 8);

INSERT INTO Rentals (ClientID, EquipmentID, RentalStateID, RentalStartDate, RentalEndDate, TotalCost, AddressID) VALUES
(9, 2, 1, GETDATE(), GETDATE() - 30, 75.00, 2),
(7, 3, 1, GETDATE(), GETDATE() - 30, 450.00, 5);
----------
DECLARE @name NVARCHAR(50) = 'Герман';
DECLARE @surname NVARCHAR(50) = 'Александр';
DECLARE @secondname NVARCHAR(15) = '+375291234567';
DECLARE @empllogin NVARCHAR(50) = 'german1@example.com';
DECLARE @manufacturer NVARCHAR(100) = 'Atlant';

EXEC addMaster @in_name = @name,
               @in_surname = @surname,
               @in_phone = @secondname,
               @in_empllogin = @empllogin,
               @in_manufacturer = @manufacturer;
----------
DECLARE @name NVARCHAR(50) = 'Александр';
DECLARE @surname NVARCHAR(50) = 'Герман';
DECLARE @secondname NVARCHAR(50) = '+375291234567';
DECLARE @empllogin NVARCHAR(50) = 'german1@example.com';
DECLARE @manufacturer NVARCHAR(100) = 'ABC Motors';

EXEC addMaster @in_name = @name,
               @in_surname = @surname,
               @in_phone = @secondname,
               @in_empllogin = @empllogin,
               @in_manufacturer = @manufacturer;

DECLARE @name NVARCHAR(50) = 'Иван';
DECLARE @surname NVARCHAR(50) = 'Сусанин';
DECLARE @secondname NVARCHAR(15) = '+77011234567';
DECLARE @empllogin NVARCHAR(50) = 'boloto.polyaki.rus@example.com';
DECLARE @manufacturer NVARCHAR(100) = 'Toyota';

EXEC addMaster @in_name = @name,
               @in_surname = @surname,
               @in_phone = @secondname,
               @in_empllogin = @empllogin,
               @in_manufacturer = @manufacturer;
