-- Коллекция - это структура данных, содержащая множество объектов определённого типа
-- Шаг 1: Создание коллекций на основе таблиц

-- Тип для коллекции Client (client)
CREATE TYPE ClientType1 AS OBJECT (
    ID NUMBER,
    Name NVARCHAR2(255)
);

-- Тип для хранения списка Client (client)
CREATE TYPE ClientsList AS TABLE OF ClientType1;

-- Тип для коллекции Service (service)
CREATE TYPE ServiceType AS OBJECT (
    ID NUMBER,
    Description NVARCHAR2(255)
);

-- Тип для хранения списка Service (service)
CREATE TYPE ServicesList AS TABLE OF ServiceType;

-- Тип для коллекции Client-Service (client-service)
CREATE TYPE ClientServiceType AS OBJECT (
    Client ClientType1,
    Services ServicesList
);

-- Таблица clients
CREATE TABLE clients1 (
    clients_list ClientsList
) NESTED TABLE clients_list STORE AS clients_table;

-- Таблица services для демонстрации данных
CREATE TABLE services1 OF ServiceType;

-- Вставка данных в таблицу services
INSERT INTO services1 VALUES (ServiceType(1, 'Service 1'));
INSERT INTO services1 VALUES (ServiceType(2, 'Service 2'));
INSERT INTO services1 VALUES (ServiceType(3, 'Service 3'));

-- Вставка данных в таблицу clients
INSERT INTO clients1 VALUES (ClientsList(ClientType1(1, 'Client 1'), ClientType1(2, 'Client 2')));
INSERT INTO clients1 VALUES (ClientsList(ClientType1(3, 'Client 3')));

-- Шаг 2: Обработка данных из коллекций (пункт b и c)
DECLARE
    K1 ClientsList;
BEGIN
    SELECT clients_list INTO K1
    FROM clients1
    WHERE ROWNUM = 1;

    -- Проверка, является ли элемент ClientType(1, 'Client 1') членом коллекции K1
    DECLARE
        v_client_exists BOOLEAN := FALSE;
    BEGIN
        FOR i IN 1..K1.COUNT LOOP
            IF K1(i).ID = 1 AND K1(i).Name = 'Client 1' THEN
                v_client_exists := TRUE;
                EXIT;
            END IF;
        END LOOP;

        IF v_client_exists THEN
            DBMS_OUTPUT.PUT_LINE('2b');
            DBMS_OUTPUT.PUT_LINE('ClientType(1, ''Client 1'') является членом K1');
        END IF;
    END;
END;
/


-- Проверка на пустоту коллекции
DECLARE
    K1 ClientsList;
BEGIN
    SELECT clients_list INTO K1
    FROM clients1
    WHERE ROWNUM = 1;

    -- Проверка на пустую коллекцию
    IF K1 IS NULL OR K1.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Коллекция K1 пуста');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Коллекция K1 не пуста');
    END IF;
END;
/

-- Шаг 3: Преобразовать коллекцию к другому виду (к коллекции другого типа, к реляционным данным).
DECLARE
    K1 ClientsList;
    NewClientsList ClientsList := ClientsList(); -- Создаем пустую коллекцию для новых элементов
BEGIN
    -- Присваивание K1 коллекции Clients из первой записи clients
    SELECT clients_list INTO K1
    FROM clients1
    WHERE ROWNUM = 1;

    -- Добавляем элементы из K1 с ID > 1 в новую коллекцию NewClientsList
    FOR i IN 1..K1.COUNT LOOP
        IF K1(i).ID > 1 THEN
            NewClientsList.EXTEND; -- Увеличиваем размер коллекции
            NewClientsList(NewClientsList.LAST) := K1(i); -- Добавляем элемент в коллекцию
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('2c');
    -- Выводим содержимое новой коллекции NewClientsList
    FOR i IN 1..NewClientsList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewClientsList(i).ID || ', Name: ' || NewClientsList(i).Name);
    END LOOP;
END;
/

-- Шаг 4: Изменение данных в коллекции (пункт d)
DECLARE
    K1 ClientsList;
    NewClientsList ClientsList := ClientsList(); -- Создаем пустую коллекцию для новых элементов
BEGIN
    -- Присваивание K1 коллекции Clients из первой записи clients
    SELECT clients_list INTO K1
    FROM clients1
    WHERE ROWNUM = 1;

    -- Добавляем элементы из K1 с ID > 1 в новую коллекцию NewClientsList
    FOR i IN 1..K1.COUNT LOOP
        IF K1(i).ID > 1 THEN
            NewClientsList.EXTEND; -- Увеличиваем размер коллекции
            NewClientsList(NewClientsList.LAST) := K1(i); -- Добавляем элемент в коллекцию
        END IF;
    END LOOP;

    -- Выводим содержимое новой коллекции NewClientsList
    DBMS_OUTPUT.PUT_LINE('Contents of NewClientsList:');
    FOR i IN 1..NewClientsList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewClientsList(i).ID || ', Name: ' || NewClientsList(i).Name);
    END LOOP;
END;
/

-- Шаг 5: Изменение данных в коллекции (пункт d) с использованием BULK операций
CREATE GLOBAL TEMPORARY TABLE temp_table (
    ID NUMBER,
    Description NVARCHAR2(255)
) ON COMMIT PRESERVE ROWS;

DECLARE
    NewServicesList ServicesList := ServicesList(); -- Создаем пустую коллекцию для новых элементов
BEGIN
    NewServicesList.EXTEND;
    NewServicesList(NewServicesList.LAST) := ServiceType(4, 'Новый сервис 1');
    NewServicesList.EXTEND;
    NewServicesList(NewServicesList.LAST) := ServiceType(5, 'Новый сервис 2');

  -- Вывод содержимого коллекции NewServicesList перед операцией массовой вставки
    DBMS_OUTPUT.PUT_LINE('Содержимое NewServicesList:');
    FOR i IN 1..NewServicesList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewServicesList(i).ID || ', Описание: ' || NewServicesList(i).Description);
    END LOOP;

    -- Используем оператор BULK COLLECT для массового извлечения данных из 
    -- коллекции NewServicesList во временную таблицу
    -- FORALL - BULK оператор
    FORALL i IN 1..NewServicesList.COUNT
        INSERT INTO temp_table VALUES (NewServicesList(i).ID, NewServicesList(i).Description);

    -- Вставляем данные из временной таблицы в таблицу services
    INSERT INTO services1 (SELECT * FROM temp_table);

    -- Вывод сообщения об успешной вставке
    DBMS_OUTPUT.PUT_LINE('Массовая вставка выполнена успешно.');
END;
/