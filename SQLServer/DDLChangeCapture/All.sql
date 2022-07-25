--https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/bb522542(v=sql.105)
USE [master]
GO
IF NOT EXISTS
(
	SELECT *
		FROM [sys].[databases]
		WHERE [databases].[name] = N'DDLChangeCapture'
)
	BEGIN
		CREATE DATABASE [DDLChangeCapture]
			CONTAINMENT = NONE
			ON PRIMARY 
			(
				NAME = N'DDLChangeCapture', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DDLChangeCapture.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB
			)
			LOG ON
			(
				NAME = N'DDLChangeCapture_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DDLChangeCapture_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB
			)
			WITH CATALOG_COLLATION = DATABASE_DEFAULT
		IF (FULLTEXTSERVICEPROPERTY('IsFullTextInstalled') = 1)
				EXEC [DDLChangeCapture].[dbo].[sp_fulltext_database] @action = 'enable'
		ALTER DATABASE [DDLChangeCapture] SET ANSI_NULL_DEFAULT OFF 
		ALTER DATABASE [DDLChangeCapture] SET ANSI_NULLS OFF 
		ALTER DATABASE [DDLChangeCapture] SET ANSI_PADDING OFF 
		ALTER DATABASE [DDLChangeCapture] SET ANSI_WARNINGS OFF 
		ALTER DATABASE [DDLChangeCapture] SET ARITHABORT OFF 
		ALTER DATABASE [DDLChangeCapture] SET AUTO_CLOSE OFF 
		ALTER DATABASE [DDLChangeCapture] SET AUTO_SHRINK OFF 
		ALTER DATABASE [DDLChangeCapture] SET AUTO_UPDATE_STATISTICS ON 
		ALTER DATABASE [DDLChangeCapture] SET CURSOR_CLOSE_ON_COMMIT OFF 
		ALTER DATABASE [DDLChangeCapture] SET CURSOR_DEFAULT  GLOBAL 
		ALTER DATABASE [DDLChangeCapture] SET CONCAT_NULL_YIELDS_NULL OFF 
		ALTER DATABASE [DDLChangeCapture] SET NUMERIC_ROUNDABORT OFF 
		ALTER DATABASE [DDLChangeCapture] SET QUOTED_IDENTIFIER OFF 
		ALTER DATABASE [DDLChangeCapture] SET RECURSIVE_TRIGGERS OFF 
		ALTER DATABASE [DDLChangeCapture] SET  DISABLE_BROKER 
		ALTER DATABASE [DDLChangeCapture] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
		ALTER DATABASE [DDLChangeCapture] SET DATE_CORRELATION_OPTIMIZATION OFF 
		ALTER DATABASE [DDLChangeCapture] SET TRUSTWORTHY OFF 
		ALTER DATABASE [DDLChangeCapture] SET ALLOW_SNAPSHOT_ISOLATION OFF 
		ALTER DATABASE [DDLChangeCapture] SET PARAMETERIZATION SIMPLE 
		ALTER DATABASE [DDLChangeCapture] SET READ_COMMITTED_SNAPSHOT OFF 
		ALTER DATABASE [DDLChangeCapture] SET HONOR_BROKER_PRIORITY OFF 
		ALTER DATABASE [DDLChangeCapture] SET RECOVERY FULL 
		ALTER DATABASE [DDLChangeCapture] SET  MULTI_USER 
		ALTER DATABASE [DDLChangeCapture] SET PAGE_VERIFY CHECKSUM  
		ALTER DATABASE [DDLChangeCapture] SET DB_CHAINING OFF 
		ALTER DATABASE [DDLChangeCapture] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
		ALTER DATABASE [DDLChangeCapture] SET TARGET_RECOVERY_TIME = 60 SECONDS 
		ALTER DATABASE [DDLChangeCapture] SET DELAYED_DURABILITY = DISABLED 
		ALTER DATABASE [DDLChangeCapture] SET ACCELERATED_DATABASE_RECOVERY = OFF  
		ALTER DATABASE [DDLChangeCapture] SET QUERY_STORE = OFF
		ALTER DATABASE [DDLChangeCapture] SET  READ_WRITE 
	END
