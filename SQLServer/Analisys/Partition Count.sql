SELECT
	[partitions].[object_id],
	[indexes].[index_id],
	COUNT(*)
	FROM [sys].[partitions]
		INNER JOIN [sys].[objects]
			ON [partitions].[object_id] = [objects].[object_id]
		INNER JOIN [sys].[schemas]
			ON [objects].[schema_id] = [schemas].[schema_id]
		INNER JOIN [sys].[indexes]
			ON
				[objects].[object_id] = [indexes].[object_id]
				AND [partitions].[index_id] = [indexes].[index_id]
	WHERE [schemas].[name] != N'sys'
	GROUP BY
		[partitions].[object_id],
		[indexes].[index_id]
