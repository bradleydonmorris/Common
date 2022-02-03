DECLARE @SQLTemplate [nvarchar](MAX) = N'
SELECT
	N''{@DatabaseName}'' AS [DatabaseName],
	[schemas].[name] AS [SchemaName],
	[objects].[name] AS [ObjectName],
	[objects].[type_desc] AS [ObjectType]
	FROM [{@DatabaseName}].[sys].[sql_modules]
		INNER JOIN [{@DatabaseName}].[sys].[objects]
			ON [sql_modules].[object_id] = [objects].[object_id]
		INNER JOIN [{@DatabaseName}].[sys].[schemas]
			ON [objects].[schema_id] = [schemas].[schema_id]
	WHERE [sql_modules].[definition] LIKE ''%{STRING TO FIND}%''
'

DECLARE @DatabaseName [sys].[sysname]
DECLARE @SQL [nvarchar](MAX)
DECLARE @Result TABLE
(
	[DatabaseName] [sys].[sysname],
	[SchemaName] [sys].[sysname],
	[ObjectName] [sys].[sysname],
	[ObjectType] [sys].[sysname]
)
DECLARE _Database
	CURSOR FORWARD_ONLY READ_ONLY LOCAL FOR
		SELECT
			[databases].[name] AS [DatabaseName]
			FROM [master].[sys].[databases]
OPEN _Database
FETCH NEXT FROM _Database INTO @DatabaseName
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = REPLACE(@SQLTemplate, N'{@DatabaseName}', @DatabaseName)
		INSERT INTO @Result ([DatabaseName], [SchemaName], [ObjectName], [ObjectType])
			EXECUTE(@SQL)
		FETCH NEXT FROM _Database INTO @DatabaseName
	END
CLOSE _Database
DEALLOCATE _Database
SELECT [DatabaseName], [SchemaName], [ObjectName], [ObjectType]
	FROM @Result
