--USE [master]
--GO
--CREATE DATABASE [DDLChangeCapture]
--	CONTAINMENT = NONE
--	ON PRIMARY 
--	(
--		NAME = N'DDLChangeCapture', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DDLChangeCapture.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB
--	)
--	LOG ON
--	(
--		NAME = N'DDLChangeCapture_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DDLChangeCapture_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB
--	)
--	WITH CATALOG_COLLATION = DATABASE_DEFAULT
--GO
--IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
--	BEGIN
--		EXEC [DDLChangeCapture].[dbo].[sp_fulltext_database] @action = 'enable'
--	END
--GO
--ALTER DATABASE [DDLChangeCapture] SET ANSI_NULL_DEFAULT OFF 
--ALTER DATABASE [DDLChangeCapture] SET ANSI_NULLS OFF 
--ALTER DATABASE [DDLChangeCapture] SET ANSI_PADDING OFF 
--ALTER DATABASE [DDLChangeCapture] SET ANSI_WARNINGS OFF 
--ALTER DATABASE [DDLChangeCapture] SET ARITHABORT OFF 
--ALTER DATABASE [DDLChangeCapture] SET AUTO_CLOSE OFF 
--ALTER DATABASE [DDLChangeCapture] SET AUTO_SHRINK OFF 
--ALTER DATABASE [DDLChangeCapture] SET AUTO_UPDATE_STATISTICS ON 
--ALTER DATABASE [DDLChangeCapture] SET CURSOR_CLOSE_ON_COMMIT OFF 
--ALTER DATABASE [DDLChangeCapture] SET CURSOR_DEFAULT  GLOBAL 
--ALTER DATABASE [DDLChangeCapture] SET CONCAT_NULL_YIELDS_NULL OFF 
--ALTER DATABASE [DDLChangeCapture] SET NUMERIC_ROUNDABORT OFF 
--ALTER DATABASE [DDLChangeCapture] SET QUOTED_IDENTIFIER OFF 
--ALTER DATABASE [DDLChangeCapture] SET RECURSIVE_TRIGGERS OFF 
--ALTER DATABASE [DDLChangeCapture] SET  DISABLE_BROKER 
--ALTER DATABASE [DDLChangeCapture] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
--ALTER DATABASE [DDLChangeCapture] SET DATE_CORRELATION_OPTIMIZATION OFF 
--ALTER DATABASE [DDLChangeCapture] SET TRUSTWORTHY OFF 
--ALTER DATABASE [DDLChangeCapture] SET ALLOW_SNAPSHOT_ISOLATION OFF 
--ALTER DATABASE [DDLChangeCapture] SET PARAMETERIZATION SIMPLE 
--ALTER DATABASE [DDLChangeCapture] SET READ_COMMITTED_SNAPSHOT OFF 
--ALTER DATABASE [DDLChangeCapture] SET HONOR_BROKER_PRIORITY OFF 
--ALTER DATABASE [DDLChangeCapture] SET RECOVERY FULL 
--ALTER DATABASE [DDLChangeCapture] SET  MULTI_USER 
--ALTER DATABASE [DDLChangeCapture] SET PAGE_VERIFY CHECKSUM  
--ALTER DATABASE [DDLChangeCapture] SET DB_CHAINING OFF 
--ALTER DATABASE [DDLChangeCapture] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
--ALTER DATABASE [DDLChangeCapture] SET TARGET_RECOVERY_TIME = 60 SECONDS 
--ALTER DATABASE [DDLChangeCapture] SET DELAYED_DURABILITY = DISABLED 
--ALTER DATABASE [DDLChangeCapture] SET ACCELERATED_DATABASE_RECOVERY = OFF  
--ALTER DATABASE [DDLChangeCapture] SET QUERY_STORE = OFF
--ALTER DATABASE [DDLChangeCapture] SET  READ_WRITE 
--GO
USE [DDLChangeCapture]
GO
--DROP TABLE [dbo].[EventType]
--CREATE TABLE [dbo].[EventType]
--(
--	[EventTypeId] [int] IDENTITY(1, 1) NOT NULL,
--	[Name] [sysname] NULL,
--	CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED ([EventTypeId])
--		WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--)  ON [PRIMARY]
--GO
--DROP TABLE [dbo].[Database]
--CREATE TABLE [dbo].[Database]
--(
--	[DatabaseId] [int] IDENTITY(1, 1) NOT NULL,
--	[Name] [sysname] NULL,
--	CONSTRAINT [PK_Database] PRIMARY KEY CLUSTERED ([DatabaseId])
--		WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--)  ON [PRIMARY]
--GO
--DROP TABLE [dbo].[DatabaseEvent]
--CREATE TABLE [dbo].[DatabaseEvent]
--(
--	[DatabaseEventId] [bigint] IDENTITY(1, 1) NOT NULL,
--	[DatabaseId] [int] NOT NULL,
--	[EventTypeId] [int] NOT NULL,
--	[PostTimeUTC] [datetime2](7) NOT NULL,
--	[LoginName] [sys].[sysname] NOT NULL,
--	[CommandText] [nvarchar](MAX),
--	CONSTRAINT [PK_DatabaseEvent] PRIMARY KEY CLUSTERED ([DatabaseEventId])
--		WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
--	CONSTRAINT [FK_DatabaseEvent_Database] FOREIGN KEY([DatabaseId]) REFERENCES [dbo].[Database]([DatabaseId]),
--	CONSTRAINT [FK_DatabaseEvent_EventType] FOREIGN KEY([EventTypeId]) REFERENCES [dbo].[EventType]([EventTypeId])
--)  ON [PRIMARY]
GO
CREATE OR ALTER PROCEDURE [dbo].[LogDatabaseEvent]
(
	@EventData [xml]
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @UTCOffsetMinutes [int] = DATEDIFF([MINUTE], SYSUTCDATETIME(), SYSDATETIME())
	DECLARE @EventType [sys].[sysname]
	DECLARE @Database [sys].[sysname]
	SELECT
		@EventType = @EventData.value('(/EVENT_INSTANCE/EventType)[1]','[sys].[sysname]'),
		@Database = @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]','[sys].[sysname]')
	IF NOT EXISTS
	(
		SELECT 1
			FROM [dbo].[EventType]
			WHERE [Name] = @EventType
	)
		INSERT INTO [dbo].[EventType]([Name]) VALUES(@EventType)
	IF NOT EXISTS
	(
		SELECT 1
			FROM [dbo].[Database]
			WHERE [Name] = @Database
	)
		INSERT INTO [dbo].[Database]([Name]) VALUES(@Database)
	INSERT INTO [dbo].[DatabaseEvent]([DatabaseId], [EventTypeId], [PostTimeUTC], [LoginName], [CommandText])
	SELECT
		[Database].[DatabaseId],
		[EventType].[EventTypeId],
		DATEADD([MINUTE], @UTCOffsetMinutes, [EVENT_INSTANCE].[PostTimeLocal]) AS [PostTimeUTC],
		[EVENT_INSTANCE].[LoginName],
		[EVENT_INSTANCE].[CommandText]
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
			INNER JOIN [dbo].[Database]
				ON [EVENT_INSTANCE].[DatabaseName] = [Database].[Name]
			INNER JOIN [dbo].[EventType]
				ON [EVENT_INSTANCE].[EventType] = [EventType].[Name]
