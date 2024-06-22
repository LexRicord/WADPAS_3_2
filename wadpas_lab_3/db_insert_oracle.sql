--task2------------------
DECLARE
    v_result SYS_REFCURSOR;
    v_AreaPath VARCHAR2(4000);
    v_AreaName NVARCHAR2(100);
    v_Level NUMBER;
BEGIN
    proc_getSubordinateNodesWithLevel('1', v_result);
    LOOP
        FETCH v_result INTO v_AreaPath, v_AreaName, v_Level;
        EXIT WHEN v_result%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Area Path: ' || v_AreaPath || ', Area Name: ' || v_AreaName || ', Level: ' || v_Level);
    END LOOP;
    CLOSE v_result;
EXCEPTION
    WHEN OTHERS THEN
        IF v_result%ISOPEN THEN
            CLOSE v_result;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;
/
-------task3------------------
BEGIN
    lab3_ADD_SUBNODE('1', 'Новый подузел2');
    lab3_ADD_SUBNODE('11', 'Новый подузел2');
END;
/
-------task4------------------
BEGIN
    lab3_changeAncestor('2', '3');
END;
/
DECLARE
    v_result SYS_REFCURSOR;
    v_AreaPath VARCHAR2(4000);
    v_AreaName NVARCHAR2(100);
    v_Level NUMBER;
BEGIN
    proc_getSubordinateNodesWithLevel('2', v_result);
    LOOP
        FETCH v_result INTO v_AreaPath, v_AreaName, v_Level;
        EXIT WHEN v_result%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Area Path: ' || v_AreaPath || ', Area Name: ' || v_AreaName || ', Level: ' || v_Level);
    END LOOP;
    CLOSE v_result;
EXCEPTION
    WHEN OTHERS THEN
        IF v_result%ISOPEN THEN
            CLOSE v_result;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;
/