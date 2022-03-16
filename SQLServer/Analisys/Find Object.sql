--Alter WHERE clause as needed
DECLARE @SQLTemplate [nvarchar](MAX) =
N'
	SELECT
		N''{@Database}'' AS [Database],
		[schemas].[name] AS [Schema],
		[objects].[name] AS [Object],
		[objects].[type_desc] AS [Type]
		FROM [{@Database}].[sys].[schemas]
			INNER JOIN [{@Database}].[sys].[objects]
				ON [schemas].[schema_id] = [objects].[schema_id]
		WHERE [objects].[name] LIKE ''%reservation%''
'
DECLARE @Object TABLE
(
	[Database] [sys].[sysname],
	[Schema] [sys].[sysname],
	[Object] [sys].[sysname],
	[Type] [sys].[sysname]
)
DECLARE @SQL [nvarchar](MAX) 
DECLARE @Database [sys].[sysname]
DECLARE _Database
	CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
		SELECT [name] FROM [master].[sys].[databases]
OPEN _Database
FETCH NEXT FROM _Database INTO @Database
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = REPLACE(@SQLTemplate, N'{@Database}', @Database)
		INSERT INTO @Object([Database], [Schema], [Object], [Type])
		EXECUTE(@SQL)
		FETCH NEXT FROM _Database INTO @Database
	END
CLOSE _Database
DEALLOCATE _Database


SELECT [Database], [Schema], [Object], [Type]
	FROM @Object
