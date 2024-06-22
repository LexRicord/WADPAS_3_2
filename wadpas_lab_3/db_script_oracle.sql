ALTER TABLE ATE
ADD (ATE_HID VARCHAR2(100));
/	
----task2-------------
CREATE OR REPLACE PROCEDURE proc_getSubordinateNodesWithLevel
    (ParentATEHID IN VARCHAR2, p_result OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_result FOR
    SELECT SYS_CONNECT_BY_PATH(AreaName, '/') AS AreaPath,
           AreaName,
           LEVEL - 1
    FROM ATE
    START WITH TO_CHAR(ATEID) = ParentATEHID OR (ATE_HID IS NULL AND ParentATEHID IS NULL)
    CONNECT BY NOCYCLE PRIOR TO_CHAR(ATEID) = TO_CHAR(ATE_HID);
END;
/
----task3-------------
CREATE OR REPLACE PROCEDURE lab3_ADD_SUBNODE(
    parent_id_in VARCHAR2,
    subnode_name_in NVARCHAR2
) AS
    v_parent_state_ate NUMBER;
    v_new_ateid NUMBER;
    v_subnode_hid VARCHAR2(100);
BEGIN
    SELECT STATEID_ATE INTO v_parent_state_ate
    FROM ATE
    WHERE ATEID = TO_NUMBER(parent_id_in);

    SELECT MAX(ATEID) + 1 INTO v_new_ateid
    FROM ATE;

    v_subnode_hid := parent_id_in;

    INSERT INTO ATE (ATEID, AREANAME, STATEID_ATE, ATE_HID)
    VALUES (v_new_ateid, subnode_name_in, v_parent_state_ate, v_subnode_hid);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
----task4-------------
CREATE OR REPLACE PROCEDURE lab3_changeAncestor(
    OldParentATEHID VARCHAR2,
    NewParentATEHID VARCHAR2
) AS
BEGIN
    UPDATE ATE
    SET ATE_HID = NewParentATEHID
    WHERE ATE_HID = OldParentATEHID;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;




