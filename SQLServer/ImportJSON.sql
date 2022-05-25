SET NOCOUNT ON
DECLARE @BeginTime [datetime2](7)
DECLARE @EndTime [datetime2](7)
DECLARE @TimestampText [nvarchar](23)
DECLARE @ElementName [nvarchar](100)
DECLARE @ElementBeginTime [datetime2](7)
DECLARE @ElementEndTime [datetime2](7)
DECLARE @RowsAffected [int]
DECLARE @TotlaMinutes [nvarchar](100)

SET @BeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@BeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s Begin Import', 10, 1, @TimestampText) WITH NOWAIT

DECLARE @FileInformation [nvarchar](MAX)

SET @ElementName = N'File'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --File
	SELECT @FileInformation = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\FileInformation.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[File]
	INSERT INTO [SanctionList].[File]
		SELECT *
			FROM OPENJSON(@FileInformation)
				WITH
				(
					[FileName] [nvarchar](400) '$.FileName',
					[Type] [nvarchar](50) '$.Type',
					[DateTime] [datetime] '$.Date'
				)
	SET @RowsAffected = @@ROWCOUNT
END --File
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'FileElement'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --FileElement
	TRUNCATE TABLE [SanctionList].[FileElement]
	INSERT INTO [SanctionList].[FileElement]
		SELECT
			[key] AS [Name],
			[value] AS [FileRecordCount],
			NULL AS [ImportedRecordCount]
			FROM OPENJSON(@FileInformation, '$.Elements')
	SET @RowsAffected = @@ROWCOUNT
END --FileElement
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT



