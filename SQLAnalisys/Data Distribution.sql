SELECT DISTINCT
	[objects].schema_id,
	[objects].name as table_name,
	[partition_schemes].name as PScheme,
	[partition_functions].name as PFunction,
	[partition_range_values].value as partition_range,
	[filegroups].name as file_groupName,
	[partitions].partition_number,
	[partitions].rows as number_of_rows
	FROM [sys].[partitions]
		INNER JOIN [sys].[objects]
			ON [partitions].[object_id] = [objects].[object_id]
		INNER JOIN [sys].[indexes]
			ON
				[objects].[object_id] = [indexes].[object_id]
				AND [partitions].[index_id] = [indexes].[index_id]
		INNER JOIN [sys].[system_internals_allocation_units]
			ON [partitions].[partition_id] = [system_internals_allocation_units].[container_id]
		INNER JOIN [sys].[partition_schemes]
			ON [indexes].[data_space_id] = [partition_schemes].[data_space_id]
		INNER JOIN [sys].[partition_functions]
			ON [partition_schemes].[function_id] = [partition_functions].[function_id]
		INNER JOIN [sys].[destination_data_spaces]
			ON
				[partition_schemes].[data_space_id] = [destination_data_spaces].[partition_scheme_id]
				AND [partitions].[partition_number] = [destination_data_spaces].[destination_id]
		INNER JOIN [sys].[filegroups]
			ON [destination_data_spaces].[data_space_id] = [filegroups].[data_space_id]
		LEFT OUTER JOIN [sys].[partition_range_values]
			ON
				[partition_functions].[function_id] = [partition_range_values].[function_id]
				AND [partitions].[partition_number] = [partition_range_values].[boundary_id]
