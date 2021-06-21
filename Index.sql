SELECT
	'Index Name' AS [Violation],
	[Index].[SchemaName],
	[Index].[TableName],
	[Index].[IndexName],
	[Index].[ColumnName],
	[Index].[IndexNameValidator],
	(
		'DROP INDEX ['
		+ [Index].[IndexName]
		+ '] ON ['
		+ [Index].[SchemaName]
		+ '].['
		+ [Index].[TableName]
		+ ']'
	) AS [DropIndex]
	FROM
	(
		SELECT
			[schemas].[name] AS [SchemaName],
			[tables].[name] AS [TableName],
			[indexes].[name] AS [IndexName],
			[columns].[name] AS [ColumnName],
			(
				CASE
					WHEN [indexes].[is_primary_key] = 1
						THEN N'PK_'
					WHEN [indexes].[is_unique] = 1
						THEN N'UX_'
					ELSE N'IX_'
				END
				+ [tables].[name]
				+
				CASE
					WHEN [indexes].[is_primary_key] = 1
						THEN N''
					ELSE (N'_' + [columns].[name])
				END
			) AS [IndexNameValidator]
			FROM [sys].[indexes]
				INNER JOIN [sys].[tables]
					ON [indexes].[object_id] = [tables].[object_id]
				INNER JOIN [sys].[schemas]
					ON [tables].[schema_id] = [schemas].[schema_id]
				INNER JOIN [sys].[index_columns]
					ON
						[tables].[object_id] = [index_columns].[object_id]
						AND [indexes].[index_id] = [index_columns].[index_id]
				INNER JOIN [sys].[columns]
					ON
						[tables].[object_id] = [columns].[object_id]
						AND [index_columns].[column_id] = [columns].[column_id]
				INNER JOIN
				(
					SELECT
						[index_columns].[object_id],
						[index_columns].[index_id],
						COUNT(*) AS [Count]
						FROM [sys].[index_columns]
						GROUP BY
							[index_columns].[object_id],
							[index_columns].[index_id]
				) AS [index_columns_Count]
					ON
						[tables].[object_id] = [index_columns_Count].[object_id]
						AND [indexes].[index_id] = [index_columns_Count].[index_id]
			WHERE [index_columns_Count].[Count] = 1
		UNION ALL
		SELECT
			[schemas].[name] AS [SchemaName],
			[tables].[name] AS [TableName],
			[indexes].[name] AS [IndexName],
			NULL AS [ColumnName],
			(
				CASE
					WHEN [indexes].[is_unique] = 1
						THEN N'UX_'
					ELSE N'IX_'
				END
				+ [tables].[name]
				+ + N'_Covering'
			) AS [IndexNameValidator]
			FROM [sys].[indexes]
				INNER JOIN [sys].[tables]
					ON [indexes].[object_id] = [tables].[object_id]
				INNER JOIN [sys].[schemas]
					ON [tables].[schema_id] = [schemas].[schema_id]
				INNER JOIN
				(
					SELECT
						[index_columns].[object_id],
						[index_columns].[index_id],
						COUNT(*) AS [Count]
						FROM [sys].[index_columns]
						GROUP BY
							[index_columns].[object_id],
							[index_columns].[index_id]
				) AS [index_columns_Count]
					ON
						[tables].[object_id] = [index_columns_Count].[object_id]
						AND [indexes].[index_id] = [index_columns_Count].[index_id]
			WHERE [index_columns_Count].[Count] != 1
	) AS [Index]
	WHERE [Index].[IndexName] != [Index].[IndexNameValidator]
	ORDER BY
		[Index].[SchemaName],
		[Index].[TableName],
		[Index].[IndexName]