SET @ElementName = N'Countries'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --Country
	DECLARE @Countries [nvarchar](MAX)
	SELECT @Countries = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\Countries.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[Country]
	INSERT INTO [SanctionList].[Country]
		SELECT *
			FROM OPENJSON(@Countries)
				WITH
				(
					[Code] [nvarchar](20) '$.Code',
					[Name] [nvarchar](50) '$.Name',
					[ProfileURL] [nvarchar](100) '$.ProfileURL',
					[IsTerritory] [bit] '$.IsTerritory'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --Country
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'DateTypes'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --DateType
	DECLARE @DateTypes [nvarchar](MAX)
	SELECT @DateTypes = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\DateTypes.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[DateType]
	INSERT INTO [SanctionList].[DateType]
		SELECT *
			FROM OPENJSON(@DateTypes, '$')
				WITH
				(
					[DateTypeId] [int] '$.DateTypeId',
					[Name] [nvarchar](50) '$.Name',
					[RecordType] [nvarchar](10) '$.RecordType'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --DateType
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'Description1s'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --Description1
	DECLARE @Description1s [nvarchar](MAX)
	SELECT @Description1s = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\Description1s.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[Description1]
	INSERT INTO [SanctionList].[Description1]
		SELECT *
			FROM OPENJSON(@Description1s, '$')
				WITH
				(
					[Description1Id] [int] '$.Description1Id',
					[Name] [nvarchar](50) '$.Name',
					[RecordType] [nvarchar](10) '$.RecordType'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --Description1
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'Description2s'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --Description2
	DECLARE @Description2s [nvarchar](MAX)
	SELECT @Description2s = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\Description2s.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[Description2]
	INSERT INTO [SanctionList].[Description2]
		SELECT *
			FROM OPENJSON(@Description2s, '$')
				WITH
				(
					[Description2Id] [int] '$.Description2Id',
					[Description1Id] [int] '$.Description1Id',
					[Name] [nvarchar](50) '$.Name'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --Description2
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'Description3s'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --Description3
	DECLARE @Description3s [nvarchar](MAX)
	SELECT @Description3s = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\Description3s.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[Description3]
	INSERT INTO [SanctionList].[Description3]
		SELECT *
			FROM OPENJSON(@Description3s, '$')
				WITH
				(
					[Description3Id] [int] '$.Description3Id',
					[Description2Id] [int] '$.Description2Id',
					[Name] [nvarchar](50) '$.Name'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --Description3
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'NameTypes'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --NameType
	DECLARE @NameTypes [nvarchar](MAX)
	SELECT @NameTypes = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\NameTypes.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[NameType]
	INSERT INTO [SanctionList].[NameType]
		SELECT *
			FROM OPENJSON(@NameTypes, '$')
				WITH
				(
					[NameTypeId] [int] '$.NameTypeId',
					[Name] [nvarchar](50) '$.Name',
					[RecordType] [nvarchar](10) '$.RecordType'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --NameType
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'Occupations'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --Occupation
	DECLARE @Occupations [nvarchar](MAX)
	SELECT @Occupations = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\Occupations.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[Occupation]
	INSERT INTO [SanctionList].[Occupation]
		SELECT *
			FROM OPENJSON(@Occupations, '$')
				WITH
				(
					[OccupationId] [int] '$.OccupationId',
					[Name] [nvarchar](50) '$.Name'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --Occupation
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'Relationships'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --Relationship
	DECLARE @Relationships [nvarchar](MAX)
	SELECT @Relationships = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\Relationships.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[Relationship]
	INSERT INTO [SanctionList].[Relationship]
		SELECT *
			FROM OPENJSON(@Relationships, '$')
				WITH
				(
					[RelationshipId] [int] '$.RelationshipId',
					[Name] [nvarchar](50) '$.Name'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --Relationship
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'RoleTypes'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --RoleType
	DECLARE @RoleTypes [nvarchar](MAX)
	SELECT @RoleTypes = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\RoleTypes.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[RoleType]
	INSERT INTO [SanctionList].[RoleType]
		SELECT *
			FROM OPENJSON(@RoleTypes, '$')
				WITH
				(
					[RoleTypeId] [int] '$.RoleTypeId',
					[Name] [nvarchar](50) '$.Name'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --RoleType
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'SanctionsReferences'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --SanctionsReference
	DECLARE @SanctionsReferences [nvarchar](MAX)
	SELECT @SanctionsReferences = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\SanctionsReferences.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[SanctionsReference]
	INSERT INTO [SanctionList].[SanctionsReference]
		SELECT *
			FROM OPENJSON(@SanctionsReferences, '$')
				WITH
				(
					[SanctionsReferenceId] [int] '$.SanctionsReferenceId',
					[Description2Id] [int] '$.Description2Id',
					[Status] [nvarchar](10) '$.Status',
					[Name] [nvarchar](50) '$.Name'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --SanctionsReference
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

DECLARE @Persons [nvarchar](MAX)

SET @ElementName = N'Persons'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --Person
	SELECT @Persons = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\Persons.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[Person]
	INSERT INTO [SanctionList].[Person]
		SELECT *
			FROM OPENJSON(@Persons, '$')
				WITH
				(
					[PersonId] [int] '$.PersonId',
					[ActionDate] [date] '$.ActionDate',
					[Action] [nvarchar](10) '$.Action',
					[Gender] [nvarchar](10) '$.Gender',
					[Deceased] [nvarchar](10) '$.Deceased',
					[ActiveStatus] [nvarchar](10) '$.ActiveStatus'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --Person
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonProfileNotes'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonProfileNotes
	TRUNCATE TABLE [SanctionList].[PersonProfileNotes]
	DECLARE @SQL [nvarchar](MAX)
	DECLARE _ProfileNotes CURSOR FORWARD_ONLY READ_ONLY FOR
		SELECT
			'
				INSERT INTO [SanctionList].[PersonProfileNotes]
				SELECT
					' + CAST([PersonId] AS [nvarchar](11)) + ' AS [PersonId],
					[BulkColumn] AS [Notes]
					FROM OPENROWSET
					(
						BULK N''' + [ProfileNotesFilePath] + ''',
						SINGLE_CLOB
					) AS [File];
			' AS [SQL]
			FROM
			(
				SELECT
					[PersonId],
					NULLIF([ProfileNotesFilePath], '') AS [ProfileNotesFilePath]
					FROM OPENJSON(@Persons, '$')
						WITH
						(
							[PersonId] [int] '$.PersonId',
							[ProfileNotesFilePath] [nvarchar](MAX) '$.ProfileNotesFilePath'
						)
			) AS [ProfileNote]
			WHERE [ProfileNotesFilePath] IS NOT NULL
	OPEN _ProfileNotes
	FETCH NEXT FROM _ProfileNotes INTO @SQL
	SET @RowsAffected = 0
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @RowsAffected += 1
			EXECUTE(@SQL)
			FETCH NEXT FROM _ProfileNotes INTO @SQL
		END
	CLOSE _ProfileNotes
	DEALLOCATE _ProfileNotes
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonProfileNotes
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonAddresses'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonAddress
	DECLARE @PersonAddresses [nvarchar](MAX)
	SELECT @PersonAddresses = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\PersonAddresses.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[PersonAddress]
	INSERT INTO [SanctionList].[PersonAddress]
		SELECT *
			FROM OPENJSON(@PersonAddresses)
				WITH
				(
					[PersonId] [int] '$.PersonId',
					[CountryCode] [nvarchar](20) '$.CountryCode',
					[City] [nvarchar](50) '$.City',
					[Line] [nvarchar](100) '$.Line',
					[URL] [nvarchar](100) '$.URL'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonAddress
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonBirthPlaces'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonBirthPlace
	DECLARE @PersonBirthPlaces [nvarchar](MAX)
	SELECT @PersonBirthPlaces = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\PersonBirthPlaces.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[PersonBirthPlace]
	INSERT INTO [SanctionList].[PersonBirthPlace]
		SELECT *
			FROM OPENJSON(@PersonBirthPlaces)
				WITH
				(
					[PersonId] [int] '$.PersonId',
					[Name] [nvarchar](100) '$.Name'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonBirthPlace
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonCountries'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonCountry
	DECLARE @PersonCountries [nvarchar](MAX)
	SELECT @PersonCountries = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\PersonCountries.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[PersonCountry]
	INSERT INTO [SanctionList].[PersonCountry]
		SELECT *
			FROM OPENJSON(@PersonCountries)
				WITH
				(
					[PersonId] [int] '$.PersonId',
					[CountryType] [nvarchar](100) '$.CountryType',
					[Code] [nvarchar](10) '$.Code'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonCountry
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonDates'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonDate
	DECLARE @PersonDates [nvarchar](MAX)
	SELECT @PersonDates = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\PersonDates.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[PersonDate]
	INSERT INTO [SanctionList].[PersonDate]
		SELECT
			[PersonId],
			[DateType],
			[Year],
			[Month],
			[Day],
			[Notes]
			FROM
			(
				SELECT
					[PersonId],
					[DateType],
					[Year],
					CASE
						WHEN [Month] = 'Jan' THEN 1
						WHEN [Month] = 'Feb' THEN 2
						WHEN [Month] = 'Mar' THEN 3
						WHEN [Month] = 'Apr' THEN 4
						WHEN [Month] = 'May' THEN 5
						WHEN [Month] = 'Jun' THEN 6
						WHEN [Month] = 'Jul' THEN 7
						WHEN [Month] = 'Aug' THEN 8
						WHEN [Month] = 'Sep' THEN 9
						WHEN [Month] = 'Oct' THEN 10
						WHEN [Month] = 'Nov' THEN 11
						WHEN [Month] = 'Dec' THEN 12
						ELSE NULL
					END AS [Month],
					[Day],
					[Notes]
					FROM OPENJSON(@PersonDates)
						WITH
						(
							[PersonId] [int] '$.PersonId',
							[DateType] [nvarchar](50) '$.DateType',
							[Year] [int] '$.Year',
							[Month] [nvarchar](10) '$.Month',
							[Day] [int] '$.Day',
							[Notes] [nvarchar](300) '$.Notes'
						)
			) AS [PersonDate]
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonDate
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonNames'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonName
	DECLARE @PersonNames [nvarchar](MAX)
	SELECT @PersonNames = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\PersonNames.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[PersonName]
	INSERT INTO [SanctionList].[PersonName]
		SELECT *
			FROM OPENJSON(@PersonNames)
				WITH
				(
					[PersonId] [int] '$.PersonId',
					[NameType] [nvarchar](50) '$.NameType',
					[TitleHonorific] [nvarchar](100) '$.TitleHonorific',
					[FirstName] [nvarchar](100) '$.FirstName',
					[MiddleName] [nvarchar](100) '$.MiddleName',
					[Surname] [nvarchar](100) '$.Surname',
					[Suffix] [nvarchar](100) '$.Suffix',
					[MaidenName] [nvarchar](100) '$.MaidenName',
					[OriginalScriptName] [nvarchar](100) '$.OriginalScriptName',
					[SingleStringName] [nvarchar](100) '$.SingleStringName'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonName
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonDescriptions'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonDescription
	DECLARE @PersonDescriptions [nvarchar](MAX)
	SELECT @PersonDescriptions = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\PersonDescriptions.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[PersonDescription]
	INSERT INTO [SanctionList].[PersonDescription]
		SELECT *
			FROM OPENJSON(@PersonDescriptions)
				WITH
				(
					[PersonId] [int] '$.PersonId',
					[Description1Id] [int] '$.Description1Id',
					[Description2Id] [int] '$.Description2Id',
					[Description3Id] [int] '$.Description3Id'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonDescription
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonImages'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonImage
	DECLARE @PersonImages [nvarchar](MAX)
	SELECT @PersonImages = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\PersonImages.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[PersonImage]
	INSERT INTO [SanctionList].[PersonImage]
		SELECT *
			FROM OPENJSON(@PersonImages)
				WITH
				(
					[PersonId] [int] '$.PersonId',
					[URL] [nvarchar](250) '$.URL'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonImage
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonSanctionsReferences'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonSanctionsReference
	DECLARE @PersonSanctionsReferences [nvarchar](MAX)
	SELECT @PersonSanctionsReferences = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\PersonSanctionsReferences.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[PersonSanctionsReference]
	INSERT INTO [SanctionList].[PersonSanctionsReference]
		SELECT *
			FROM
			(
				SELECT
					[PersonId],
					[SanctionsReferenceId],
					[SinceYear],
					CASE
						WHEN [SinceMonth] = 'Jan' THEN 1
						WHEN [SinceMonth] = 'Feb' THEN 2
						WHEN [SinceMonth] = 'Mar' THEN 3
						WHEN [SinceMonth] = 'Apr' THEN 4
						WHEN [SinceMonth] = 'May' THEN 5
						WHEN [SinceMonth] = 'Jun' THEN 6
						WHEN [SinceMonth] = 'Jul' THEN 7
						WHEN [SinceMonth] = 'Aug' THEN 8
						WHEN [SinceMonth] = 'Sep' THEN 9
						WHEN [SinceMonth] = 'Oct' THEN 10
						WHEN [SinceMonth] = 'Nov' THEN 11
						WHEN [SinceMonth] = 'Dec' THEN 12
						ELSE NULL
					END AS [SinceMonth],
					[SinceDay],
					[ToYear],
					CASE
						WHEN [ToMonth] = 'Jan' THEN 1
						WHEN [ToMonth] = 'Feb' THEN 2
						WHEN [ToMonth] = 'Mar' THEN 3
						WHEN [ToMonth] = 'Apr' THEN 4
						WHEN [ToMonth] = 'May' THEN 5
						WHEN [ToMonth] = 'Jun' THEN 6
						WHEN [ToMonth] = 'Jul' THEN 7
						WHEN [ToMonth] = 'Aug' THEN 8
						WHEN [ToMonth] = 'Sep' THEN 9
						WHEN [ToMonth] = 'Oct' THEN 10
						WHEN [ToMonth] = 'Nov' THEN 11
						WHEN [ToMonth] = 'Dec' THEN 12
						ELSE NULL
					END AS [ToMonth],
					[ToDay]
					FROM OPENJSON(@PersonSanctionsReferences)
						WITH
						(
							[PersonId] [int] '$.PersonId',
							[SanctionsReferenceId] [int] '$.SanctionsReferenceId',
							[SinceYear] [int] '$.SinceYear',
							[SinceMonth] [nchar](3) '$.SinceMonth',
							[SinceDay] [int] '$.SinceDay',
							[ToYear] [int] '$.ToYear',
							[ToMonth] [nchar](3) '$.ToMonth',
							[ToDay] [int] '$.ToDay'
						)
			) AS [PersonSanctionsReference]
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonSanctionsReference
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @ElementName = N'PersonSources'
SET @ElementBeginTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementBeginTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s %s Begin Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT
BEGIN --PersonSource
	DECLARE @PersonSources [nvarchar](MAX)
	SELECT @PersonSources = [BulkColumn]
		FROM OPENROWSET
		(
			BULK N'D:\SanctionList\Extract\PersonSources.json',
			SINGLE_NCLOB
		) AS [File];
	TRUNCATE TABLE [SanctionList].[PersonSource]
	INSERT INTO [SanctionList].[PersonSource]
		SELECT *
			FROM OPENJSON(@PersonSources)
				WITH
				(
					[PersonId] [int] '$.PersonId',
					[Name] [nvarchar](300) '$.Name'
				)
	SET @RowsAffected = @@ROWCOUNT
	UPDATE [SanctionList].[FileElement] SET [ImportedRecordCount] = @RowsAffected WHERE [Name] = @ElementName
END --PersonSource
SET @ElementEndTime = SYSUTCDATETIME()
SET @TimestampText = FORMAT(@ElementEndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
SET @TotlaMinutes = FORMAT((CAST(DATEDIFF([MILLISECOND], @ElementBeginTime, @ElementEndTime) AS [decimal](18, 10)) / 60000.0), '0.##########')
RAISERROR(N'%s      %s Total Minutes: %s', 10, 1, @TimestampText, @ElementName, @TotlaMinutes) WITH NOWAIT
RAISERROR(N'%s      %s Rows Affected: %i', 10, 1, @TimestampText, @ElementName, @RowsAffected) WITH NOWAIT
RAISERROR(N'%s %s End Import', 10, 1, @TimestampText, @ElementName) WITH NOWAIT

SET @EndTime = DATEADD([second], 433, SYSUTCDATETIME())
SET @TimestampText = FORMAT(@EndTime, 'yyyy-MM-dd HH:mm:ss.fffffff')
RAISERROR(N'%s End Import', 10, 1, @TimestampText) WITH NOWAIT
RAISERROR(N'%s Total Minutes: %s', 10, 1, @TimestampText, @TotlaMinutes) WITH NOWAIT
