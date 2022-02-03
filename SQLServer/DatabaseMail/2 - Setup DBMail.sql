--Configure seerver to permit DatabaseMail
IF NOT EXISTS
(
	SELECT 1
		FROM [master].[sys].[configurations]
		WHERE
			[configurations].[name] = N'show advanced options'
			AND [configurations].[value_in_use] = 1
)
	BEGIN
		EXECUTE(N'EXEC [master].[sys].[sp_configure] N''show advanced options'', 1')
		EXECUTE(N'RECONFIGURE WITH OVERRIDE')
	END
IF NOT EXISTS
(
	SELECT 1
		FROM [master].[sys].[configurations]
		WHERE
			[configurations].[name] = N'Agent XPs'
			AND [configurations].[value_in_use] = 1
)
	BEGIN
		EXECUTE(N'EXEC [master].[sys].[sp_configure] N''Agent XPs'', 1')
		EXECUTE(N'RECONFIGURE WITH OVERRIDE')
	END
IF NOT EXISTS
(
	SELECT 1
		FROM [master].[sys].[configurations]
		WHERE
			[configurations].[name] = N'Database Mail XPs'
			AND [configurations].[value_in_use] = 1
)
	BEGIN
		EXECUTE(N'EXEC [master].[sys].[sp_configure] N''Database Mail XPs'', 1')
		EXECUTE(N'RECONFIGURE WITH OVERRIDE')
	END
IF EXISTS
(
	SELECT 1
		FROM [master].[sys].[configurations]
		WHERE
			[configurations].[name] = N'show advanced options'
			AND [configurations].[value_in_use] = 1
)
	BEGIN
		EXECUTE(N'EXEC [master].[sys].[sp_configure] N''show advanced options'', 0')
		EXECUTE(N'RECONFIGURE WITH OVERRIDE')
	END



DECLARE
	@DeleteBeforeCreate [bit],
	@EmailAddress [sys].[sysname],
	@ProfileName [sys].[sysname],
	@ProfileDescription [nvarchar](256),
	@AccountName [sys].[sysname],
	@AccountDescription [nvarchar](256),
	@UserName [sys].[sysname],
	@Password [sys].[sysname],
	@DisplayName [sys].[sysname],
	@MailServer [sys].[sysname],
	@MailServerType [sys].[sysname],
	@MailServerPort [int],
	@RequireSSL [bit],
	@PermittedPrincipal [sys].[sysname]
