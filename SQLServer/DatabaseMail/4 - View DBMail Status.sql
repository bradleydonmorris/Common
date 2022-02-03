DECLARE @LastNumberOfDays [bigint] = 15
DECLARE @LastDateTime [datetimeoffset](7) = DATEADD([day], -@LastNumberOfDays, SYSDATETIMEOFFSET())
DECLARE @Text [nvarchar](MAX)
DECLARE _Log CURSOR FORWARD_ONLY READ_ONLY FOR
	SELECT
		CONCAT
		(
			CHAR(10),
			'Mail Item ID:    ', [sysmail_mailitems].[mailitem_id], CHAR(10),
			CHAR(9), 'Status:      ', 
				CASE [sysmail_mailitems].[sent_status]
					WHEN 0 THEN 'Unsent'
					WHEN 1 THEN 'Sent'
					WHEN 2 THEN 'Failed'
					WHEN 3 THEN 'Retrying'
					ELSE 'Failed'
				END, CHAR(10),
			CHAR(9), 'Profile:     ', [sysmail_profile].[name], CHAR(10),
			CHAR(9), 'From:        ', ISNULL([sysmail_mailitems].[from_address], 'NULL'), CHAR(10),
			CHAR(9), 'Reply To:    ', ISNULL([sysmail_mailitems].[reply_to], 'NULL'), CHAR(10),
			CHAR(9), 'To:          ', ISNULL([sysmail_mailitems].[recipients], 'NULL'), CHAR(10),
			CHAR(9), 'CC:          ', ISNULL([sysmail_mailitems].[copy_recipients], 'NULL'), CHAR(10),
			CHAR(9), 'BCC:         ', ISNULL([sysmail_mailitems].[blind_copy_recipients], 'NULL'), CHAR(10),
			CHAR(9), 'Subject:     ', ISNULL([sysmail_mailitems].[subject], 'NULL'), CHAR(10),
			CHAR(9), 'Importance:  ', [sysmail_mailitems].[importance], CHAR(10),
			CHAR(9), 'Sensitivity: ', [sysmail_mailitems].[sensitivity], CHAR(10),
			CHAR(9), 'Body (', [sysmail_mailitems].[body_format], '): ', [sysmail_mailitems].[body], CHAR(10),
			CASE
				WHEN [Log].[Entries] IS NOT NULL
					THEN
						CONCAT
						(
							CHAR(9), 'Log Enties:', CHAR(10),
							REPLACE(LEFT([Log].[Entries], (LEN([Log].[Entries]) - 2)), '||', (CHAR(10) + CHAR(10)))
						)
				ELSE 'Log Entries: NULL'
			END
		) AS [Text]
		FROM [##DatabaseMailSettings]
			INNER JOIN [msdb].[dbo].[sysmail_mailitems]
				ON [##DatabaseMailSettings].[TestMailItemId] = [sysmail_mailitems].[mailitem_id]
			INNER JOIN [msdb].[dbo].[sysmail_profile]
				ON [sysmail_mailitems].[profile_id] = [sysmail_profile].[profile_id]
			OUTER APPLY
			(
				SELECT
					(
						SELECT
							CONCAT
							(
								CHAR(9), CHAR(9), 'Log Date:    ', FORMAT(SWITCHOFFSET(TODATETIMEOFFSET([sysmail_log].[log_date], DATEPART([TZoffset], SYSDATETIMEOFFSET())), '+00:00'), 'yyyy-MM-dd HH:mm:ss'), CHAR(10),
								CHAR(9), CHAR(9), 'Type:        ',
									CASE [sysmail_log].[event_type]
										WHEN 0 THEN 'Success'
										WHEN 1 THEN 'Information'
										WHEN 2 THEN 'Warning'
										WHEN 3 THEN 'Error'
										ELSE 'Error'
									END, CHAR(10),
								CHAR(9), CHAR(9), 'Description: ', REPLACE(REPLACE([sysmail_log].[description], CHAR(13), ' '), CHAR(10), ' '), '||'
							)
							FROM [msdb].[dbo].[sysmail_log]
							WHERE [sysmail_log].[mailitem_id] = [sysmail_mailitems].[mailitem_id]
							ORDER BY [sysmail_log].[log_date] DESC
							FOR XML PATH('')
					) AS [Entries]
			) AS [Log]
		WHERE 
			SWITCHOFFSET(TODATETIMEOFFSET([sysmail_mailitems].[last_mod_date], DATEPART([TZoffset], SYSDATETIMEOFFSET())), '+00:00')
				>= @LastDateTime
		ORDER BY [sysmail_mailitems].[last_mod_date] DESC
OPEN _Log
FETCH NEXT FROM _Log INTO @Text
WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @Text
		FETCH NEXT FROM _Log INTO @Text
	END
CLOSE _Log
DEALLOCATE _Log
