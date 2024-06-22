use wadpas_lab;
go
IF OBJECT_ID('Report', 'U') IS NOT NULL
    DROP TABLE Report;
go
CREATE TABLE Report (
    id INT PRIMARY KEY IDENTITY,
    xml_data XML
);
go
CREATE PRIMARY XML INDEX PXML_Report_xml_data
ON Report(xml_data);
go
CREATE PROCEDURE GenerateXMLProcedure
AS
BEGIN
    DECLARE @xml XML;

    SET @xml = (
        SELECT
            (
                SELECT * FROM Clients FOR XML PATH('Client'), TYPE
            ),
            (
                SELECT * FROM Addresses FOR XML PATH('Address'), TYPE
            ),
            GETDATE() AS 'Timestamp'
        FOR XML PATH('Report')
    );
    SELECT @xml AS GeneratedXML;
END;
go
CREATE OR ALTER PROCEDURE InsertXMLIntoReport
AS
BEGIN
    INSERT INTO Report (xml_data)
    EXEC GenerateXMLProcedure;
END;
go
CREATE PROCEDURE ExtractXMLValues
    @attributeName NVARCHAR(100) = NULL,
    @elementName NVARCHAR(100) = NULL
AS
BEGIN
    DECLARE @xml XML;
    DECLARE @sql NVARCHAR(MAX);

    SELECT @xml = xml_data FROM Report;

    IF @attributeName IS NOT NULL
    BEGIN
        SET @sql = 'SELECT t.c.value(''@' + @attributeName + ''', ''NVARCHAR(100)'') AS AttributeValue FROM @xml.nodes(''//Report/*'') AS t(c);';
        EXEC sp_executesql @sql, N'@xml XML', @xml;
    END
    ELSE IF @elementName IS NOT NULL
    BEGIN
        SET @sql = 'SELECT t.c.value(''(./' + @elementName + ')[1]'', ''NVARCHAR(100)'') AS ElementValue FROM @xml.nodes(''//Report/*'') AS t(c);';
        EXEC sp_executesql @sql, N'@xml XML', @xml;
    END
    ELSE
    BEGIN
        RAISERROR('Необходимо указать имя атрибута или элемента.', 16, 1);
    END;
END;
go
EXEC InsertXMLIntoReport;
go
EXEC ExtractXMLValues @attributeName = 'Street';
go
EXEC ExtractXMLValues @elementName = 'ZipCode';
go
