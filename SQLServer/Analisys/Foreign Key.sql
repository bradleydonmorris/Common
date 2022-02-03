SELECT
	CASE
		WHEN RIGHT([Violations].[List], 1) = '|'
			THEN REPLACE(LEFT([Violations].[List], (LEN([Violations].[List]) - 1)), '|', ', ')
		ELSE NULL
	END AS [Violations],
	[ForeignKey].[SchemaName],
	[ForeignKey].[ForeignKeyName],
	[ForeignKey].[ForeignSchemaName],
	[ForeignKey].[ForeignTableName],
	[ForeignKey].[ForgeinColumnName],
	[ForeignKey].[PrimarySchemaName],
	[ForeignKey].[PrimaryTableName],
	[ForeignKey].[PrimaryIndexName],
	[ForeignKey].[PrimaryColumnName],
	[ForeignKey].[ForeignKeyColumnCount],
	[ForeignKey].[ForeignKeyNameValidator],
	[ForeignKey].[PrimaryIndexNameValidator],
	(
		'ALTER TABLE ['
		+ [ForeignKey].[ForeignSchemaName]
		+ '].['
		+ [ForeignKey].[ForeignTableName]
		+ '] DROP CONSTRAINT ['
		+ [ForeignKey].[ForeignKeyName]
		+ ']'
	) AS [DropConstraint]
	FROM
	(
		SELECT
			[schemas].[name] AS [SchemaName],
			[foreign_keys].[name] AS [ForeignKeyName],
			[schemas_Foreign].[name] AS [ForeignSchemaName],
			[tables_Foreign].[name] AS [ForeignTableName],
			[columns_Foreign].[name] AS [ForgeinColumnName],
			[schemas_Primary].[name] AS [PrimarySchemaName],
			[tables_Primary].[name] AS [PrimaryTableName],
			[indexes].[name] AS [PrimaryIndexName],
			[columns_Primary].[name] AS [PrimaryColumnName],
			[foreign_key_columns_Count].[Count] AS [ForeignKeyColumnCount],
			(
				N'FK_'
				+ [tables_Foreign].[name]
				+ N'_'
				+ [tables_Primary].[name]
				+
				CASE
					WHEN LEN([columns_Foreign].[name]) > LEN([columns_Primary].[name])
						THEN (N'_' + LEFT([columns_Foreign].[name], (LEN([columns_Foreign].[name]) - LEN([columns_Primary].[name]))))
					ELSE N''
				END
			) AS [ForeignKeyNameValidator],
			(
				N'PK_'
				+ [tables_Primary].[name]
			) AS [PrimaryIndexNameValidator]
			FROM [sys].[foreign_keys]
				INNER JOIN [sys].[schemas]
					ON [foreign_keys].[schema_id] = [schemas].[schema_id]
				INNER JOIN [sys].[tables] AS [tables_Foreign]
					ON [foreign_keys].[parent_object_id] = [tables_Foreign].[object_id]
				INNER JOIN [sys].[schemas] AS [schemas_Foreign]
					ON [tables_Foreign].[schema_id] = [schemas_Foreign].[schema_id]
				INNER JOIN [sys].[tables] AS [tables_Primary]
					ON [foreign_keys].[referenced_object_id] = [tables_Primary].[object_id]
				INNER JOIN [sys].[schemas] AS [schemas_Primary]
					ON [tables_Primary].[schema_id] = [schemas_Primary].[schema_id]
				INNER JOIN [sys].[indexes]
					ON
						[tables_Primary].[object_id] = [indexes].[object_id]
						AND [foreign_keys].[key_index_id] = [indexes].[index_id]
				INNER JOIN [sys].[foreign_key_columns]
					ON [foreign_keys].[object_id] = [foreign_key_columns].[constraint_object_id]
				INNER JOIN [sys].[columns] AS [columns_Foreign]
					ON
						[foreign_key_columns].[parent_object_id] = [columns_Foreign].[object_id]
						AND [tables_Foreign].[object_id] = [columns_Foreign].[object_id]
						AND [foreign_key_columns].[parent_column_id] = [columns_Foreign].[column_id]
				INNER JOIN [sys].[columns] AS [columns_Primary]
					ON
						[foreign_key_columns].[referenced_object_id] = [columns_Primary].[object_id]
						AND [tables_Primary].[object_id] = [columns_Primary].[object_id]
						AND [foreign_key_columns].[referenced_column_id] = [columns_Primary].[column_id]
				INNER JOIN
				(
					SELECT
						[foreign_key_columns].[constraint_object_id],
						COUNT(*) AS [Count]
						FROM [sys].[foreign_key_columns]
						GROUP BY [foreign_key_columns].[constraint_object_id]
				) AS [foreign_key_columns_Count]
					ON [foreign_keys].[object_id] = [foreign_key_columns_Count].[constraint_object_id]
	) AS [ForeignKey]
		CROSS APPLY
		(
			SELECT
			(
				SELECT [Violation].[Violation] + '|'
					FROM
					(
						SELECT 'Column Count' AS [Violation]
							WHERE [ForeignKey].[ForeignKeyColumnCount] != 1
						UNION ALL
						SELECT 'Foreign Key Name' AS [Violation]
							WHERE [ForeignKey].[ForeignKeyName] != [ForeignKey].[ForeignKeyNameValidator]
						UNION ALL
						SELECT 'Primary Index Name' AS [Violation]
							WHERE [ForeignKey].[PrimaryIndexName] != [ForeignKey].[PrimaryIndexNameValidator]
					) AS [Violation]
					FOR XML PATH('')
			) AS [List]
		) AS [Violations]
	WHERE
		[ForeignKey].[ForeignKeyColumnCount] != 1
		OR [ForeignKey].[ForeignKeyName] != [ForeignKey].[ForeignKeyNameValidator]
		OR [ForeignKey].[PrimaryIndexName] != [ForeignKey].[PrimaryIndexNameValidator]
	ORDER BY [ForeignKey].[ForeignKeyName]
