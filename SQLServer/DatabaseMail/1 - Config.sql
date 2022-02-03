--REMEBER: THIS FILE CONTAINS USER NAME AND PASSWORD
--DO NOT COMMIT IT TO GIT
--IT IS BEST TO COPY  THE SCRIPT TO AN UNSAVED QUERY WINDOW

--This script creates a global temp table used by other scripts
--Enter the configuration settings and execute this script.
--Keep this connection open while running the other scripts.

DROP TABLE IF EXISTS [##DatabaseMailSettings]
CREATE TABLE [##DatabaseMailSettings]
(
	[DatabaseMailSettingsId] [int] IDENTITY(1, 1) NOT NULL,
	[DeleteBeforeCreate] [bit] NOT NULL,
	[EmailAddress] [sys].[sysname] NOT NULL,
	[ProfileName] [sys].[sysname] NOT NULL,
	[ProfileDescription] [nvarchar](256) NOT NULL,
	[AccountName] [sys].[sysname] NOT NULL,
	[AccountDescription] [nvarchar](256) NOT NULL,
	[UserName] [sys].[sysname] NOT NULL,
	[Password] [sys].[sysname] NOT NULL,
	[DisplayName] [sys].[sysname] NOT NULL,
	[MailServer] [sys].[sysname] NOT NULL,
	[MailServerType] [sys].[sysname] NOT NULL,
	[MailServerPort] [int] NOT NULL,
	[RequireSSL] [bit] NOT NULL,
	[PermittedPrincipal] [sys].[sysname] NOT NULL,
	[TestEmailTo] [varchar](MAX) NULL,
	[TestEmailCC] [varchar](MAX) NULL,
	[TestEmailBCC] [varchar](MAX) NULL,
	[TestMailItemId] [int] NULL
)
INSERT INTO [##DatabaseMailSettings]([DeleteBeforeCreate], [EmailAddress], [ProfileName], [ProfileDescription], [AccountName], [AccountDescription], [UserName], [Password], [DisplayName], [MailServer], [MailServerType], [MailServerPort], [RequireSSL], [PermittedPrincipal], [TestEmailTo], [TestEmailCC], [TestEmailBCC])
VALUES
	(
		--Typical settings for Gmail
		1, --[DeleteBeforeCreate]
		N'SQLServerEmailAddress@gmail.com', --EmailAddress
		N'SQLServerEmailAddress Mail Profile', --ProfileName
		N'Profile used for SQLServerEmailAddress.', --ProfileDescription
		N'SQLServerEmailAddress', --AccountName
		N'Email account used for SQLServerEmailAddress.', --AccountDescription
		N'SQLServerEmailAddress@gmail.com', --UserName
		N'{GMAIL PASSWORD GOES HERE}', --Password
		CONCAT(N'TSD SQL (', @@SERVERNAME, N')'), --DisplayName
		N'smtp-relay.gmail.com', --MailServer
		N'SMTP', --MailServerType
		587, --MailServerPort
		1, --RequireSSL
		N'public', --PermittedPrincipal
		N'WhoDoYouWantToSendItTo@gmail.com', --TestEmailTo
		NULL, --TestEmailCC
		NULL --TestEmailBCC
	)
	--Multiple configurations can be specified.
	--The other scripts account for this.