SELECT
	[schemas].[name] AS [Schema],
	[objects].[name] AS [Object],
	[indexes].[name] AS [Index],
	[indexes].[type_desc] AS [IndexType],
	[filegroups].[name] AS [FileGroup]
	FROM [sys].[schemas]
		INNER JOIN [sys].[objects]
			ON [schemas].[schema_id] = [objects].[schema_id]
		INNER JOIN [sys].[indexes]
			ON [objects].[object_id] = [indexes].[object_id]
		INNER JOIN [sys].[filegroups]
			ON [indexes].[data_space_id] = [filegroups].[data_space_id]
	WHERE
		[schemas].[name] != N'sys'
AND [filegroups].[name] LIKE 't_reservation'
	ORDER BY
		[schemas].[name],
		[objects].[name],
		[indexes].[name]