--GO
USE [master]
GO
IF EXISTS
(
	SELECT * 
		FROM [sys].[server_triggers]
		WHERE [server_triggers].[name] = N'DDLChnageCapture'
)
	DROP TRIGGER [DDLChnageCapture]
		ON ALL SERVER
GO
USE [DDLChangeCapture]
GO
IF EXISTS
(
	SELECT * 
		FROM [sys].[procedures]
			INNER JOIN [sys].[schemas]
				ON [procedures].[schema_id] = [schemas].[schema_id]
		WHERE
			[schemas].[name] = N'dbo'
			AND [procedures].[name] = N'LogEvent'
)
	DROP PROCEDURE [dbo].[LogEvent]
IF EXISTS
(
	SELECT * 
		FROM [sys].[views]
			INNER JOIN [sys].[schemas]
				ON [views].[schema_id] = [schemas].[schema_id]
		WHERE
			[schemas].[name] = N'dbo'
			AND [views].[name] = N'Events'
)
	DROP VIEW [dbo].[Events]
IF EXISTS
(
	SELECT * 
		FROM [sys].[tables]
			INNER JOIN [sys].[schemas]
				ON [tables].[schema_id] = [schemas].[schema_id]
		WHERE
			[schemas].[name] = N'dbo'
			AND [tables].[name] = N'Event'
)
	DROP TABLE [dbo].[Event]
IF EXISTS
(
	SELECT * 
		FROM [sys].[tables]
			INNER JOIN [sys].[schemas]
				ON [tables].[schema_id] = [schemas].[schema_id]
		WHERE
			[schemas].[name] = N'dbo'
			AND [tables].[name] = N'EventType'
)
	DROP TABLE [dbo].[EventType]
GO
CREATE TABLE [dbo].[EventType]
(
	[EventTypeId] [int] IDENTITY(1, 1) NOT NULL,
	[Name] [sysname] NULL,
	CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED ([EventTypeId])
		WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)  ON [PRIMARY]
