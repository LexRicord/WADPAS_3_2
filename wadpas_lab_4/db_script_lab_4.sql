SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA

-- 6
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'

-- 7
select [wadpas_lab4].[dbo].[geometry_columns].srid as SRID from [wadpas_lab4].[dbo].[geometry_columns]

-- 8
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND DATA_TYPE != 'geometry'

-- 9.	Верните описания пространственных объектов в формате WKT
--  текстовый формат для представления геометрических объектов в пространстве
SELECT geom.STAsText() AS WKT_Description FROM [wadpas_lab4].[dbo].[10m_lakes]

-- 10
select * from [wadpas_lab4].[dbo].[10m_lakes];

-- 10.1.

SELECT obj1.geom.STIntersection(obj2.geom) AS Intersection
FROM [wadpas_lab4].[dbo].[10m_lakes] obj1, [wadpas_lab4].[dbo].[10m_lakes] obj2
WHERE obj1.qgs_fid = 1 AND obj2.qgs_fid = 1

-- 10.2.

SELECT geom.STPointN(1).ToString() AS VertexCoordinates
FROM [wadpas_lab4].[dbo].[10m_lakes]
WHERE qgs_fid = 1

-- 10.3.	
SELECT geom.STArea() AS ObjectArea
FROM [wadpas_lab4].[dbo].[10m_lakes]
WHERE qgs_fid = 5

-- 11.	
DECLARE @pointGeometry GEOMETRY;
SET @pointGeometry = GEOMETRY::STGeomFromText('POINT(1 5)', 0);
SELECT @pointGeometry AS PointGeometry;

DECLARE @lineGeometry GEOMETRY;
SET @lineGeometry = GEOMETRY::STGeomFromText('LINESTRING(1 5, 10 5)', 0);
SELECT @lineGeometry AS LineGeometry;


-- полигон
DECLARE @polygonGeometry GEOMETRY;
SET @polygonGeometry = GEOMETRY::STGeomFromText('POLYGON((1 1, 50 1, 50 50, 1 50, 1 1))', 0);
SELECT @polygonGeometry AS PolygonGeometry;


-- 12.	
DECLARE @point GEOMETRY = GEOMETRY::STGeomFromText('POINT(1 5)', 0);
DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((1 1, 50 1, 50 50, 1 50, 1 1))', 0);
SELECT @point.STWithin(@polygon) AS PointWithinPolygon;


DECLARE @line GEOMETRY = GEOMETRY::STGeomFromText('LINESTRING(1 5, 10 5)', 0);
DECLARE @polygonn GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((1 1, 50 1, 50 50, 1 50, 1 1))', 0);
SELECT @line.STIntersects(@polygonn) AS LineIntersectsPolygon;


-- 13.
create index Geometry_index on [wadpas_lab4].[dbo].[10m_lakes](qgs_fid);

-- 14.
create procedure [wadpas_lab4].[dbo].[PointCheckProc]
@point geometry
as
begin
DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((1 1, 50 1, 50 50, 1 50, 1 1))', 0);
SELECT @point.STWithin(@polygon) AS PointWithinPolygon;
end;

exec PointCheckProc 'POINT(2 5)';
