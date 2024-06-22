CREATE OR REPLACE TYPE ClientType AS OBJECT (
    ClientID NUMBER,
    FirstName NVARCHAR2(50),
    LastName NVARCHAR2(50),
    PhoneNumber NVARCHAR2(15),
    Email NVARCHAR2(50),
    AddressID NUMBER,
    MAP MEMBER FUNCTION area RETURN NUMBER DETERMINISTIC
);
/

CREATE OR REPLACE TYPE BODY ClientType AS
    MAP MEMBER FUNCTION area RETURN NUMBER DETERMINISTIC IS
    BEGIN
        RETURN LENGTH(FirstName) * LENGTH(LastName);
    END area;
END;
/

CREATE TABLE Client_Type OF ClientType;
/

BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO Client_Type VALUES (
            ClientType(
                i,
                'FirstName' || TO_CHAR(i),
                'LastName' || TO_CHAR(i),
                '123-456-789' || TO_CHAR(MOD(i, 10)),
                'email' || TO_CHAR(i) || '@example.com',
                MOD(i, 100) 
            )
        );
    END LOOP;
    COMMIT;
END;
/

CREATE OR REPLACE TYPE AddressType AS OBJECT (
    AddressID NUMBER,
    Street NVARCHAR2(255),
    CityID NUMBER,
    ZipCode NVARCHAR2(10),
    CONSTRUCTOR FUNCTION AddressType RETURN SELF AS RESULT,
    ORDER MEMBER FUNCTION compareTo(p_Address AddressType) RETURN NUMBER 
);
/

CREATE OR REPLACE TYPE BODY AddressType AS
    CONSTRUCTOR FUNCTION AddressType RETURN SELF AS RESULT IS
    BEGIN
        SELF.AddressID := NULL;
        SELF.Street := NULL;
        SELF.CityID := NULL;
        SELF.ZipCode := NULL;
        RETURN;
    END;

    ORDER MEMBER FUNCTION compareTo(p_Address AddressType) RETURN NUMBER IS
    BEGIN
        RETURN CASE
                   WHEN SELF.AddressID = p_Address.AddressID THEN 0
                   WHEN SELF.AddressID < p_Address.AddressID THEN -1
                   ELSE 1
               END;
    END compareTo;
END;
/
--task2
DECLARE
    client1 ClientType;
    client_obj ClientType := ClientType(
        ClientID => 1,
        FirstName => 'John',
        LastName => 'Doe',
        PhoneNumber => '123-456-7890',
        Email => 'john.doe@example.com',
        AddressID => 123
    );
    id NUMBER;
BEGIN
    client1 := ClientType(1, 'John', 'Doe', '123-456-7890', 'john@example.com', 1);
    --client1.printDetails;
    id := client_obj.getId;
    dbms_output.put_line(TO_CHAR(id)); -- Converting id to string and printing
END;
/

--task3
CREATE TABLE Client_Type OF ClientType;
CREATE TABLE Address_Type OF AddressType;
/
INSERT INTO Client_Type VALUES (
    ClientType(1, 'John', 'Doe', '123-456-7890', 'john@example.com', 1)
);
INSERT INTO Address_Type VALUES (
    AddressType(1, '123 Main St', 1, '12345')
);

--task4
CREATE OR REPLACE VIEW Client_View AS
SELECT ClientID, FirstName, LastName, PhoneNumber, Email, AddressID
FROM Client_Type;
CREATE OR REPLACE VIEW Address_View AS
SELECT AddressID, Street, CityID, ZipCode
FROM Address_Type;

--task5
CREATE INDEX idx_client_search
ON Client_Type (LastName, AddressID, ClientID);
--DROP INDEX idx_client_search;
CREATE INDEX idx_client_id_name_address ON Client_Type (ClientID, LastName, AddressID);
--DROP INDEX idx_client_id_name_address;

SELECT *
FROM Client_Type
WHERE ClientID > 1 and ClientID < 100 and LastName = 'LastName_93' AND AddressID = 23;

select count(*) from CLIENT_TYPE;
--insert procedure
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO Client_Type VALUES (
            ClientType(
                i,
                'FirstName' || TO_CHAR(i),
                'LastName' || TO_CHAR(i),
                '123-456-789' || TO_CHAR(MOD(i, 10)),
                'email' || TO_CHAR(i) || '@example.com',
                MOD(i, 100) 
            )
        );
    END LOOP;
    COMMIT;
END;
/
SELECT VALUE(c).area()
FROM Client_Type c;
/
CREATE INDEX area_idx ON Client_Type c 
  (TREAT(VALUE(c) AS ClientType).area());
/
SELECT *
FROM Client_Type c
WHERE TREAT(VALUE(c) AS ClientType).area() > 100;
/
EXPLAIN PLAN FOR
SELECT *
FROM Client_Type c
WHERE TREAT(VALUE(c) AS ClientType).area() > 100;
/
SELECT PLAN_TABLE_OUTPUT
FROM TABLE(DBMS_XPLAN.DISPLAY());
/