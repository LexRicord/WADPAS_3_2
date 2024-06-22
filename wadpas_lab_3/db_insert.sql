
USE wadpas_lab;
GO
--task2------------------
DECLARE @ParentATEHIDTest hierarchyid;
SET @ParentATEHIDTest = (SELECT ATE_HID FROM ATE WHERE AreaName = 'Minsk Region');

EXEC proc_getSubordinateNodesWithLevel @ParentATEHIDTest; 
-------task3------------------
go
DECLARE @ParentATEHIDTest hierarchyid;
SET @ParentATEHIDTest = (SELECT ATE_HID FROM ATE WHERE AreaName = 'Pinsk Region');

EXEC proc_addSubordinateNodeToATE @ParentATEHIDTest, 'Gorodishe';
-------task4------------------
go
DECLARE @OldParentATEHIDMove hierarchyid;
DECLARE @NewParentATEHIDMove hierarchyid;
SET @OldParentATEHIDMove = (SELECT ATE_HID FROM ATE WHERE AreaName = 'Minsk Region');
SET @NewParentATEHIDMove = (SELECT ATE_HID FROM ATE WHERE AreaName = 'Pinsk Region');

EXEC proc_moveSubordinateNodesInATE @OldParentATEHIDMove, @NewParentATEHIDMove;