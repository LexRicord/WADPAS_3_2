CREATE TABLE Report (
    id INT PRIMARY KEY,
    xml_data XMLType
);
/
CREATE OR REPLACE PROCEDURE GenerateXMLProcedure AS
BEGIN
    DECLARE
        xml_data XMLType;
    BEGIN
        SELECT XMLElement("Report", XMLForest(
            (SELECT xmlagg(XMLElement("State", XMLForest(StateID AS "StateID", StateName AS "StateName"))) FROM States) AS "States",
            (SELECT xmlagg(XMLElement("ATE", XMLForest(ATEID AS "ATEID", AreaName AS "AreaName", StateID_ATE AS "StateID"))) FROM ATE) AS "ATEs",
            (SELECT xmlagg(XMLElement("City", XMLForest(CityID AS "CityID", CityName AS "CityName", ATEID AS "ATEID"))) FROM Cities) AS "Cities",
            sysdate AS "Timestamp"
        )) INTO xml_data FROM dual;

        DELETE FROM Report WHERE id = 1;

        INSERT INTO Report (id, xml_data) VALUES (1, xml_data);
    END;
END GenerateXMLProcedure;
/
CREATE OR REPLACE PROCEDURE ExtractXMLValues (
    attributeName IN NVARCHAR2 DEFAULT NULL,
    elementName IN NVARCHAR2 DEFAULT NULL
) AS
    xml_data XMLType;
    v_values XMLType;
    v_value NVARCHAR2(100);
    v_index NUMBER := 1;
BEGIN
    SELECT xml_data INTO xml_data FROM Report WHERE id = 1;

    IF attributeName IS NOT NULL THEN
        LOOP
            v_values := xml_data.extract('//State[' || v_index || ']/' || attributeName || '/text()');
            EXIT WHEN v_values IS NULL;
            v_value := v_values.getStringVal();
            DBMS_OUTPUT.PUT_LINE('Value ' || v_index || ': ' || v_value);
            v_index := v_index + 1;
        END LOOP;
    ELSIF elementName IS NOT NULL THEN
        LOOP
            v_values := xml_data.extract('//ATE[' || v_index || ']/' || elementName || '/text()');
            EXIT WHEN v_values IS NULL;
            v_value := v_values.getStringVal();
            DBMS_OUTPUT.PUT_LINE('Value ' || v_index || ': ' || v_value);
            v_index := v_index + 1;
        END LOOP;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Необходимо указать имя атрибута или элемента.');
    END IF;
END ExtractXMLValues;
/
BEGIN 
    ExtractXMLValues(NULL, 'AreaName'); 
END;
/
BEGIN 
    ExtractXMLValues('StateID'); 
END;
/
