use wadpas_labs;
go
CREATE INDEX index_Clients_PhoneNumber ON Clients(PhoneNumber);
CREATE INDEX index_Rentals_RentalStateID_EndDate ON Rentals(RentalStateID, RentalEndDate);
CREATE INDEX index_Equipment_ManufacturerID_RentalRate ON Equipment(ManufacturerID, RentalRate);
CREATE INDEX index_Employees_CityID_ManufacturerID ON Employees(CityID, ManufacturerID);
go
alter index index_Clients_PhoneNumber on Clients reorganize
alter index index_Clients_PhoneNumber on Clients rebuild with (online = off)
go 
alter index index_Rentals_RentalStateID_EndDate on Rentals reorganize
alter index index_Rentals_RentalStateID_EndDate on Rentals rebuild with (online = off)
go
alter index index_Equipment_ManufacturerID_RentalRate on Equipment reorganize
alter index index_Equipment_ManufacturerID_RentalRate on Equipment rebuild with (online = off)
go
alter index index_Employees_CityID_ManufacturerID on Employees reorganize
alter index index_Employees_CityID_ManufacturerID on Employees rebuild with (online = off)
go
--drop index index_Clients_PhoneNumber on Clients 
--drop index index_Rentals_RentalStateID_EndDate on Rentals 
--drop index index_Equipment_ManufacturerID_RentalRate on Equipment 
--drop index index_Employees_CityID_ManufacturerID on Employees