GO
CREATE TABLE [dbo].[Event]
(
	[EventId] [bigint] IDENTITY(1, 1) NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[PostTimeUTC] [datetime2](7) NOT NULL,
	[DatabaseName] [sys].[sysname] NULL,
	[LoginName] [sys].[sysname] NULL,
	[CommandText] [nvarchar](MAX),
	[EventData] [xml] NOT NULL,
	CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED ([EventId])
		WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	CONSTRAINT [FK_Event_EventType] FOREIGN KEY([EventTypeId]) REFERENCES [dbo].[EventType]([EventTypeId])
)  ON [PRIMARY]
GO
CREATE PROCEDURE [dbo].[LogEvent]
(
	@EventData [xml]
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @UTCOffsetMinutes [int] = DATEDIFF([MINUTE], SYSUTCDATETIME(), SYSDATETIME())
	DECLARE @EventType [sys].[sysname] =
		@EventData.value('(/EVENT_INSTANCE/EventType)[1]','[sys].[sysname]')
	IF NOT EXISTS
	(
		SELECT 1
			FROM [dbo].[EventType]
			WHERE [Name] = @EventType
	)
		INSERT INTO [dbo].[EventType]([Name]) VALUES(@EventType)
	INSERT INTO [dbo].[Event]([EventTypeId], [PostTimeUTC], [DatabaseName], [LoginName], [CommandText], [EventData])
	SELECT
		[EventType].[EventTypeId],
		DATEADD([MINUTE], @UTCOffsetMinutes, [EVENT_INSTANCE].[PostTimeLocal]) AS [PostTimeUTC],
		[EVENT_INSTANCE].[DatabaseName],
		[EVENT_INSTANCE].[LoginName],
		[EVENT_INSTANCE].[CommandText],
		@EventData AS [EventData]
		FROM
		(
			SELECT
				[EVENT_INSTANCE].[Attributes].value('(EventType)[1]','[sys].[sysname]') AS [EventType],
				[EVENT_INSTANCE].[Attributes].value('(PostTime)[1]','[datetime2](7)') AS [PostTimeLocal],
				[EVENT_INSTANCE].[Attributes].value('(LoginName)[1]','[sys].[sysname]') AS [LoginName],
				[EVENT_INSTANCE].[Attributes].value('(DatabaseName)[1]','[sys].[sysname]') AS [DatabaseName],
				[EVENT_INSTANCE].[Attributes].value('(TSQLCommand/CommandText)[1]','nvarchar(max)') AS [CommandText]
				FROM @EventData.nodes(N'//EVENT_INSTANCE') AS [EVENT_INSTANCE]([Attributes])
		) AS [EVENT_INSTANCE]
			INNER JOIN [dbo].[EventType]
				ON [EVENT_INSTANCE].[EventType] = [EventType].[Name]
END
GO
CREATE OR ALTER VIEW [dbo].[Events]
AS
	SELECT
		[EventType].[Name] AS [EventType],
		[Event].[PostTimeUTC],
		[Event].[DatabaseName],
		[Event].[LoginName],
		[Event].[CommandText]
		FROM [dbo].[Event]
			INNER JOIN [dbo].[EventType]
				ON [Event].[EventTypeId] = [EventType].[EventTypeId]
GO
USE [master] 
GO
CREATE TRIGGER [DDLChnageCapture]
	ON ALL SERVER 
	FOR
		--ServerRole:
			ADD_SERVER_ROLE_MEMBER,DROP_SERVER_ROLE_MEMBER,
		--Login:
			CREATE_LOGIN, ALTER_LOGIN, DROP_LOGIN,
		--LinkedServer:
			CREATE_LINKED_SERVER, ALTER_LINKED_SERVER, DROP_LINKED_SERVER,
		--Database:
			CREATE_DATABASE, ALTER_DATABASE, DROP_DATABASE,
		--Schema:
			CREATE_SCHEMA, ALTER_SCHEMA, DROP_SCHEMA,
		--Type:
			CREATE_TYPE, DROP_TYPE,
		--XML Schemas:
			CREATE_XML_SCHEMA_COLLECTION, ALTER_XML_SCHEMA_COLLECTION, DROP_XML_SCHEMA_COLLECTION,
		--Table:
			CREATE_TABLE, ALTER_TABLE, DROP_TABLE,
		--Indexes:
			CREATE_INDEX, CREATE_SPATIAL_INDEX, CREATE_XML_INDEX, ALTER_INDEX, DROP_INDEX,
		--Statistics:
			CREATE_STATISTICS, DROP_STATISTICS, UPDATE_STATISTICS,
		--Trigger:
			CREATE_TRIGGER, ALTER_TRIGGER, DROP_TRIGGER,
		--Function:
			CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION,
		--View:
			CREATE_VIEW, ALTER_VIEW, DROP_VIEW,
		--Synonym:
			CREATE_SYNONYM, DROP_SYNONYM,
		--Procedures:
			CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE,
		--Application Roles:
			CREATE_APPLICATION_ROLE, ALTER_APPLICATION_ROLE, DROP_APPLICATION_ROLE,
		--Database Roles:
			CREATE_ROLE, ALTER_ROLE, DROP_ROLE,
		--Users:
			CREATE_USER, ALTER_USER, DROP_USER,
		--Database Access:
			GRANT_DATABASE ,DENY_DATABASE, REVOKE_DATABASE,
		--Role Members:
			ADD_ROLE_MEMBER, DROP_ROLE_MEMBER,
		--Objects:
			RENAME 
AS
BEGIN
    DECLARE @EventData [xml] = EVENTDATA()
	EXEC [DDLChangeCapture].[dbo].[LogEvent] @EventData = @EventData
END
GO
USE [DDLChangeCapture]
GO
SELECT *
	FROM [dbo].[Events]
GO
