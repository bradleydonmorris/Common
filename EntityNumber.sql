SELECT
	[schemas].[name] AS [SchemaName],
	[tables].[name] AS [TableName],
	[extended_properties_JournalTableType].[value] AS [Journal.TableType],
	[extended_properties_JournalNumberPrefix].[value] AS [Journal.NumberPrefix],
	[extended_properties_JournalComments].[value] AS [Journal.Comments],
	[Entity].[Name],
	[Entity].[NumberPrefix],
	[Entity].[NumberSuffix],
	[Entity].[LeftPaddingCharacter],
	[Entity].[MaximumCharacterCount],
	[Entity].[Seed],
	[Entity].[Increment],
	[columns_Identity].[Name],
	[columns_Identity].[DataType],
	[columns_Identity].[CharacterLength],
	(
		LEN([extended_properties_JournalNumberPrefix].[value])
		+ [columns_Identity].[CharacterLength]
	) AS [MaximumCharacterCountShouldBe],
	REPLACE(REPLACE(
	(
		CASE
			WHEN [Entity].[Name] IS NULL
				THEN
					REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
						N'EXEC [Global].[AddEntity]{@CrLf}{@Tab}@EntityName = ''{@SchemaName}.{@TableName}'',{@CrLf}{@Tab}@NumberPrefix = ''{@NumberPrefix}'',{@CrLf}{@Tab}@NumberSuffix = NULL,{@CrLf}{@Tab}@LeftPaddingCharacter = ''0'',{@CrLf}{@Tab}@MaximumCharacterCount = {@MaximumCharacterCount},{@CrLf}{@Tab}@Seed = 1,{@CrLf}{@Tab}@Increment = 1'
					,N'{@SchemaName}', [schemas].[name])
					,N'{@TableName}', [tables].[name])
					,N'{@NumberPrefix}', [extended_properties_JournalNumberPrefix].[value])
					,N'{@Increment}', CONVERT([nvarchar](21), [Entity].[Increment], 0))
					,'{@MaximumCharacterCount}', (LEN([extended_properties_JournalNumberPrefix].[value]) + [columns_Identity].[CharacterLength]))
			WHEN
			(
				[extended_properties_JournalNumberPrefix].[value] != [Entity].[NumberPrefix]
				OR
				(
					LEN([extended_properties_JournalNumberPrefix].[value])
					+ [columns_Identity].[CharacterLength]
				) != [Entity].[MaximumCharacterCount]
			)
				THEN
					REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
						N'EXEC [Global].[UpdateEntity]{@CrLf}{@Tab}@EntityName = ''{@SchemaName}.{@TableName}'',{@CrLf}{@Tab}@NumberPrefix = ''{@NumberPrefix}'',{@CrLf}{@Tab}@NumberSuffix = NULL,{@CrLf}{@Tab}@LeftPaddingCharacter = ''0'',{@CrLf}{@Tab}@MaximumCharacterCount = {@MaximumCharacterCount},{@CrLf}{@Tab}@Increment = {@Increment},{@CrLf}{@Tab}@NewEntityName = NULL'
					,N'{@SchemaName}', [schemas].[name])
					,N'{@TableName}', [tables].[name])
					,N'{@NumberPrefix}', [extended_properties_JournalNumberPrefix].[value])
					,N'{@Increment}', CONVERT([nvarchar](21), [Entity].[Increment], 0))
					,'{@MaximumCharacterCount}', (LEN([extended_properties_JournalNumberPrefix].[value]) + [columns_Identity].[CharacterLength]))
		END
	)
	,N'{@CrLf}', (CHAR(13) + CHAR(10)))
	,N'{@Tab}', CHAR(9))
	FROM [sys].[tables]
		INNER JOIN [sys].[schemas]
			ON [tables].[schema_id] = [schemas].[schema_id]
		LEFT OUTER JOIN [Global].[Entity]
			ON
			(
				[schemas].[name]
				+ N'.'
				+ [tables].[name]
			) = [Entity].[Name]
		LEFT OUTER JOIN
		(
			SELECT
				[extended_properties].[major_id],
				CONVERT([varchar](100), [extended_properties].[Value], 0) AS [value]
				FROM [sys].[extended_properties]
				WHERE
					[extended_properties].[class_desc] = N'OBJECT_OR_COLUMN'
					AND [extended_properties].[name] = N'Journal.TableType'
					AND [extended_properties].[minor_id] = 0
		)  AS [extended_properties_JournalTableType]
			ON [tables].[object_id] = [extended_properties_JournalTableType].[major_id]
		LEFT OUTER JOIN
		(
			SELECT
				[extended_properties].[major_id],
				CONVERT([varchar](100), [extended_properties].[Value], 0) AS [value]
				FROM [sys].[extended_properties]
				WHERE
					[extended_properties].[class_desc] = N'OBJECT_OR_COLUMN'
					AND [extended_properties].[name] = N'Journal.NumberPrefix'
					AND [extended_properties].[minor_id] = 0
		)  AS [extended_properties_JournalNumberPrefix]
			ON [tables].[object_id] = [extended_properties_JournalNumberPrefix].[major_id]
		LEFT OUTER JOIN
		(
			SELECT
				[extended_properties].[major_id],
				CONVERT([varchar](100), [extended_properties].[Value], 0) AS [value]
				FROM [sys].[extended_properties]
				WHERE
					[extended_properties].[class_desc] = N'OBJECT_OR_COLUMN'
					AND [extended_properties].[name] = N'Journal.Comments'
					AND [extended_properties].[minor_id] = 0
		)  AS [extended_properties_JournalComments]
			ON [tables].[object_id] = [extended_properties_JournalComments].[major_id]
		LEFT OUTER JOIN
		(
			SELECT
				[columns].[object_id],
				[columns].[name] AS [Name],
				[types].[name] AS [DataType],
				[IdDataType].[CharacterLength]
				FROM [sys].[columns]
					INNER JOIN [sys].[types]
						ON
							[columns].[system_type_id] = [types].[system_type_id]
							AND [columns].[user_type_id] = [types].[user_type_id]
					INNER JOIN
					(
						VALUES
							('bigint', 20),
							('int', 11),
							('smallint', 6),
							('tinyint', 3),
							('numeric', 38),
							('decimal', 38)
					) AS [IdDataType]
						(
							[Name],
							[CharacterLength]
						)
						ON [types].[name] = [IdDataType].[Name]
				WHERE [columns].[is_identity] = 1
		) AS [columns_Identity]
			ON [tables].[object_id] = [columns_Identity].[object_id]
	WHERE
		[extended_properties_JournalNumberPrefix].[Value] IS NOT NULL
		AND
		(
			[Entity].[NumberPrefix] != [extended_properties_JournalNumberPrefix].[value]
			OR
			(
				(
					LEN([extended_properties_JournalNumberPrefix].[value])
					+ [columns_Identity].[CharacterLength]
				) != [Entity].[MaximumCharacterCount]
				OR [Entity].[Name] IS NULL
			)
		)
	ORDER BY
		[schemas].[name] ASC,
		[tables].[name] ASC
