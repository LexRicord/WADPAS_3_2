CREATE INDEX index_Clients_PhoneNumber ON Clients(PhoneNumber);
CREATE INDEX index_Rentals_RentalStateID_EndDate ON Rentals(RentalStateID, RentalEndDate);
CREATE INDEX index_Equipment_ManufacturerID_RentalRate ON Equipment(ManufacturerID, RentalRate);

ALTER INDEX index_Clients_PhoneNumber REBUILD;

ALTER INDEX index_Rentals_RentalStateID_EndDate REBUILD;

ALTER INDEX index_Equipment_ManufacturerID_RentalRate REBUILD;

-- Для перестройки с ONLINE = OFF это не требуется в Oracle, так как по умолчанию перестройка индексов происходит без блокировки онлайн

-- Для удаления индексов в Oracle используется команда DROP INDEX
-- Например:
-- DROP INDEX index_Clients_PhoneNumber;
-- DROP INDEX index_Rentals_RentalStateID_EndDate;
-- DROP INDEX index_Equipment_ManufacturerID_RentalRate;