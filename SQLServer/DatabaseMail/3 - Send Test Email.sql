DECLARE
	@DatabaseMailSettingsId [int],
	@EmailAddress [sys].[sysname],
	@ProfileName [sys].[sysname],
	@ProfileDescription [nvarchar](256),
	@AccountName [sys].[sysname],
	@AccountDescription [nvarchar](256),
	@UserName [sys].[sysname],
	@DisplayName [sys].[sysname],
	@MailServer [sys].[sysname],
	@MailServerType [sys].[sysname],
	@MailServerPort [int],
	@RequireSSL [bit],
	@PermittedPrincipal [sys].[sysname],
	@TestEmailTo [varchar](MAX),
	@TestEmailCC [varchar](MAX),
	@TestEmailBCC [varchar](MAX),
	@Subject [nvarchar](255),
	@Body [nvarchar](MAX),
	@TestMailItemId [int]
DECLARE _DatabaseMailSettings CURSOR LOCAL READ_ONLY FORWARD_ONLY FOR
	SELECT
		[DatabaseMailSettingsId],
		[EmailAddress],
		[ProfileName],
		[ProfileDescription],
		[AccountName],
		[AccountDescription],
		[UserName],
		[DisplayName],
		[MailServer],
		[MailServerType],
		[MailServerPort],
		[RequireSSL],
		[PermittedPrincipal],
		[TestEmailTo],
		[TestEmailCC],
		[TestEmailBCC]
		FROM [##DatabaseMailSettings]
		WHERE [TestEmailTo] IS NOT NULL
OPEN _DatabaseMailSettings
FETCH NEXT FROM _DatabaseMailSettings
	INTO
		@DatabaseMailSettingsId, @EmailAddress, @ProfileName, @ProfileDescription, @AccountName, @AccountDescription, @UserName, @DisplayName,
		@MailServer, @MailServerType, @MailServerPort, @RequireSSL, @PermittedPrincipal, @TestEmailTo, @TestEmailCC, @TestEmailBCC
WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			PRINT 'Sending test email...'
			SET @Subject = CONCAT(N'Testing DatabaseMail on ', @@SERVERNAME, N' using ', @ProfileName, N' profile')
			SET @Body = CONCAT
			(
				N'This email was generated by the SQL Server DatabaseMail setup scripts.', CHAR(10),
				N'https://github.com/bradleydonmorris/Common/tree/main/SQLServer/DatabaseMail', CHAR(10), CHAR(10),
				N'Email Address:       ', @EmailAddress, CHAR(10),
				N'Profile Name:        ', @ProfileName, CHAR(10),
				N'Profile Description: ', @ProfileDescription, CHAR(10),
				N'Account Name:        ', @AccountName, CHAR(10),
				N'Account Description: ', @AccountDescription, CHAR(10),
				N'User Name:           ', @UserName, CHAR(10),
				N'Display Name:        ', @DisplayName, CHAR(10),
				N'Mail Server:         ', @MailServer, CHAR(10),
				N'Mail Server Type:    ', @MailServerType, CHAR(10),
				N'Mail Server Port:    ', @MailServerPort, CHAR(10),
				N'Require SSL:         ', @RequireSSL, CHAR(10),
				N'Permitted Principal: ', @PermittedPrincipal, CHAR(10)
			)
			--PRINT @Body
			EXEC [msdb].[dbo].[sp_send_dbmail]
				@profile_name = @ProfileName,
				@recipients = @TestEmailTo,
				@copy_recipients = @TestEmailCC,
				@blind_copy_recipients = @TestEmailBCC,
				@subject = N'Testing DatabaseMail ',
				@body = @Body,
				@mailitem_id = @TestMailItemId OUTPUT
			UPDATE [##DatabaseMailSettings]
				SET [TestMailItemId] = @TestMailItemId
				WHERE [DatabaseMailSettingsId] = @DatabaseMailSettingsId
			FETCH NEXT FROM _DatabaseMailSettings
				INTO
					@DatabaseMailSettingsId, @EmailAddress, @ProfileName, @ProfileDescription, @AccountName, @AccountDescription, @UserName, @DisplayName,
					@MailServer, @MailServerType, @MailServerPort, @RequireSSL, @PermittedPrincipal, @TestEmailTo, @TestEmailCC, @TestEmailBCC
		END TRY
		BEGIN CATCH
			THROW
		END CATCH
	END

CLOSE _DatabaseMailSettings