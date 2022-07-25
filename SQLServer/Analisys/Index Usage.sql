SELECT
	[schemas].[name] AS [Schema],
	[objects].[name] AS [Object],
	[objects].[type_desc] AS [Type],
	[indexes].[name] AS [Index],
	[indexes].[type_desc] AS [IndexType],
	[dm_db_index_usage_stats].[user_seeks] AS [UserSeeks],
	[dm_db_index_usage_stats].[user_scans] AS [UserScans],
	[dm_db_index_usage_stats].[user_lookups] AS [UserLookups],
	[dm_db_index_usage_stats].[user_updates] AS [UserUpdates],
	[dm_db_index_usage_stats].[last_user_seek] AS [LastUserSeek],
	[dm_db_index_usage_stats].[last_user_scan] AS [LastUserScan],
	[dm_db_index_usage_stats].[last_user_lookup] AS [LastUserLookup],
	[dm_db_index_usage_stats].[last_user_update] AS [LastUserUpdate]
	FROM [sys].[schemas]
		INNER JOIN [sys].[objects]
			ON [schemas].[schema_id] = [objects].[schema_id]
		INNER JOIN [sys].[indexes]
			ON [objects].[object_id] = [indexes].[object_id]
		INNER JOIN [sys].[dm_db_index_usage_stats]
			ON
				[indexes].[index_id] = [dm_db_index_usage_stats].[index_id]
				AND [objects].[object_id] = [dm_db_index_usage_stats].[object_id]
	WHERE [schemas].[name] != N'sys'
	ORDER BY
		[schemas].[name],
		[objects].[name],
		[indexes].[name]
