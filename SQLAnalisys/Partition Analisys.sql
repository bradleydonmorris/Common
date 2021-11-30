SELECT
	[schemas].[schema_id],
	[objects].[object_id],
	[indexes].[index_id],
	[partitions].[partition_id],
	[FileGroup].[data_space_id],
	[schemas].[name] AS [SchemaName],
	[objects].[name] AS [ObjectName],
	[indexes].[name] AS [IndexName],
	[partitions].[partition_number] AS [PartitionNumber],
	[FileGroup].[FileGroupName],
	[FileGroup].[LogicalFileNames],
	[FileGroup].[PhysicalFileNames],
	[partitions].[rows] AS [RowCount],
	[allocation_units_Summary].[TotalSpaceKB],
	[allocation_units_Summary].[UsedSpaceKB],
	[allocation_units_Summary].[UnusedSpaceKB]
	FROM [sys].[partitions]
		INNER JOIN [sys].[objects]
			ON [partitions].[object_id] = [objects].[object_id]
		INNER JOIN [sys].[schemas]
			ON [objects].[schema_id] = [schemas].[schema_id]
		INNER JOIN [sys].[indexes]
			ON
				[objects].[object_id] = [indexes].[object_id]
				AND [partitions].[index_id] = [indexes].[index_id]
		LEFT OUTER JOIN
		(
			SELECT
				[allocation_units].[container_id],
				[allocation_units].[data_space_id],
				SUM([allocation_units].[total_pages]) * 8 AS [TotalSpaceKB],
				SUM([allocation_units].[used_pages]) * 8 AS [UsedSpaceKB],
				(SUM([allocation_units].[total_pages]) - SUM([allocation_units].[used_pages])) * 8 AS [UnusedSpaceKB]
				FROM [sys].[allocation_units]
				GROUP BY
					[allocation_units].[container_id],
					[allocation_units].[data_space_id]
		) AS [allocation_units_Summary]
			ON [partitions].[partition_id] = [allocation_units_Summary].[container_id]
		LEFT OUTER JOIN
		(
			SELECT
				[filegroups].[data_space_id],
				[filegroups].[name] AS [FileGroupName],
				[filegroups].[type_desc] AS [FileGroupType],
				[filegroups].[is_default],

				--Using older FOR XML version
				--	Since STRING_AGG not available on older versions of SQL Server
				CASE
					WHEN (RIGHT([Files].[LogicalFileNames], 1) = N'|')
						THEN REPLACE(LEFT([Files].[LogicalFileNames], (LEN([Files].[LogicalFileNames]) - 1)), N'|', N', ')
					ELSE NULL
				END AS [LogicalFileNames],
				CASE
					WHEN (RIGHT([Files].[PhysicalFileNames], 1) = N'|')
						THEN REPLACE(LEFT([Files].[PhysicalFileNames], (LEN([Files].[PhysicalFileNames]) - 1)), N'|', N', ')
					ELSE NULL
				END AS [PhysicalFileNames]
				FROM [sys].[filegroups]
					OUTER APPLY
					(
						SELECT
						(
							SELECT
								[database_files].[name] + '|'
								FROM [sys].[database_files]
								WHERE [database_files].[data_space_id] = [filegroups].[data_space_id]
								FOR XML PATH('')
						) AS [LogicalFileNames],
						(
							SELECT
								[database_files].[physical_name] + '|'
								FROM [sys].[database_files]
								WHERE [database_files].[data_space_id] = [filegroups].[data_space_id]
								FOR XML PATH('')
						) AS [PhysicalFileNames]
					) AS [Files]
		) AS [FileGroup]
			ON [allocation_units_Summary].[data_space_id] = [FileGroup].[data_space_id]
	WHERE
		[schemas].[name] != N'sys'
		--[objects].[object_id] = 2085480394
		AND [partitions].[partition_number] != 1
