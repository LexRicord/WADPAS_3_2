create database wadpas_lab;

use wadpas_lab;
go
CREATE TABLE States (
    StateID INT PRIMARY KEY IDENTITY(1,1),
    StateName NVARCHAR(100)
); 
go
CREATE TABLE ATE (
    ATEID INT PRIMARY KEY IDENTITY(1,1),
    AreaName NVARCHAR(100),
    StateID_ATE INT,
    FOREIGN KEY (StateID_ATE) REFERENCES States(StateID)
);
go
CREATE TABLE Cities (
    CityID INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(100),
    ATEID INT,
    FOREIGN KEY (ATEID) REFERENCES ATE(ATEID)
);
go
CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY IDENTITY(1,1),
    Street NVARCHAR(255),
    CityID INT,
    ZipCode NVARCHAR(10),
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);
go
CREATE TABLE Manufacturer (
    ManufacturerID INT PRIMARY KEY IDENTITY(1,1),
    ManufacturerName NVARCHAR(100),
    ContactInfo NVARCHAR(255)
);
go
CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY IDENTITY(1,1),
    EquipmentName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
	RentalCost Int NOT NULL,
    RentalRate DECIMAL(10, 2) DEFAULT '0.0',
    ManufacturerID INT,
    AvailableOnStock INT,
    BaseRentalTime INT DEFAULT 7,
    FOREIGN KEY (ManufacturerID) REFERENCES Manufacturer(ManufacturerID)
);
go
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    PhoneNumber NVARCHAR(15),
    Email NVARCHAR(50),
    AddressID INT,
    FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID)
);
go
ALTER TABLE Clients
ADD CONSTRAINT CK_PhoneNumberFormat CHECK (
    PhoneNumber LIKE '+7[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR 
    PhoneNumber LIKE '+375[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'  OR 
    PhoneNumber LIKE '+7[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
    PhoneNumber LIKE '+375[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
);
go
ALTER TABLE Clients
ADD CONSTRAINT CK_Client_EmailFormat CHECK (
    Email LIKE '%_@__%.__%'
);
go
CREATE TABLE RentalStates (
    RentalStateID INT PRIMARY KEY IDENTITY(1,1),
    StateName NVARCHAR(100),
    StateCounter INT
); 
go
CREATE TABLE Employees (
    EmployeesID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    PhoneNumber NVARCHAR(15),
    Email NVARCHAR(50) UNIQUE,
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)

);
go
ALTER TABLE Employees
ADD CONSTRAINT CK_EMP_PhoneNumberFormat CHECK (
    PhoneNumber LIKE '+7[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR 
    PhoneNumber LIKE '+375[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'  OR 
    PhoneNumber LIKE '+7[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
    PhoneNumber LIKE '+375[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
);
go
ALTER TABLE Employees
ADD CONSTRAINT CK_Employee_EmailFormat CHECK (
    Email LIKE '%_@__%.__%'
);
go
CREATE TABLE Masters
(
Id INT PRIMARY KEY IDENTITY(1,1),
NumberOfCompletedRentals int default '0',
NumberOfReturnedRentals int default '0',
MastersRating int default '0',
EmployeesId int,
ManufacturerID int,
FOREIGN KEY(EmployeesId) REFERENCES Employees(EmployeesID),
FOREIGN KEY(ManufacturerID) REFERENCES Manufacturer(ManufacturerID)
);
go
CREATE TABLE Rentals (
    RentalID INT PRIMARY KEY IDENTITY(1,1),
    ClientID INT,
    EmployeeID INT,
    EquipmentID INT,
    RentalStateID INT,
    RentalStartDate DATETIME NOT NULL,
    RentalEndDate DATETIME NOT NULL,
    RentalExtensionDate DATETIME,
    TotalCost DECIMAL(10, 2) NOT NULL,
    AddressID INT,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeesID),
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID),
    FOREIGN KEY (RentalStateID) REFERENCES RentalStates(RentalStateID),
    FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID)
);
go