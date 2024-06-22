CREATE OR REPLACE PROCEDURE proc_getSubordinateNodesWithLevel
    (ParentATEHID IN VARCHAR2, p_result OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_result FOR
    SELECT ATE_HID AS ATEID, AreaName, LEVEL - 1 AS Level
    FROM ATE
    START WITH ATE_HID = ParentATEHID
    CONNECT BY PRIOR ATE_HID = ParentATEHID;
END;
/
----task3-------------
CREATE OR ALTER PROCEDURE proc_addSubordinateNodeToATE
    @ParentATEHID hierarchyid,
    @NewAreaName NVARCHAR(100)
AS
BEGIN
    DECLARE @ParentStateId_ATE INT;
    SELECT @ParentStateId_ATE = StateID_ATE FROM ATE WHERE ATE_HID = @ParentATEHID;

    DECLARE @ParentLevel INT;
    SELECT @ParentLevel = ATE_HID.GetLevel() FROM ATE WHERE ATE_HID = @ParentATEHID;

    DECLARE @NewATEID hierarchyid;

    SET @NewATEID = @ParentATEHID.GetDescendant(
        (SELECT MAX(ATE_HID) FROM ATE WHERE ATE_HID.GetAncestor(1) = @ParentATEHID),
        NULL
    );

    INSERT INTO ATE (AreaName, ATE_HID, StateID_ATE)
    VALUES (@NewAreaName, @NewATEID, @ParentStateId_ATE);

    SELECT @NewATEID.ToString(),@NewAreaName  AS NewATEID;
END;
----task4-------------
go
CREATE OR ALTER PROCEDURE proc_moveSubordinateNodesInATE
    @OldParentATEHID hierarchyid,
    @NewParentATEHID hierarchyid
AS
BEGIN
    DECLARE @MaxChildOrder int;
    SELECT @MaxChildOrder = MAX(ATE_HID.GetLevel())
    FROM ATE
    WHERE ATE_HID.GetAncestor(1) = @NewParentATEHID;

    DECLARE @Increment int;
    SET @Increment = 0;

    DECLARE @ChildNode hierarchyid;
    DECLARE child_cursor CURSOR FOR
    SELECT ATE_HID
    FROM ATE
    WHERE ATE_HID.GetAncestor(1) = @OldParentATEHID;

    OPEN child_cursor;
    FETCH NEXT FROM child_cursor INTO @ChildNode;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @RelativeLevel int;
        SET @RelativeLevel = @ChildNode.GetLevel() - @OldParentATEHID.GetLevel();

        UPDATE ATE
        SET ATE_HID = @NewParentATEHID.ToString() + CAST(CAST(@MaxChildOrder + @RelativeLevel + @Increment + 1 AS varchar(10)) + '/' AS nvarchar(10)),
            @Increment = @Increment + 1
        WHERE ATE_HID = @ChildNode;

        FETCH NEXT FROM child_cursor INTO @ChildNode;
    END;

    CLOSE child_cursor;
    DEALLOCATE child_cursor;
END;
go