DECLARE _DatabaseMailSettings CURSOR LOCAL READ_ONLY FORWARD_ONLY FOR
	SELECT
		[DeleteBeforeCreate],
		[EmailAddress],
		[ProfileName],
		[ProfileDescription],
		[AccountName],
		[AccountDescription],
		[UserName],
		[Password],
		[DisplayName],
		[MailServer],
		[MailServerType],
		[MailServerPort],
		[RequireSSL],
		[PermittedPrincipal]
		FROM [##DatabaseMailSettings]
OPEN _DatabaseMailSettings
FETCH NEXT FROM _DatabaseMailSettings
	INTO @DeleteBeforeCreate, @EmailAddress, @ProfileName, @ProfileDescription, @AccountName, @AccountDescription, @UserName, @Password, @DisplayName, @MailServer, @MailServerType, @MailServerPort, @RequireSSL, @PermittedPrincipal
WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			IF @DeleteBeforeCreate = 1
				BEGIN
					IF EXISTS
					(
						SELECT 1
							FROM [msdb].[dbo].[sysmail_profile]
							WHERE [sysmail_profile].[name] = @ProfileName
					)
						BEGIN
							PRINT CONCAT('Deleting profile (', @ProfileName, ')...')
							EXEC [msdb].[dbo].[sysmail_delete_profile_sp]
								@profile_name = @ProfileName
						END
					IF EXISTS
					(
						SELECT 1
							FROM [msdb].[dbo].[sysmail_account]
							WHERE [sysmail_account].[name] = @AccountName
					)
						BEGIN
							PRINT CONCAT('Deleting account (', @AccountName, ')...')
							EXEC [msdb].[dbo].[sysmail_delete_account_sp]
								@account_name = @AccountName
						END
				END
			IF NOT EXISTS
			(
				SELECT 1
					FROM [msdb].[dbo].[sysmail_profile]
					WHERE [sysmail_profile].[name] = @ProfileName
			)
				BEGIN
					PRINT CONCAT('Adding profile (', @ProfileName, ')...')
					EXEC [msdb].[dbo].[sysmail_add_profile_sp]
						@profile_name = @ProfileName,
						@description = @ProfileDescription
				END
			IF NOT EXISTS
			(
				SELECT 1
					FROM [msdb].[dbo].[sysmail_account]
					WHERE [sysmail_account].[name] = @AccountName
			)
				BEGIN
					PRINT CONCAT('Adding account (', @AccountName, ')...')
					EXEC [msdb].[dbo].[sysmail_add_account_sp]
						@account_name = @AccountName,
						@email_address = @EmailAddress,
						@display_name = @DisplayName,
						@replyto_address = @EmailAddress,
						@description = @AccountDescription,
						@mailserver_name = @MailServer,
						@mailserver_type = @MailServerType,
						@port = @MailServerPort,
						@username = @UserName,
						@password = @Password,
						@use_default_credentials = 0,
						@enable_ssl = @RequireSSL
				END
			IF NOT EXISTS
			(
				SELECT 1
					FROM [msdb].[dbo].[sysmail_profileaccount]
						INNER JOIN [msdb].[dbo].[sysmail_profile]
							ON [sysmail_profileaccount].[profile_id] = [sysmail_profile].[profile_id]
						INNER JOIN [msdb].[dbo].[sysmail_account]
							ON [sysmail_profileaccount].[account_id] = [sysmail_account].[account_id]
					WHERE
						[sysmail_profile].[name] = @ProfileName
						AND [sysmail_account].[name] = @AccountName
			)
				BEGIN
					PRINT CONCAT('Adding profile <-> account link (', @ProfileName, ' <-> ', @AccountName, '...')
					EXEC [msdb].[dbo].[sysmail_add_profileaccount_sp]
						@profile_name = @ProfileName,
						@account_name = @AccountName,
						@sequence_number = 1
					END
			IF NOT EXISTS
			(
				SELECT 1
					FROM [msdb].[dbo].[sysmail_principalprofile]
						INNER JOIN [msdb].[sys].[database_principals]
							ON [sysmail_principalprofile].[principal_sid] = [database_principals].[sid]
						INNER JOIN [msdb].[dbo].[sysmail_profile]
							ON [sysmail_principalprofile].[profile_id] = [sysmail_profile].[profile_id]
					WHERE
						(
							(
								@PermittedPrincipal = N'public'
								AND [database_principals].[name] = N'guest'
							)
							OR
							(
								@PermittedPrincipal != N'public'
								AND [database_principals].[name] = @PermittedPrincipal
							)
						) AND [sysmail_profile].[name] = @ProfileName
			)
				BEGIN
					PRINT CONCAT('Adding default profile principal (', @PermittedPrincipal, ')...')
					EXEC [msdb].[dbo].[sysmail_add_principalprofile_sp]
						@principal_name = @PermittedPrincipal,
						@profile_name = @ProfileName,
						@is_default = 1
				END
		END TRY
		BEGIN CATCH
			THROW
		END CATCH
		FETCH NEXT FROM _DatabaseMailSettings
			INTO @DeleteBeforeCreate, @EmailAddress, @ProfileName, @ProfileDescription, @AccountName, @AccountDescription, @UserName, @Password, @DisplayName, @MailServer, @MailServerType, @MailServerPort, @RequireSSL, @PermittedPrincipal
	END
CLOSE _DatabaseMailSettings
DEALLOCATE _DatabaseMailSettings

--DECLARE
--	@DeleteBeforeCreate [bit] = 1,
--	@EmailAddress [sys].[sysname] = N'tsdsqlaws@foxrentacar.com',
--	@ProfileName [sys].[sysname] = N'tsdsqlaws Mail Profile',
--	@ProfileDescription [nvarchar](256) = N'Profile used for tsdsqlaws.',
--	@AccountName [sys].[sysname] = N'tsdsqlaws',
--	@AccountDescription [nvarchar](256) = N'Email account used for tsdsqlaws.',
--	@UserName [sys].[sysname] = N'tsdsqlaws@foxrentacar.com',
--	@Password [sys].[sysname] = N'nw^#qr!w7t9M27337!tT',
--	@DisplayName [sys].[sysname] = N'tsdsqlaws@foxrentacar.com',
--	@MailServer [sys].[sysname] = N'smtp-relay.gmail.com',
--	@MailServerType [sys].[sysname] = N'SMTP',
--	@MailServerPort [int] = 587,
--	@RequireSSL [bit] = 1,
--	@PermittedPrincipal [sys].[sysname] = N'public',
--	@TestEmailRecipient [varchar](320) = N'bmorris@foxrentacar.com'