END
GO
CREATE OR ALTER VIEW [dbo].[Events]
AS
	SELECT
		[Database].[Name] AS [Database],
		[EventType].[Name] AS [EventType],
		[DatabaseEvent].[PostTimeUTC],
		[DatabaseEvent].[LoginName],
		[DatabaseEvent].[CommandText]
		FROM [dbo].[DatabaseEvent]
			INNER JOIN [dbo].[Database]
				ON [DatabaseEvent].[DatabaseId] = [Database].[DatabaseId]
			INNER JOIN [dbo].[EventType]
				ON [DatabaseEvent].[EventTypeId] = [EventType].[EventTypeId]
GO
USE [master]
GO
IF EXISTS
(
	SELECT * 
		FROM [sys].[server_triggers]
		WHERE [name] = 'DDLTriger_Database'
)
	DROP TRIGGER [DDLTriger_Database]
		ON ALL SERVER;
GO
CREATE TRIGGER [DDLTriger_Database]
	ON ALL SERVER 
	FOR CREATE_DATABASE, ALTER_DATABASE, DROP_DATABASE
AS
BEGIN
    DECLARE @EventData [xml] = EVENTDATA()
	EXEC [DDLChangeCapture].[dbo].[LogDatabaseEvent] @EventData = @EventData
END
GO
USE [DDLChangeCapture]
GO
--EXEC [dbo].[LogDatabaseEvent] @EventData = @XML
SELECT * FROM [dbo].[Events]
