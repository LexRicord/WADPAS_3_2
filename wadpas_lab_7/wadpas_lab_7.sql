use wadpas_lab_4
go
create table Report (
id INTEGER primary key identity(1,1),
xml_column XML
);
go
select * from Report
go
create procedure generateXML
as
declare @x XML
set @x = (Select	name_client [Имя клиента], 
					name_product [Имя продукта], 
					GETDATE() [Дата]
	from orders ord 
					join products prd on ord.id_product = prd.id_product
					join clients clnt on clnt.id_client = ord.id_client
	FOR XML AUTO);
	SELECT @x
go

execute generateXML;
go
create procedure InsertInReport
as
DECLARE  @s XML  
SET @s = (Select	name_client [Имя клиента], 
					name_product [Имя продукта], 
					GETDATE() [Дата]
		from orders ord 
					join products prd on ord.id_product = prd.id_product
					join clients clnt on clnt.id_client = ord.id_client
for xml raw);
insert into Report values(@s);
go
  execute InsertInReport
  select * from Report;
go
create primary xml index My_XML_Index on Report(xml_column)

create xml index Second_XML_Index on Report(xml_column)
using xml index My_XML_Index for path
go

select * from Report
go
create procedure SelectData
as
select xml_column.query('/row')
	as[xml_column]
	from Report
	for xml auto, type;
go
execute SelectData
go
select xml_column.value('(/row/@Дата)[1]', 'nvarchar(max)')
	as[xml_column]
	from Report
	for xml auto, type;
go
select r.Id,
	m.c.value('@Дата', 'nvarchar(max)') as [date]
	from Report as r
	outer apply r.xml_column.nodes('/row') as m(c)
go
