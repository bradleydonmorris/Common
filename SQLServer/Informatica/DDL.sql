USE [Reports_Library]
GO
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] WHERE [name] = N'IICS')
	EXECUTE(N'CREATE SCHEMA [IICS]')
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] INNER JOIN [sys].[tables] ON [schemas].[schema_id] = [tables].[schema_id] WHERE [schemas].[name] = 'IICS' AND [tables].[name] = N'JSONFile')
	CREATE TABLE [IICS].[JSONFile]
	(
		[JSONFileId] [int] IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](400) NOT NULL,
		[Content] [nvarchar](max) NOT NULL,
		[LastWriteTime] [datetime2](7) NOT NULL
			CONSTRAINT [DF_JSONFile_LastWriteTime]  DEFAULT (SYSUTCDATETIME()),
		[LastImportTime] [datetime2](7) NULL,
		CONSTRAINT [PK_JSONFile] PRIMARY KEY CLUSTERED  ([JSONFileId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] INNER JOIN [sys].[tables] ON [schemas].[schema_id] = [tables].[schema_id] WHERE [schemas].[name] = 'IICS' AND [tables].[name] = N'Mapping')
	CREATE TABLE [IICS].[Mapping]
	(
		[MappingId] [int] IDENTITY(1,1) NOT NULL,
		[IICSObjectId] [nvarchar](400) NULL,
		[IICSObjectType] [nvarchar](400) NULL,
		[BundleVersion] [nvarchar](400) NULL,
		[CreateTime] [datetime2](7) NULL,
		[CreatedBy] [nvarchar](400) NULL,
		[DeployTime] [bigint] NULL,
		[DeployedMappingPreviewFileRecordId] [nvarchar](400) NULL,
		[DeployedTemplateId] [nvarchar](400) NULL,
		[Description] [nvarchar](400) NULL,
		[DocumentType] [nvarchar](400) NULL,
		[FixedConnection] [bit] NULL,
		[FixedConnectionDeployed] [bit] NULL,
		[HasParameters] [bit] NULL,
		[HasParametersDeployed] [bit] NULL,
		[MappingPreviewFileRecordId] [nvarchar](400) NULL,
		[Name] [nvarchar](400) NULL,
		[OrganizationId] [nvarchar](400) NULL,
		[PrunedTemplateId] [nvarchar](400) NULL,
		[Tasks] [int] NULL,
		[TemplateId] [nvarchar](400) NULL,
		[TestTaskId] [nvarchar](400) NULL,
		[UpdateTime] [datetime2](7) NULL,
		[UpdatedBy] [nvarchar](400) NULL,
		[Valid] [bit] NULL,
		CONSTRAINT [PK_Mapping] PRIMARY KEY CLUSTERED ([MappingId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] INNER JOIN [sys].[tables] ON [schemas].[schema_id] = [tables].[schema_id] WHERE [schemas].[name] = 'IICS' AND [tables].[name] = N'MappingParameter')
	CREATE TABLE [IICS].[MappingParameter]
	(
		[MappingParameterId] [int] IDENTITY(1,1) NOT NULL,
		[IICSObjectId] [nvarchar](400) NULL,
		[Name] [nvarchar](400) NULL,
		[IICSObjectType] [nvarchar](400) NULL,
		[IICSParameterType] [nvarchar](400) NULL,
		[Id] [nvarchar](400) NULL,
		[BulkApiDBTarget] [nvarchar](400) NULL,
		[CurrentlyProcessedFileName] [nvarchar](400) NULL,
		[CustomQuery] [nvarchar](400) NULL,
		[Description] [nvarchar](400) NULL,
		[DynamicFileName] [nvarchar](400) NULL,
		[ExcludeDynamicFileNameField] [bit] NULL,
		[FrsAsset] [bit] NULL,
		[HandleSpecialChars] [bit] NULL,
		[IsFileList] [bit] NULL,
		[IsRESTModernSource] [bit] NULL,
		[Label] [nvarchar](400) NULL,
		[NaturalOrder] [bit] NULL,
		[NewFlatFile] [bit] NULL,
		[NewObject] [bit] NULL,
		[NewObjectName] [nvarchar](400) NULL,
		[ObjectLabel] [nvarchar](400) NULL,
		[ObjectName] [nvarchar](400) NULL,
		[OperationType] [nvarchar](400) NULL,
		[RetainFieldMetadata] [bit] NULL,
		[RuntimeParameterData] [nvarchar](400) NULL,
		[ShowBusinessNames] [bit] NULL,
		[SourceConnectionId] [nvarchar](400) NULL,
		[SourceObject] [nvarchar](400) NULL,
		[TargetConnectionId] [nvarchar](400) NULL,
		[TargetObject] [nvarchar](400) NULL,
		[TargetObjectLabel] [nvarchar](400) NULL,
		[TruncateTarget] [bit] NULL,
		[Type] [nvarchar](400) NULL,
		[UseExactSrcNames] [bit] NULL,
		CONSTRAINT [PK_MappingParameter] PRIMARY KEY CLUSTERED ([MappingParameterId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] INNER JOIN [sys].[tables] ON [schemas].[schema_id] = [tables].[schema_id] WHERE [schemas].[name] = 'IICS' AND [tables].[name] = N'MappingReference')
	CREATE TABLE [IICS].[MappingReference]
	(
		[MappingReferenceId] [int] IDENTITY(1,1) NOT NULL,
		[IICSObjectId] [nvarchar](400) NULL,
		[IICSObjectType] [nvarchar](400) NULL,
		[ReferencedIICSObjectId] [nvarchar](400) NULL,
		[ReferencedIICSObjectType] [nvarchar](400) NULL,
		CONSTRAINT [PK_MappingReference] PRIMARY KEY CLUSTERED ([MappingReferenceId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] INNER JOIN [sys].[tables] ON [schemas].[schema_id] = [tables].[schema_id] WHERE [schemas].[name] = 'IICS' AND [tables].[name] = N'MappingTask')
	CREATE TABLE [IICS].[MappingTask]
	(
		[MappingTaskId] [int] IDENTITY(1,1) NOT NULL,
		[IICSObjectId] [nvarchar](400) NULL,
		[IICSObjectType] [nvarchar](400) NULL,
		[AgentId] [nvarchar](400) NULL,
		[AutoTunedApplied] [bit] NULL,
		[AutoTunedAppliedType] [nvarchar](400) NULL,
		[CreateTime] [datetime2](7) NULL,
		[CreatedBy] [nvarchar](400) NULL,
		[Description] [nvarchar](400) NULL,
		[EnableCrossSchemaPushdown] [bit] NULL,
		[EnableParallelRun] [bit] NULL,
		[ErrorTaskEmail] [nvarchar](400) NULL,
		[InOutParameters] [nvarchar](400) NULL,
		[LastRunTime] [nvarchar](400) NULL,
		[MappingId] [nvarchar](400) NULL,
		[MaxLogs] [int] NULL,
		[Name] [nvarchar](400) NULL,
		[OrganizationId] [nvarchar](400) NULL,
		[ParamFileType] [nvarchar](400) NULL,
		[ParameterFileEncoding] [nvarchar](400) NULL,
		[PostProcessingCmd] [nvarchar](400) NULL,
		[PreProcessingCmd] [nvarchar](400) NULL,
		[RuntimeEnvironmentId] [nvarchar](400) NULL,
		[ScheduleId] [nvarchar](400) NULL,
		[SchemaMode] [nvarchar](400) NULL,
		[ShortDescription] [nvarchar](400) NULL,
		[SuccessTaskEmail] [nvarchar](400) NULL,
		[UpdateTime] [datetime2](7) NULL,
		[UpdatedBy] [nvarchar](400) NULL,
		[Verbose] [bit] NULL,
		[WarningTaskEmail] [nvarchar](400) NULL,
		CONSTRAINT [PK_MappingTask] PRIMARY KEY CLUSTERED ([MappingTaskId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] INNER JOIN [sys].[tables] ON [schemas].[schema_id] = [tables].[schema_id] WHERE [schemas].[name] = 'IICS' AND [tables].[name] = N'MappingTaskParameter')
	CREATE TABLE [IICS].[MappingTaskParameter]
	(
		[MappingTaskParameterId] [int] IDENTITY(1,1) NOT NULL,
		[IICSObjectId] [nvarchar](400) NULL,
		[Name] [nvarchar](400) NULL,
		[IICSObjectType] [nvarchar](400) NULL,
		[IICSParameterType] [nvarchar](400) NULL,
		[Id] [nvarchar](400) NULL,
		[BulkApiDBTarget] [nvarchar](400) NULL,
		[CurrentlyProcessedFileName] [nvarchar](400) NULL,
		[CustomQuery] [nvarchar](400) NULL,
		[Description] [nvarchar](400) NULL,
		[DynamicFileName] [nvarchar](400) NULL,
		[ExcludeDynamicFileNameField] [nvarchar](400) NULL,
		[ExtendedObject] [nvarchar](400) NULL,
		[FetchMode] [nvarchar](400) NULL,
		[FrsAsset] [nvarchar](400) NULL,
		[HandleSpecialChars] [bit] NULL,
		[IsFileList] [nvarchar](400) NULL,
		[IsRESTModernSource] [bit] NULL,
		[Label] [nvarchar](400) NULL,
		[NaturalOrder] [nvarchar](400) NULL,
		[NewFlatFile] [nvarchar](400) NULL,
		[NewObject] [nvarchar](400) NULL,
		[NewObjectName] [nvarchar](400) NULL,
		[ObjectLabel] [nvarchar](400) NULL,
		[ObjectName] [nvarchar](400) NULL,
		[OperationType] [nvarchar](400) NULL,
		[OverriddenFields] [nvarchar](400) NULL,
		[RetainFieldMetadata] [nvarchar](400) NULL,
		[RuntimeAttrs] [nvarchar](400) NULL,
		[RuntimeParameterData] [nvarchar](400) NULL,
		[ShowBusinessNames] [nvarchar](400) NULL,
		[SourceConnectionId] [nvarchar](400) NULL,
		[SourceObject] [nvarchar](400) NULL,
		[TargetConnectionId] [nvarchar](400) NULL,
		[TargetObject] [nvarchar](400) NULL,
		[TargetObjectLabel] [nvarchar](400) NULL,
		[TargetRefsV2] [nvarchar](400) NULL,
		[TargetSchemaMode] [nvarchar](400) NULL,
		[TargetUpdateColumns] [nvarchar](400) NULL,
		[Text] [nvarchar](400) NULL,
		[TruncateTarget] [bit] NULL,
		[Type] [nvarchar](400) NULL,
		[UseExactSrcNames] [bit] NULL,
		CONSTRAINT [PK_MappingTaskParameter] PRIMARY KEY CLUSTERED ([MappingTaskParameterId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] INNER JOIN [sys].[tables] ON [schemas].[schema_id] = [tables].[schema_id] WHERE [schemas].[name] = 'IICS' AND [tables].[name] = N'Schedule')
	CREATE TABLE [IICS].[Schedule]
	(
		[ScheduleId] [int] IDENTITY(1,1) NOT NULL,
		[IICSObjectId] [nvarchar](400) NULL,
		[IICSObjectType] [nvarchar](400) NULL,
		[CreateTime] [datetime2](7) NULL,
		[CreatedBy] [nvarchar](400) NULL,
		[DayOfMonth] [int] NULL,
		[Description] [nvarchar](400) NULL,
		[EndTime] [datetime2](7) NULL,
		[EndTimeUTC] [datetime2](7) NULL,
		[Frequency] [int] NULL,
		[Interval] [nvarchar](400) NULL,
		[Name] [nvarchar](400) NULL,
		[OrganizationId] [nvarchar](400) NULL,
		[RangeEndTime] [datetime2](7) NULL,
		[RangeEndTimeUTC] [datetime2](7) NULL,
		[RangeStartTime] [datetime2](7) NULL,
		[RangeStartTimeUTC] [datetime2](7) NULL,
		[StartTime] [datetime2](7) NULL,
		[StartTimeUTC] [datetime2](7) NULL,
		[TimeZoneId] [nvarchar](400) NULL,
		[UpdateTime] [datetime2](7) NULL,
		[UpdatedBy] [nvarchar](400) NULL,
		[WeekDay] [bit] NULL,
		[Sunday] [bit] NULL,
		[Monday] [bit] NULL,
		[Tuesday] [bit] NULL,
		[Wednesday] [bit] NULL,
		[Thursday] [bit] NULL,
		[Friday] [bit] NULL,
		[Saturday] [bit] NULL,
		CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED ([ScheduleId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] INNER JOIN [sys].[tables] ON [schemas].[schema_id] = [tables].[schema_id] WHERE [schemas].[name] = 'IICS' AND [tables].[name] = N'Workflow')
	CREATE TABLE [IICS].[Workflow]
	(
		[WorkflowId] [int] IDENTITY(1,1) NOT NULL,
		[IICSObjectId] [nvarchar](400) NULL,
		[IICSObjectType] [nvarchar](400) NULL,
		[CreateTime] [datetime2](7) NULL,
		[CreatedBy] [nvarchar](400) NULL,
		[Description] [nvarchar](400) NULL,
		[ErrorTaskEmail] [nvarchar](400) NULL,
		[MaxLogs] [int] NULL,
		[Name] [nvarchar](400) NULL,
		[OrganizationId] [nvarchar](400) NULL,
		[ScheduleId] [nvarchar](400) NULL,
		[SuccessTaskEmail] [nvarchar](400) NULL,
		[UpdateTime] [datetime2](7) NULL,
		[UpdatedBy] [nvarchar](400) NULL,
		[WarningTaskEmail] [nvarchar](400) NULL,
		CONSTRAINT [PK_Workflow] PRIMARY KEY CLUSTERED ([WorkflowId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT 1 FROM [sys].[schemas] INNER JOIN [sys].[tables] ON [schemas].[schema_id] = [tables].[schema_id] WHERE [schemas].[name] = 'IICS' AND [tables].[name] = N'WorkflowTask')
	CREATE TABLE [IICS].[WorkflowTask]
	(
		[WorkflowTaskId] [int] IDENTITY(1,1) NOT NULL,
		[IICSObjectId] [nvarchar](400) NULL,
		[Name] [nvarchar](400) NULL,
		[IICSObjectType] [nvarchar](400) NULL,
		[IICSTaskType] [nvarchar](400) NULL,
		[StopOnError] [nvarchar](400) NULL,
		[StopOnWarning] [nvarchar](400) NULL,
		[TaskId] [nvarchar](400) NULL,
		[Type] [nvarchar](400) NULL,
		CONSTRAINT [PK_WorkflowTask] PRIMARY KEY CLUSTERED ([WorkflowTaskId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
GO
CREATE OR ALTER PROCEDURE [IICS].[WriteJSONFile]
(
	@Name [nvarchar](400),
	@Content [nvarchar](MAX)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @JSONFileId [int]
	SELECT @JSONFileId = [JSONFile].[JSONFileId]
		FROM [IICS].[JSONFile]
		WHERE [JSONFile].[Name] = @Name
	IF @JSONFileId IS NOT NULL
		UPDATE [IICS].[JSONFile]
			SET
				[Content] = @Content,
				[LastWriteTime] = SYSUTCDATETIME()
			WHERE [JSONFileId] = @JSONFileId
	ELSE
		INSERT INTO [IICS].[JSONFile]([Name], [Content])
			VALUES (@Name, @Content)
END
GO
CREATE OR ALTER PROCEDURE [IICS].[ProcessConnections]
AS
BEGIN
	SET NOCOUNT ON
	MERGE [IICS].[Connection] AS [Target]
		USING
		(
			SELECT
				ISNULL([Connection].[IICSObjectId], [ConnectionEx].[IICSObjectId]) AS [IICSObjectId],
				ISNULL([Connection].[IICSObjectType], [ConnectionEx].[IICSObjectType]) AS [IICSObjectType],
				ISNULL([Connection].[AdjustedJdbcHostName], [ConnectionEx].[AdjustedJdbcHostName]) AS [AdjustedJdbcHostName],
				ISNULL([Connection].[AgentId], [ConnectionEx].[AgentId]) AS [AgentId],
				ISNULL([Connection].[AuthenticationType], [ConnectionEx].[AuthenticationType]) AS [AuthenticationType],
				ISNULL([Connection].[Codepage], [ConnectionEx].[Codepage]) AS [Codepage],
				ISNULL([Connection].[CreateTime], [ConnectionEx].[CreateTime]) AS [CreateTime],
				ISNULL([Connection].[CreatedBy], [ConnectionEx].[CreatedBy]) AS [CreatedBy],
				ISNULL([Connection].[Database], [ConnectionEx].[Database]) AS [Database],
				ISNULL([Connection].[DateFormat], [ConnectionEx].[DateFormat]) AS [DateFormat],
				ISNULL([Connection].[Description], [ConnectionEx].[Description]) AS [Description],
				ISNULL([Connection].[FederatedId], [ConnectionEx].[FederatedId]) AS [FederatedId],
				ISNULL([Connection].[Host], [ConnectionEx].[Host]) AS [Host],
				ISNULL([Connection].[InstanceDisplayName], [ConnectionEx].[InstanceDisplayName]) AS [InstanceDisplayName],
				ISNULL([Connection].[InstanceName], [ConnectionEx].[InstanceName]) AS [InstanceName],
				ISNULL([Connection].[Internal], [ConnectionEx].[Internal]) AS [Internal],
				ISNULL([Connection].[MajorUpdateTime], [ConnectionEx].[MajorUpdateTime]) AS [MajorUpdateTime],
				ISNULL([Connection].[Name], [ConnectionEx].[Name]) AS [Name],
				ISNULL([Connection].[OrganizationId], [ConnectionEx].[OrganizationId]) AS [OrganizationId],
				ISNULL([Connection].[Port], [ConnectionEx].[Port]) AS [Port],
				ISNULL([Connection].[RemoteDirectory], [ConnectionEx].[RemoteDirectory]) AS [RemoteDirectory],
				ISNULL([Connection].[RetryNetworkError], [ConnectionEx].[RetryNetworkError]) AS [RetryNetworkError],
				ISNULL([Connection].[RuntimeEnvironmentId], [ConnectionEx].[RuntimeEnvironmentId]) AS [RuntimeEnvironmentId],
				ISNULL([Connection].[Schema], [ConnectionEx].[Schema]) AS [Schema],
				ISNULL([Connection].[SecurityToken], [ConnectionEx].[SecurityToken]) AS [SecurityToken],
				ISNULL([Connection].[ServiceUrl], [ConnectionEx].[ServiceUrl]) AS [ServiceUrl],
				ISNULL([Connection].[ShortDescription], [ConnectionEx].[ShortDescription]) AS [ShortDescription],
				ISNULL([Connection].[SupportsCCIMultiGroup], [ConnectionEx].[SupportsCCIMultiGroup]) AS [SupportsCCIMultiGroup],
				ISNULL([Connection].[Timeout], [ConnectionEx].[Timeout]) AS [Timeout],
				ISNULL([Connection].[Type], [ConnectionEx].[Type]) AS [Type],
				ISNULL([Connection].[UpdateTime], [ConnectionEx].[UpdateTime]) AS [UpdateTime],
				ISNULL([Connection].[UpdatedBy], [ConnectionEx].[UpdatedBy]) AS [UpdatedBy],
				ISNULL([Connection].[Username], [ConnectionEx].[Username]) AS [Username],
				[ConnectionParameters].[ConnPraram_AdditionalConnectionProperties],
				[ConnectionParameters].[ConnPraram_AgentGroupId],
				[ConnectionParameters].[ConnPraram_AgentId],
				[ConnectionParameters].[ConnPraram_AuthenticationType],
				[ConnectionParameters].[ConnPraram_Authentication_Type],
				[ConnectionParameters].[ConnPraram_CCMConnPresentation],
				[ConnectionParameters].[ConnPraram_ClientAuthentication],
				[ConnectionParameters].[ConnPraram_ClientId],
				[ConnectionParameters].[ConnPraram_ClientSecret],
				[ConnectionParameters].[ConnPraram_CodePage],
				[ConnectionParameters].[ConnPraram_ConnectionType],
				[ConnectionParameters].[ConnPraram_ConnectionTypes],
				[ConnectionParameters].[ConnPraram_CryptoProtocolVersion],
				[ConnectionParameters].[ConnPraram_Database],
				[ConnectionParameters].[ConnPraram_DaysCalculation],
				[ConnectionParameters].[ConnPraram_EncryptionMethod],
				[ConnectionParameters].[ConnPraram_FilePattern],
				[ConnectionParameters].[ConnPraram_Filename],
				[ConnectionParameters].[ConnPraram_FolderURI],
				[ConnectionParameters].[ConnPraram_HostName],
				[ConnectionParameters].[ConnPraram_HostNameInCertificate],
				[ConnectionParameters].[ConnPraram_KeyStore],
				[ConnectionParameters].[ConnPraram_Mode],
				[ConnectionParameters].[ConnPraram_OAuthRefreshURL],
				[ConnectionParameters].[ConnPraram_ODBC_SUBTYPE],
				[ConnectionParameters].[ConnPraram_OdbcDriverManager],
				[ConnectionParameters].[ConnPraram_OrganizationId],
				[ConnectionParameters].[ConnPraram_PageSize],
				[ConnectionParameters].[ConnPraram_PassKey1],
				[ConnectionParameters].[ConnPraram_Password],
				[ConnectionParameters].[ConnPraram_Port],
				[ConnectionParameters].[ConnPraram_ProxyConfiguration],
				[ConnectionParameters].[ConnPraram_ProxyType],
				[ConnectionParameters].[ConnPraram_RefreshToken],
				[ConnectionParameters].[ConnPraram_Schema],
				[ConnectionParameters].[ConnPraram_SelectFile],
				[ConnectionParameters].[ConnPraram_SourceFileDirectory],
				[ConnectionParameters].[ConnPraram_SSLv3],
				[ConnectionParameters].[ConnPraram_SwaggerFilePath],
				[ConnectionParameters].[ConnPraram_TargetFileDirectory],
				[ConnectionParameters].[ConnPraram_TLSv1],
				[ConnectionParameters].[ConnPraram_TLSv1_1],
				[ConnectionParameters].[ConnPraram_TLSv1_2],
				[ConnectionParameters].[ConnPraram_TreatFirstRowAsHeader],
				[ConnectionParameters].[ConnPraram_TrustStore],
				[ConnectionParameters].[ConnPraram_Use_Proxy],
				[ConnectionParameters].[ConnPraram_UserName],
				[ConnectionParameters].[ConnPraram_ValidateServerCertificate]
				FROM [Reports_Library].[IICS].[JSONFile]
					CROSS APPLY OPENJSON([JSONFile].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[AdjustedJdbcHostName] [nvarchar](400) N'$."adjustedJdbcHostName"',
							[AgentId] [nvarchar](400) N'$."agentId"',
							[AuthenticationType] [nvarchar](400) N'$."authenticationType"',
							[Codepage] [nvarchar](400) N'$."codepage"',
							[CreateTime] [datetime2](7) N'$."createTime"',
							[CreatedBy] [nvarchar](400) N'$."createdBy"',
							[Database] [nvarchar](400) N'$."database"',
							[DateFormat] [nvarchar](400) N'$."dateFormat"',
							[Description] [nvarchar](400) N'$."description"',
							[FederatedId] [nvarchar](400) N'$."federatedId"',
							[Host] [nvarchar](400) N'$."host"',
							[InstanceDisplayName] [nvarchar](400) N'$."instanceDisplayName"',
							[InstanceName] [nvarchar](400) N'$."instanceName"',
							[Internal] [bit] N'$."internal"',
							[MajorUpdateTime] [nvarchar](400) N'$."majorUpdateTime"',
							[Name] [nvarchar](400) N'$."name"',
							[OrganizationId] [nvarchar](400) N'$."orgId"',
							[Password] [nvarchar](400) N'$."password"',
							[Port] [int] N'$."port"',
							[RemoteDirectory] [nvarchar](400) N'$."remoteDirectory"',
							[RetryNetworkError] [nvarchar](400) N'$."retryNetworkError"',
							[RuntimeEnvironmentId] [nvarchar](400) N'$."runtimeEnvironmentId"',
							[Schema] [nvarchar](400) N'$."schema"',
							[SecurityToken] [nvarchar](400) N'$."securityToken"',
							[ServiceUrl] [nvarchar](400) N'$."serviceUrl"',
							[ShortDescription] [nvarchar](400) N'$."shortDescription"',
							[SupportsCCIMultiGroup] [nvarchar](400) N'$."supportsCCIMultiGroup"',
							[Timeout] [nvarchar](400) N'$."timeout"',
							[Type] [nvarchar](400) N'$."type"',
							[UpdateTime] [datetime2](7) N'$."updateTime"',
							[UpdatedBy] [nvarchar](400) N'$."updatedBy"',
							[Username] [nvarchar](400) N'$."username"'
						) AS [Connection]
					LEFT OUTER JOIN [Reports_Library].[IICS].[JSONFile] AS [JSONFile_Connection]
						ON CONCAT(N'Connections\', [Connection].[IICSObjectId], '.json') = [JSONFile_Connection].[Name]
					OUTER APPLY OPENJSON([JSONFile_Connection].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[AdjustedJdbcHostName] [nvarchar](400) N'$."adjustedJdbcHostName"',
							[AgentId] [nvarchar](400) N'$."agentId"',
							[AuthenticationType] [nvarchar](400) N'$."authenticationType"',
							[Codepage] [nvarchar](400) N'$."codepage"',
							[CreateTime] [datetime2](7) N'$."createTime"',
							[CreatedBy] [nvarchar](400) N'$."createdBy"',
							[Database] [nvarchar](400) N'$."database"',
							[DateFormat] [nvarchar](400) N'$."dateFormat"',
							[Description] [nvarchar](400) N'$."description"',
							[FederatedId] [nvarchar](400) N'$."federatedId"',
							[Host] [nvarchar](400) N'$."host"',
							[InstanceDisplayName] [nvarchar](400) N'$."instanceDisplayName"',
							[InstanceName] [nvarchar](400) N'$."instanceName"',
							[Internal] [bit] N'$."internal"',
							[MajorUpdateTime] [nvarchar](400) N'$."majorUpdateTime"',
							[Name] [nvarchar](400) N'$."name"',
							[OrganizationId] [nvarchar](400) N'$."orgId"',
							[Password] [nvarchar](400) N'$."password"',
							[Port] [int] N'$."port"',
							[RemoteDirectory] [nvarchar](400) N'$."remoteDirectory"',
							[RetryNetworkError] [nvarchar](400) N'$."retryNetworkError"',
							[RuntimeEnvironmentId] [nvarchar](400) N'$."runtimeEnvironmentId"',
							[Schema] [nvarchar](400) N'$."schema"',
							[SecurityToken] [nvarchar](400) N'$."securityToken"',
							[ServiceUrl] [nvarchar](400) N'$."serviceUrl"',
							[ShortDescription] [nvarchar](400) N'$."shortDescription"',
							[SupportsCCIMultiGroup] [nvarchar](400) N'$."supportsCCIMultiGroup"',
							[Timeout] [nvarchar](400) N'$."timeout"',
							[Type] [nvarchar](400) N'$."type"',
							[UpdateTime] [datetime2](7) N'$."updateTime"',
							[UpdatedBy] [nvarchar](400) N'$."updatedBy"',
							[Username] [nvarchar](400) N'$."username"'
						) AS [ConnectionEx]
					OUTER APPLY OPENJSON([JSONFile_Connection].[Content], N'$."connParams"')
						WITH
						(
							[ConnPraram_AdditionalConnectionProperties] [nvarchar](400) N'$."additionalConnectionProperties"',
							[ConnPraram_AgentGroupId] [nvarchar](400) N'$."agentGroupId"',
							[ConnPraram_AgentId] [nvarchar](400) N'$."agentId"',
							[ConnPraram_AuthenticationType] [nvarchar](400) N'$."Authentication Type"',
							[ConnPraram_Authentication_Type] [nvarchar](400) N'$."AUTHENTICATION_TYPE"',
							[ConnPraram_CCMConnPresentation] [nvarchar](400) N'$."CCM_CONN_PRESENTATION"',
							[ConnPraram_ClientAuthentication] [nvarchar](400) N'$."Client Authentication"',
							[ConnPraram_ClientId] [nvarchar](400) N'$."Client Id"',
							[ConnPraram_ClientSecret] [nvarchar](400) N'$."Client Secret"',
							[ConnPraram_CodePage] [nvarchar](400) N'$."Code Page"',
							[ConnPraram_ConnectionType] [nvarchar](400) N'$."Connection Type"',
							[ConnPraram_ConnectionTypes] [nvarchar](400) N'$."connectionTypes"',
							[ConnPraram_CryptoProtocolVersion] [nvarchar](400) N'$."CryptoProtocolVersion"',
							[ConnPraram_Database] [nvarchar](400) N'$."database"',
							[ConnPraram_DaysCalculation] [int] N'$."Days Calculation"',
							[ConnPraram_EncryptionMethod] [nvarchar](400) N'$."encryptionMethod"',
							[ConnPraram_FilePattern] [nvarchar](400) N'$."File Pattern"',
							[ConnPraram_Filename] [nvarchar](400) N'$."Filename"',
							[ConnPraram_FolderURI] [nvarchar](400) N'$."FolderURI"',
							[ConnPraram_HostName] [nvarchar](400) N'$."hostName"',
							[ConnPraram_HostNameInCertificate] [nvarchar](400) N'$."hostNameInCertificate"',
							[ConnPraram_KeyStore] [nvarchar](400) N'$."keyStore"',
							[ConnPraram_Mode] [nvarchar](400) N'$."mode"',
							[ConnPraram_OAuthRefreshURL] [nvarchar](400) N'$."OAuth Refresh URL"',
							[ConnPraram_ODBC_SUBTYPE] [nvarchar](400) N'$."ODBC_SUBTYPE"',
							[ConnPraram_OdbcDriverManager] [nvarchar](400) N'$."odbcDriverManager"',
							[ConnPraram_OrganizationId] [nvarchar](400) N'$."orgId"',
							[ConnPraram_PageSize] [int] N'$."Page Size"',
							[ConnPraram_PassKey1] [nvarchar](400) N'$."PassKey1"',
							[ConnPraram_Password] [nvarchar](400) N'$."password"',
							[ConnPraram_Port] [int] N'$."port"',
							[ConnPraram_ProxyConfiguration] [nvarchar](400) N'$."Proxy Configuration"',
							[ConnPraram_ProxyType] [nvarchar](400) N'$."Proxy Type"',
							[ConnPraram_RefreshToken] [nvarchar](400) N'$."Refresh Token"',
							[ConnPraram_Schema] [nvarchar](400) N'$."schema"',
							[ConnPraram_SelectFile] [nvarchar](400) N'$."Select File"',
							[ConnPraram_SourceFileDirectory] [nvarchar](400) N'$."Source File Directory"',
							[ConnPraram_SSLv3] [bit] N'$."sslv3"',
							[ConnPraram_SwaggerFilePath] [nvarchar](400) N'$."Swagger File Path"',
							[ConnPraram_TargetFileDirectory] [nvarchar](400) N'$."Target File Directory"',
							[ConnPraram_TLSv1] [bit] N'$."tlsv1"',
							[ConnPraram_TLSv1_1] [bit] N'$."tlsv1_1"',
							[ConnPraram_TLSv1_2] [bit] N'$."tlsv1_2"',
							[ConnPraram_TreatFirstRowAsHeader] [bit] N'$."TreatFirstRowAsHeader"',
							[ConnPraram_TrustStore] [nvarchar](400) N'$."trustStore"',
							[ConnPraram_Use_Proxy] [bit] N'$."USE_PROXY"',
							[ConnPraram_UserName] [nvarchar](400) N'$."userName"',
							[ConnPraram_ValidateServerCertificate] [bit] N'$."ValidateServerCertificate"'
						) AS [ConnectionParameters]
				WHERE [JSONFile].[Name] = 'Connections.json'
		) AS [Source]
			ON [Target].[IICSObjectId] = [Source].[IICSObjectId]
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				[IICSObjectId],
				[IICSObjectType],
				[AdjustedJdbcHostName],
				[AgentId],
				[AuthenticationType],
				[Codepage],
				[CreateTime],
				[CreatedBy],
				[Database],
				[DateFormat],
				[Description],
				[FederatedId],
				[Host],
				[InstanceDisplayName],
				[InstanceName],
				[Internal],
				[MajorUpdateTime],
				[Name],
				[OrganizationId],
				[Port],
				[RemoteDirectory],
				[RetryNetworkError],
				[RuntimeEnvironmentId],
				[Schema],
				[SecurityToken],
				[ServiceUrl],
				[ShortDescription],
				[SupportsCCIMultiGroup],
				[Timeout],
				[Type],
				[UpdateTime],
				[UpdatedBy],
				[Username],
				[ConnPraram_AdditionalConnectionProperties],
				[ConnPraram_AgentGroupId],
				[ConnPraram_AgentId],
				[ConnPraram_AuthenticationType],
				[ConnPraram_Authentication_Type],
				[ConnPraram_CCMConnPresentation],
				[ConnPraram_ClientAuthentication],
				[ConnPraram_ClientId],
				[ConnPraram_ClientSecret],
				[ConnPraram_CodePage],
				[ConnPraram_ConnectionType],
				[ConnPraram_ConnectionTypes],
				[ConnPraram_CryptoProtocolVersion],
				[ConnPraram_Database],
				[ConnPraram_DaysCalculation],
				[ConnPraram_EncryptionMethod],
				[ConnPraram_FilePattern],
				[ConnPraram_Filename],
				[ConnPraram_FolderURI],
				[ConnPraram_HostName],
				[ConnPraram_HostNameInCertificate],
				[ConnPraram_KeyStore],
				[ConnPraram_Mode],
				[ConnPraram_OAuthRefreshURL],
				[ConnPraram_ODBC_SUBTYPE],
				[ConnPraram_OdbcDriverManager],
				[ConnPraram_OrganizationId],
				[ConnPraram_PageSize],
				[ConnPraram_PassKey1],
				[ConnPraram_Password],
				[ConnPraram_Port],
				[ConnPraram_ProxyConfiguration],
				[ConnPraram_ProxyType],
				[ConnPraram_RefreshToken],
				[ConnPraram_Schema],
				[ConnPraram_SelectFile],
				[ConnPraram_SourceFileDirectory],
				[ConnPraram_SSLv3],
				[ConnPraram_SwaggerFilePath],
				[ConnPraram_TargetFileDirectory],
				[ConnPraram_TLSv1],
				[ConnPraram_TLSv1_1],
				[ConnPraram_TLSv1_2],
				[ConnPraram_TreatFirstRowAsHeader],
				[ConnPraram_TrustStore],
				[ConnPraram_Use_Proxy],
				[ConnPraram_UserName],
				[ConnPraram_ValidateServerCertificate]
			)
			VALUES
			(
				[Source].[IICSObjectId],
				[Source].[IICSObjectType],
				[Source].[AdjustedJdbcHostName],
				[Source].[AgentId],
				[Source].[AuthenticationType],
				[Source].[Codepage],
				[Source].[CreateTime],
				[Source].[CreatedBy],
				[Source].[Database],
				[Source].[DateFormat],
				[Source].[Description],
				[Source].[FederatedId],
				[Source].[Host],
				[Source].[InstanceDisplayName],
				[Source].[InstanceName],
				[Source].[Internal],
				[Source].[MajorUpdateTime],
				[Source].[Name],
				[Source].[OrganizationId],
				[Source].[Port],
				[Source].[RemoteDirectory],
				[Source].[RetryNetworkError],
				[Source].[RuntimeEnvironmentId],
				[Source].[Schema],
				[Source].[SecurityToken],
				[Source].[ServiceUrl],
				[Source].[ShortDescription],
				[Source].[SupportsCCIMultiGroup],
				[Source].[Timeout],
				[Source].[Type],
				[Source].[UpdateTime],
				[Source].[UpdatedBy],
				[Source].[Username],
				[Source].[ConnPraram_AdditionalConnectionProperties],
				[Source].[ConnPraram_AgentGroupId],
				[Source].[ConnPraram_AgentId],
				[Source].[ConnPraram_AuthenticationType],
				[Source].[ConnPraram_Authentication_Type],
				[Source].[ConnPraram_CCMConnPresentation],
				[Source].[ConnPraram_ClientAuthentication],
				[Source].[ConnPraram_ClientId],
				[Source].[ConnPraram_ClientSecret],
				[Source].[ConnPraram_CodePage],
				[Source].[ConnPraram_ConnectionType],
				[Source].[ConnPraram_ConnectionTypes],
				[Source].[ConnPraram_CryptoProtocolVersion],
				[Source].[ConnPraram_Database],
				[Source].[ConnPraram_DaysCalculation],
				[Source].[ConnPraram_EncryptionMethod],
				[Source].[ConnPraram_FilePattern],
				[Source].[ConnPraram_Filename],
				[Source].[ConnPraram_FolderURI],
				[Source].[ConnPraram_HostName],
				[Source].[ConnPraram_HostNameInCertificate],
				[Source].[ConnPraram_KeyStore],
				[Source].[ConnPraram_Mode],
				[Source].[ConnPraram_OAuthRefreshURL],
				[Source].[ConnPraram_ODBC_SUBTYPE],
				[Source].[ConnPraram_OdbcDriverManager],
				[Source].[ConnPraram_OrganizationId],
				[Source].[ConnPraram_PageSize],
				[Source].[ConnPraram_PassKey1],
				[Source].[ConnPraram_Password],
				[Source].[ConnPraram_Port],
				[Source].[ConnPraram_ProxyConfiguration],
				[Source].[ConnPraram_ProxyType],
				[Source].[ConnPraram_RefreshToken],
				[Source].[ConnPraram_Schema],
				[Source].[ConnPraram_SelectFile],
				[Source].[ConnPraram_SourceFileDirectory],
				[Source].[ConnPraram_SSLv3],
				[Source].[ConnPraram_SwaggerFilePath],
				[Source].[ConnPraram_TargetFileDirectory],
				[Source].[ConnPraram_TLSv1],
				[Source].[ConnPraram_TLSv1_1],
				[Source].[ConnPraram_TLSv1_2],
				[Source].[ConnPraram_TreatFirstRowAsHeader],
				[Source].[ConnPraram_TrustStore],
				[Source].[ConnPraram_Use_Proxy],
				[Source].[ConnPraram_UserName],
				[Source].[ConnPraram_ValidateServerCertificate]
			)
		WHEN MATCHED THEN UPDATE SET
			[IICSObjectType] = [Source].[IICSObjectType],
			[AdjustedJdbcHostName] = [Source].[AdjustedJdbcHostName],
			[AgentId] = [Source].[AgentId],
			[AuthenticationType] = [Source].[AuthenticationType],
			[Codepage] = [Source].[Codepage],
			[CreateTime] = [Source].[CreateTime],
			[CreatedBy] = [Source].[CreatedBy],
			[Database] = [Source].[Database],
			[DateFormat] = [Source].[DateFormat],
			[Description] = [Source].[Description],
			[FederatedId] = [Source].[FederatedId],
			[Host] = [Source].[Host],
			[InstanceDisplayName] = [Source].[InstanceDisplayName],
			[InstanceName] = [Source].[InstanceName],
			[Internal] = [Source].[Internal],
			[MajorUpdateTime] = [Source].[MajorUpdateTime],
			[Name] = [Source].[Name],
			[OrganizationId] = [Source].[OrganizationId],
			[Port] = [Source].[Port],
			[RemoteDirectory] = [Source].[RemoteDirectory],
			[RetryNetworkError] = [Source].[RetryNetworkError],
			[RuntimeEnvironmentId] = [Source].[RuntimeEnvironmentId],
			[Schema] = [Source].[Schema],
			[SecurityToken] = [Source].[SecurityToken],
			[ServiceUrl] = [Source].[ServiceUrl],
			[ShortDescription] = [Source].[ShortDescription],
			[SupportsCCIMultiGroup] = [Source].[SupportsCCIMultiGroup],
			[Timeout] = [Source].[Timeout],
			[Type] = [Source].[Type],
			[UpdateTime] = [Source].[UpdateTime],
			[UpdatedBy] = [Source].[UpdatedBy],
			[Username] = [Source].[Username],
			[ConnPraram_AdditionalConnectionProperties] = [Source].[ConnPraram_AdditionalConnectionProperties],
			[ConnPraram_AgentGroupId] = [Source].[ConnPraram_AgentGroupId],
			[ConnPraram_AgentId] = [Source].[ConnPraram_AgentId],
			[ConnPraram_AuthenticationType] = [Source].[ConnPraram_AuthenticationType],
			[ConnPraram_Authentication_Type] = [Source].[ConnPraram_Authentication_Type],
			[ConnPraram_CCMConnPresentation] = [Source].[ConnPraram_CCMConnPresentation],
			[ConnPraram_ClientAuthentication] = [Source].[ConnPraram_ClientAuthentication],
			[ConnPraram_ClientId] = [Source].[ConnPraram_ClientId],
			[ConnPraram_ClientSecret] = [Source].[ConnPraram_ClientSecret],
			[ConnPraram_CodePage] = [Source].[ConnPraram_CodePage],
			[ConnPraram_ConnectionType] = [Source].[ConnPraram_ConnectionType],
			[ConnPraram_ConnectionTypes] = [Source].[ConnPraram_ConnectionTypes],
			[ConnPraram_CryptoProtocolVersion] = [Source].[ConnPraram_CryptoProtocolVersion],
			[ConnPraram_Database] = [Source].[ConnPraram_Database],
			[ConnPraram_DaysCalculation] = [Source].[ConnPraram_DaysCalculation],
			[ConnPraram_EncryptionMethod] = [Source].[ConnPraram_EncryptionMethod],
			[ConnPraram_FilePattern] = [Source].[ConnPraram_FilePattern],
			[ConnPraram_Filename] = [Source].[ConnPraram_Filename],
			[ConnPraram_FolderURI] = [Source].[ConnPraram_FolderURI],
			[ConnPraram_HostName] = [Source].[ConnPraram_HostName],
			[ConnPraram_HostNameInCertificate] = [Source].[ConnPraram_HostNameInCertificate],
			[ConnPraram_KeyStore] = [Source].[ConnPraram_KeyStore],
			[ConnPraram_Mode] = [Source].[ConnPraram_Mode],
			[ConnPraram_OAuthRefreshURL] = [Source].[ConnPraram_OAuthRefreshURL],
			[ConnPraram_ODBC_SUBTYPE] = [Source].[ConnPraram_ODBC_SUBTYPE],
			[ConnPraram_OdbcDriverManager] = [Source].[ConnPraram_OdbcDriverManager],
			[ConnPraram_OrganizationId] = [Source].[ConnPraram_OrganizationId],
			[ConnPraram_PageSize] = [Source].[ConnPraram_PageSize],
			[ConnPraram_PassKey1] = [Source].[ConnPraram_PassKey1],
			[ConnPraram_Password] = [Source].[ConnPraram_Password],
			[ConnPraram_Port] = [Source].[ConnPraram_Port],
			[ConnPraram_ProxyConfiguration] = [Source].[ConnPraram_ProxyConfiguration],
			[ConnPraram_ProxyType] = [Source].[ConnPraram_ProxyType],
			[ConnPraram_RefreshToken] = [Source].[ConnPraram_RefreshToken],
			[ConnPraram_Schema] = [Source].[ConnPraram_Schema],
			[ConnPraram_SelectFile] = [Source].[ConnPraram_SelectFile],
			[ConnPraram_SourceFileDirectory] = [Source].[ConnPraram_SourceFileDirectory],
			[ConnPraram_SSLv3] = [Source].[ConnPraram_SSLv3],
			[ConnPraram_SwaggerFilePath] = [Source].[ConnPraram_SwaggerFilePath],
			[ConnPraram_TargetFileDirectory] = [Source].[ConnPraram_TargetFileDirectory],
			[ConnPraram_TLSv1] = [Source].[ConnPraram_TLSv1],
			[ConnPraram_TLSv1_1] = [Source].[ConnPraram_TLSv1_1],
			[ConnPraram_TLSv1_2] = [Source].[ConnPraram_TLSv1_2],
			[ConnPraram_TreatFirstRowAsHeader] = [Source].[ConnPraram_TreatFirstRowAsHeader],
			[ConnPraram_TrustStore] = [Source].[ConnPraram_TrustStore],
			[ConnPraram_Use_Proxy] = [Source].[ConnPraram_Use_Proxy],
			[ConnPraram_UserName] = [Source].[ConnPraram_UserName],
			[ConnPraram_ValidateServerCertificate] = [Source].[ConnPraram_ValidateServerCertificate]
	;
END
GO
CREATE OR ALTER PROCEDURE [IICS].[ProcessSchedules]
AS
BEGIN
	SET NOCOUNT ON
	MERGE [IICS].[Schedule] AS [Target]
		USING
		(
			SELECT 
				[Schedule].[IICSObjectId] AS [IICSObjectId],
				[Schedule].[IICSObjectType] AS [IICSObjectType],
				[Schedule].[CreateTime] AS [CreateTime],
				[Schedule].[CreatedBy] AS [CreatedBy],
				[Schedule].[DayOfMonth] AS [DayOfMonth],
				[Schedule].[Description] AS [Description],
				[Schedule].[EndTime] AS [EndTime],
				[Schedule].[EndTimeUTC] AS [EndTimeUTC],
				[Schedule].[Frequency] AS [Frequency],
				[Schedule].[Interval] AS [Interval],
				[Schedule].[Name] AS [Name],
				[Schedule].[OrganizationId] AS [OrganizationId],
				[Schedule].[RangeEndTime] AS [RangeEndTime],
				[Schedule].[RangeEndTimeUTC] AS [RangeEndTimeUTC],
				[Schedule].[RangeStartTime] AS [RangeStartTime],
				[Schedule].[RangeStartTimeUTC] AS [RangeStartTimeUTC],
				[Schedule].[StartTime] AS [StartTime],
				[Schedule].[StartTimeUTC] AS [StartTimeUTC],
				[Schedule].[TimeZoneId] AS [TimeZoneId],
				[Schedule].[UpdateTime] AS [UpdateTime],
				[Schedule].[UpdatedBy] AS [UpdatedBy],
				[Schedule].[WeekDay] AS [WeekDay],
				[Schedule].[Sunday] AS [Sunday],
				[Schedule].[Monday] AS [Monday],
				[Schedule].[Tuesday] AS [Tuesday],
				[Schedule].[Wednesday] AS [Wednesday],
				[Schedule].[Thursday] AS [Thursday],
				[Schedule].[Friday] AS [Friday],
				[Schedule].[Saturday] AS [Saturday]
				FROM [Reports_Library].[IICS].[JSONFile]
					OUTER APPLY OPENJSON([JSONFile].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[CreateTime] [datetime2](7) N'$."createTime"',
							[CreatedBy] [nvarchar](400) N'$."createdBy"',
							[DayOfMonth] [int] N'$."dayOfMonth"',
							[Description] [nvarchar](400) N'$."description"',
							[EndTime] [datetime2](7) N'$."endTime"',
							[EndTimeUTC] [datetime2](7) N'$."endTimeUTC"',
							[Frequency] [int] N'$."frequency"',
							[Interval] [nvarchar](400) N'$."interval"',
							[Name] [nvarchar](400) N'$."name"',
							[OrganizationId] [nvarchar](400) N'$."orgId"',
							[RangeEndTime] [datetime2](7) N'$."rangeEndTime"',
							[RangeEndTimeUTC] [datetime2](7) N'$."rangeEndTimeUTC"',
							[RangeStartTime] [datetime2](7) N'$."rangeStartTime"',
							[RangeStartTimeUTC] [datetime2](7) N'$."rangeStartTimeUTC"',
							[StartTime] [datetime2](7) N'$."startTime"',
							[StartTimeUTC] [datetime2](7) N'$."startTimeUTC"',
							[TimeZoneId] [nvarchar](400) N'$."timeZoneId"',
							[UpdateTime] [datetime2](7) N'$."updateTime"',
							[UpdatedBy] [nvarchar](400) N'$."updatedBy"',
							[WeekDay] [bit] N'$."weekDay"',
							[Sunday] [bit] N'$."sun"',
							[Monday] [bit] N'$."mon"',
							[Tuesday] [bit] N'$."tue"',
							[Wednesday] [bit] N'$."wed"',
							[Thursday] [bit] N'$."thu"',
							[Friday] [bit] N'$."fri"',
							[Saturday] [bit] N'$."sat"'
						) AS [Schedule]
				WHERE [JSONFile].[Name] LIKE N'Schedules.json'
		) AS [Source]
			ON [Target].[IICSObjectId] = [Source].[IICSObjectId]
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				[IICSObjectId],
				[IICSObjectType],
				[CreateTime],
				[CreatedBy],
				[DayOfMonth],
				[Description],
				[EndTime],
				[EndTimeUTC],
				[Frequency],
				[Interval],
				[Name],
				[OrganizationId],
				[RangeEndTime],
				[RangeEndTimeUTC],
				[RangeStartTime],
				[RangeStartTimeUTC],
				[StartTime],
				[StartTimeUTC],
				[TimeZoneId],
				[UpdateTime],
				[UpdatedBy],
				[WeekDay],
				[Sunday],
				[Monday],
				[Tuesday],
				[Wednesday],
				[Thursday],
				[Friday],
				[Saturday]
			)
			VALUES
			(
				[Source].[IICSObjectId],
				[Source].[IICSObjectType],
				[Source].[CreateTime],
				[Source].[CreatedBy],
				[Source].[DayOfMonth],
				[Source].[Description],
				[Source].[EndTime],
				[Source].[EndTimeUTC],
				[Source].[Frequency],
				[Source].[Interval],
				[Source].[Name],
				[Source].[OrganizationId],
				[Source].[RangeEndTime],
				[Source].[RangeEndTimeUTC],
				[Source].[RangeStartTime],
				[Source].[RangeStartTimeUTC],
				[Source].[StartTime],
				[Source].[StartTimeUTC],
				[Source].[TimeZoneId],
				[Source].[UpdateTime],
				[Source].[UpdatedBy],
				[Source].[WeekDay],
				[Source].[Sunday],
				[Source].[Monday],
				[Source].[Tuesday],
				[Source].[Wednesday],
				[Source].[Thursday],
				[Source].[Friday],
				[Source].[Saturday]
			)
		WHEN MATCHED THEN UPDATE SET
			[IICSObjectType] = [Source].[IICSObjectType],
			[CreateTime] = [Source].[CreateTime],
			[CreatedBy] = [Source].[CreatedBy],
			[DayOfMonth] = [Source].[DayOfMonth],
			[Description] = [Source].[Description],
			[EndTime] = [Source].[EndTime],
			[EndTimeUTC] = [Source].[EndTimeUTC],
			[Frequency] = [Source].[Frequency],
			[Interval] = [Source].[Interval],
			[Name] = [Source].[Name],
			[OrganizationId] = [Source].[OrganizationId],
			[RangeEndTime] = [Source].[RangeEndTime],
			[RangeEndTimeUTC] = [Source].[RangeEndTimeUTC],
			[RangeStartTime] = [Source].[RangeStartTime],
			[RangeStartTimeUTC] = [Source].[RangeStartTimeUTC],
			[StartTime] = [Source].[StartTime],
			[StartTimeUTC] = [Source].[StartTimeUTC],
			[TimeZoneId] = [Source].[TimeZoneId],
			[UpdateTime] = [Source].[UpdateTime],
			[UpdatedBy] = [Source].[UpdatedBy],
			[WeekDay] = [Source].[WeekDay],
			[Sunday] = [Source].[Sunday],
			[Monday] = [Source].[Monday],
			[Tuesday] = [Source].[Tuesday],
			[Wednesday] = [Source].[Wednesday],
			[Thursday] = [Source].[Thursday],
			[Friday] = [Source].[Friday],
			[Saturday] = [Source].[Saturday]
	;
END
GO
CREATE OR ALTER PROCEDURE [IICS].[ProcessMappings]
AS
BEGIN
	SET NOCOUNT ON
	MERGE [IICS].[Mapping] AS [Target]
		USING
		(
			SELECT
				[Mapping].[IICSObjectId] AS [IICSObjectId],
				[Mapping].[IICSObjectType] AS [IICSObjectType],
				[Mapping].[BundleVersion] AS [BundleVersion],
				[Mapping].[CreateTime] AS [CreateTime],
				[Mapping].[CreatedBy] AS [CreatedBy],
				[Mapping].[DeployTime] AS [DeployTime],
				[Mapping].[DeployedMappingPreviewFileRecordId] AS [DeployedMappingPreviewFileRecordId],
				[Mapping].[DeployedTemplateId] AS [DeployedTemplateId],
				[Mapping].[Description] AS [Description],
				[Mapping].[DocumentType] AS [DocumentType],
				[Mapping].[FixedConnection] AS [FixedConnection],
				[Mapping].[FixedConnectionDeployed] AS [FixedConnectionDeployed],
				[Mapping].[HasParameters] AS [HasParameters],
				[Mapping].[HasParametersDeployed] AS [HasParametersDeployed],
				[Mapping].[MappingPreviewFileRecordId] AS [MappingPreviewFileRecordId],
				[Mapping].[Name] AS [Name],
				[Mapping].[OrganizationId] AS [OrganizationId],
				[Mapping].[PrunedTemplateId] AS [PrunedTemplateId],
				[Mapping].[Tasks] AS [Tasks],
				[Mapping].[TemplateId] AS [TemplateId],
				[Mapping].[TestTaskId] AS [TestTaskId],
				[Mapping].[UpdateTime] AS [UpdateTime],
				[Mapping].[UpdatedBy] AS [UpdatedBy],
				[Mapping].[Valid] AS [Valid]
				FROM [Reports_Library].[IICS].[JSONFile]
					OUTER APPLY OPENJSON([JSONFile].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[BundleVersion] [nvarchar](400) N'$."bundleVersion"',
							[CreateTime] [datetime2](7) N'$."createTime"',
							[CreatedBy] [nvarchar](400) N'$."createdBy"',
							[DeployTime] [bigint] N'$."deployTime"',
							[DeployedMappingPreviewFileRecordId] [nvarchar](400) N'$."deployedMappingPreviewFileRecordId"',
							[DeployedTemplateId] [nvarchar](400) N'$."deployedTemplateId"',
							[Description] [nvarchar](400) N'$."description"',
							[DocumentType] [nvarchar](400) N'$."documentType"',
							[FixedConnection] [bit] N'$."fixedConnection"',
							[FixedConnectionDeployed] [bit] N'$."fixedConnectionDeployed"',
							[HasParameters] [bit] N'$."hasParameters"',
							[HasParametersDeployed] [bit] N'$."hasParametersDeployed"',
							[MappingPreviewFileRecordId] [nvarchar](400) N'$."mappingPreviewFileRecordId"',
							[Name] [nvarchar](400) N'$."name"',
							[OrganizationId] [nvarchar](400) N'$."orgId"',
							[PrunedTemplateId] [nvarchar](400) N'$."prunedTemplateId"',
							[Tasks] [int] N'$."tasks"',
							[TemplateId] [nvarchar](400) N'$."templateId"',
							[TestTaskId] [nvarchar](400) N'$."testTaskId"',
							[UpdateTime] [datetime2](7) N'$."updateTime"',
							[UpdatedBy] [nvarchar](400) N'$."updatedBy"',
							[Valid] [bit] N'$."valid"'
						) AS [Mapping]
				WHERE
					[JSONFile].[Name] LIKE N'Mappings\%.json'
					AND [JSONFile].[Name] NOT LIKE N'%Exception%'
		) AS [Source]
			ON [Target].[IICSObjectId] = [Source].[IICSObjectId]
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				[IICSObjectId],
				[IICSObjectType],
				[BundleVersion],
				[CreateTime],
				[CreatedBy],
				[DeployTime],
				[DeployedMappingPreviewFileRecordId],
				[DeployedTemplateId],
				[Description],
				[DocumentType],
				[FixedConnection],
				[FixedConnectionDeployed],
				[HasParameters],
				[HasParametersDeployed],
				[MappingPreviewFileRecordId],
				[Name],
				[OrganizationId],
				[PrunedTemplateId],
				[Tasks],
				[TemplateId],
				[TestTaskId],
				[UpdateTime],
				[UpdatedBy],
				[Valid]
			)
			VALUES
			(
				[Source].[IICSObjectId],
				[Source].[IICSObjectType],
				[Source].[BundleVersion],
				[Source].[CreateTime],
				[Source].[CreatedBy],
				[Source].[DeployTime],
				[Source].[DeployedMappingPreviewFileRecordId],
				[Source].[DeployedTemplateId],
				[Source].[Description],
				[Source].[DocumentType],
				[Source].[FixedConnection],
				[Source].[FixedConnectionDeployed],
				[Source].[HasParameters],
				[Source].[HasParametersDeployed],
				[Source].[MappingPreviewFileRecordId],
				[Source].[Name],
				[Source].[OrganizationId],
				[Source].[PrunedTemplateId],
				[Source].[Tasks],
				[Source].[TemplateId],
				[Source].[TestTaskId],
				[Source].[UpdateTime],
				[Source].[UpdatedBy],
				[Source].[Valid]
			)
		WHEN MATCHED THEN UPDATE SET
			[IICSObjectType] = [Source].[IICSObjectType],
			[BundleVersion] = [Source].[BundleVersion],
			[CreateTime] = [Source].[CreateTime],
			[CreatedBy] = [Source].[CreatedBy],
			[DeployTime] = [Source].[DeployTime],
			[DeployedMappingPreviewFileRecordId] = [Source].[DeployedMappingPreviewFileRecordId],
			[DeployedTemplateId] = [Source].[DeployedTemplateId],
			[Description] = [Source].[Description],
			[DocumentType] = [Source].[DocumentType],
			[FixedConnection] = [Source].[FixedConnection],
			[FixedConnectionDeployed] = [Source].[FixedConnectionDeployed],
			[HasParameters] = [Source].[HasParameters],
			[HasParametersDeployed] = [Source].[HasParametersDeployed],
			[MappingPreviewFileRecordId] = [Source].[MappingPreviewFileRecordId],
			[Name] = [Source].[Name],
			[OrganizationId] = [Source].[OrganizationId],
			[PrunedTemplateId] = [Source].[PrunedTemplateId],
			[Tasks] = [Source].[Tasks],
			[TemplateId] = [Source].[TemplateId],
			[TestTaskId] = [Source].[TestTaskId],
			[UpdateTime] = [Source].[UpdateTime],
			[UpdatedBy] = [Source].[UpdatedBy],
			[Valid] = [Source].[Valid]
	;
	MERGE [IICS].[MappingReference] AS [Target]
		USING
		(
			SELECT
				[Mapping].[IICSObjectId],
				[Mapping].[IICSObjectType],
				[Reference].[ReferencedIICSObjectId],
				[Reference].[ReferencedIICSObjectType]
				FROM [Reports_Library].[IICS].[JSONFile]
					OUTER APPLY OPENJSON([JSONFile].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[References] [nvarchar](MAX) N'$."references"' AS JSON
						) AS [Mapping]
					OUTER APPLY OPENJSON([Mapping].[References])
						WITH
						(
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[ReferencedIICSObjectId] [nvarchar](400) N'$."refObjectId"',
							[ReferencedIICSObjectType] [nvarchar](400) N'$."refType"'
						) AS [Reference]
				WHERE
					[JSONFile].[Name] LIKE N'Mappings\%.json'
					AND [JSONFile].[Name] NOT LIKE N'%Exception%'
		) AS [Source]
			ON
				[Target].[IICSObjectId] = [Source].[IICSObjectId]
				AND [Target].[ReferencedIICSObjectId] = [Source].[ReferencedIICSObjectId]
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				[IICSObjectId],
				[IICSObjectType],
				[ReferencedIICSObjectId],
				[ReferencedIICSObjectType]
			)
			VALUES
			(
				[Source].[IICSObjectId],
				[Source].[IICSObjectType],
				[Source].[ReferencedIICSObjectId],
				[Source].[ReferencedIICSObjectType]
			)
		WHEN MATCHED THEN UPDATE SET
			[IICSObjectType] = [Source].[IICSObjectType],
			[ReferencedIICSObjectType] = [Source].[ReferencedIICSObjectType]
	;
	MERGE [IICS].[MappingParameter] AS [Target]
		USING
		(
			SELECT
				[Mapping].[IICSObjectId],
				[MappingParameters].[Name],
				[Mapping].[IICSObjectType],
				[MappingParameters].[IICSParameterType],
				[MappingParameters].[Id],
				[MappingParameters].[BulkApiDBTarget],
				[MappingParameters].[CurrentlyProcessedFileName],
				[MappingParameters].[CustomQuery],
				[MappingParameters].[Description],
				[MappingParameters].[DynamicFileName],
				[MappingParameters].[ExcludeDynamicFileNameField],
				[MappingParameters].[FrsAsset],
				[MappingParameters].[HandleSpecialChars],
				[MappingParameters].[IsFileList],
				[MappingParameters].[IsRESTModernSource],
				[MappingParameters].[Label],
				[MappingParameters].[NaturalOrder],
				[MappingParameters].[NewFlatFile],
				[MappingParameters].[NewObject],
				[MappingParameters].[NewObjectName],
				[MappingParameters].[ObjectLabel],
				[MappingParameters].[ObjectName],
				[MappingParameters].[OperationType],
				[MappingParameters].[RetainFieldMetadata],
				[MappingParameters].[RuntimeParameterData],
				[MappingParameters].[ShowBusinessNames],
				[MappingParameters].[SourceConnectionId],
				[MappingParameters].[SourceObject],
				[MappingParameters].[TargetConnectionId],
				[MappingParameters].[TargetObject],
				[MappingParameters].[TargetObjectLabel],
				[MappingParameters].[TruncateTarget],
				[MappingParameters].[Type],
				[MappingParameters].[UseExactSrcNames]
				FROM [Reports_Library].[IICS].[JSONFile]
					OUTER APPLY OPENJSON([JSONFile].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[Parameters] [nvarchar](MAX) N'$."parameters"' AS JSON
						) AS [Mapping]
					OUTER APPLY OPENJSON([Mapping].[Parameters])
						WITH
						(
							[IICSParameterType] [nvarchar](400) N'$."@type"',
							[Id] [nvarchar](400) N'$."id"',
							[BulkApiDBTarget] [nvarchar](400) N'$."bulkApiDBTarget"',
							[CurrentlyProcessedFileName] [nvarchar](400) N'$."currentlyProcessedFileName"',
							[CustomQuery] [nvarchar](400) N'$."customQuery"',
							[Description] [nvarchar](400) N'$."description"',
							[DynamicFileName] [nvarchar](400) N'$."dynamicFileName"',
							[ExcludeDynamicFileNameField] [bit] N'$."excludeDynamicFileNameField"',
							[FrsAsset] [bit] N'$."frsAsset"',
							[HandleSpecialChars] [bit] N'$."handleSpecialChars"',
							[IsFileList] [bit] N'$."isFileList"',
							[IsRESTModernSource] [bit] N'$."isRESTModernSource"',
							[Label] [nvarchar](400) N'$."label"',
							[Name] [nvarchar](400) N'$."name"',
							[NaturalOrder] [bit] N'$."naturalOrder"',
							[NewFlatFile] [bit] N'$."newFlatFile"',
							[NewObject] [bit] N'$."newObject"',
							[NewObjectName] [nvarchar](400) N'$."newObjectName"',
							[ObjectLabel] [nvarchar](400) N'$."objectLabel"',
							[ObjectName] [nvarchar](400) N'$."objectName"',
							[OperationType] [nvarchar](400) N'$."operationType"',
							[RetainFieldMetadata] [bit] N'$."retainFieldMetadata"',
							[RuntimeParameterData] [nvarchar](400) N'$."runtimeParameterData"',
							[ShowBusinessNames] [bit] N'$."showBusinessNames"',
							[SourceConnectionId] [nvarchar](400) N'$."sourceConnectionId"',
							[SourceObject] [nvarchar](400) N'$."sourceObject"',
							[TargetConnectionId] [nvarchar](400) N'$."targetConnectionId"',
							[TargetObject] [nvarchar](400) N'$."targetObject"',
							[TargetObjectLabel] [nvarchar](400) N'$."targetObjectLabel"',
							[TruncateTarget] [bit] N'$."truncateTarget"',
							[Type] [nvarchar](400) N'$."type"',
							[UseExactSrcNames] [bit] N'$."useExactSrcNames"'
						) AS [MappingParameters]
				WHERE
					[JSONFile].[Name] LIKE N'Mappings\%.json'
					AND [JSONFile].[Name] NOT LIKE N'%Exception%'
		) AS [Source]
			ON
				[Target].[IICSObjectId] = [Source].[Name]
				AND [Target].[Name] = [Source].[Name]
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				[IICSObjectId],
				[Name],
				[IICSObjectType],
				[IICSParameterType],
				[Id],
				[BulkApiDBTarget],
				[CurrentlyProcessedFileName],
				[CustomQuery],
				[Description],
				[DynamicFileName],
				[ExcludeDynamicFileNameField],
				[FrsAsset],
				[HandleSpecialChars],
				[IsFileList],
				[IsRESTModernSource],
				[Label],
				[NaturalOrder],
				[NewFlatFile],
				[NewObject],
				[NewObjectName],
				[ObjectLabel],
				[ObjectName],
				[OperationType],
				[RetainFieldMetadata],
				[RuntimeParameterData],
				[ShowBusinessNames],
				[SourceConnectionId],
				[SourceObject],
				[TargetConnectionId],
				[TargetObject],
				[TargetObjectLabel],
				[TruncateTarget],
				[Type],
				[UseExactSrcNames]
			)
			VALUES
			(
				[Source].[IICSObjectId],
				[Source].[Name],
				[Source].[IICSObjectType],
				[Source].[IICSParameterType],
				[Source].[Id],
				[Source].[BulkApiDBTarget],
				[Source].[CurrentlyProcessedFileName],
				[Source].[CustomQuery],
				[Source].[Description],
				[Source].[DynamicFileName],
				[Source].[ExcludeDynamicFileNameField],
				[Source].[FrsAsset],
				[Source].[HandleSpecialChars],
				[Source].[IsFileList],
				[Source].[IsRESTModernSource],
				[Source].[Label],
				[Source].[NaturalOrder],
				[Source].[NewFlatFile],
				[Source].[NewObject],
				[Source].[NewObjectName],
				[Source].[ObjectLabel],
				[Source].[ObjectName],
				[Source].[OperationType],
				[Source].[RetainFieldMetadata],
				[Source].[RuntimeParameterData],
				[Source].[ShowBusinessNames],
				[Source].[SourceConnectionId],
				[Source].[SourceObject],
				[Source].[TargetConnectionId],
				[Source].[TargetObject],
				[Source].[TargetObjectLabel],
				[Source].[TruncateTarget],
				[Source].[Type],
				[Source].[UseExactSrcNames]
			)
		WHEN MATCHED THEN UPDATE SET
			[IICSObjectType] = [Source].[IICSObjectType],
			[IICSParameterType] = [Source].[IICSParameterType],
			[Id] = [Source].[Id],
			[BulkApiDBTarget] = [Source].[BulkApiDBTarget],
			[CurrentlyProcessedFileName] = [Source].[CurrentlyProcessedFileName],
			[CustomQuery] = [Source].[CustomQuery],
			[Description] = [Source].[Description],
			[DynamicFileName] = [Source].[DynamicFileName],
			[ExcludeDynamicFileNameField] = [Source].[ExcludeDynamicFileNameField],
			[FrsAsset] = [Source].[FrsAsset],
			[HandleSpecialChars] = [Source].[HandleSpecialChars],
			[IsFileList] = [Source].[IsFileList],
			[IsRESTModernSource] = [Source].[IsRESTModernSource],
			[Label] = [Source].[Label],
			[Name] = [Source].[Name],
			[NaturalOrder] = [Source].[NaturalOrder],
			[NewFlatFile] = [Source].[NewFlatFile],
			[NewObject] = [Source].[NewObject],
			[NewObjectName] = [Source].[NewObjectName],
			[ObjectLabel] = [Source].[ObjectLabel],
			[ObjectName] = [Source].[ObjectName],
			[OperationType] = [Source].[OperationType],
			[RetainFieldMetadata] = [Source].[RetainFieldMetadata],
			[RuntimeParameterData] = [Source].[RuntimeParameterData],
			[ShowBusinessNames] = [Source].[ShowBusinessNames],
			[SourceConnectionId] = [Source].[SourceConnectionId],
			[SourceObject] = [Source].[SourceObject],
			[TargetConnectionId] = [Source].[TargetConnectionId],
			[TargetObject] = [Source].[TargetObject],
			[TargetObjectLabel] = [Source].[TargetObjectLabel],
			[TruncateTarget] = [Source].[TruncateTarget],
			[Type] = [Source].[Type],
			[UseExactSrcNames] = [Source].[UseExactSrcNames]
	;


END
GO
CREATE OR ALTER PROCEDURE [IICS].[ProcessMappingTasks]
AS
BEGIN
	SET NOCOUNT ON
	MERGE [IICS].[MappingTask] AS [Target]
		USING
		(
			SELECT
				[MappingTask].[IICSObjectId] AS [IICSObjectId],
				[MappingTask].[IICSObjectType] AS [IICSObjectType],
				[MappingTask].[AgentId] AS [AgentId],
				[MappingTask].[AutoTunedApplied] AS [AutoTunedApplied],
				[MappingTask].[AutoTunedAppliedType] AS [AutoTunedAppliedType],
				[MappingTask].[CreateTime] AS [CreateTime],
				[MappingTask].[CreatedBy] AS [CreatedBy],
				[MappingTask].[Description] AS [Description],
				[MappingTask].[EnableCrossSchemaPushdown] AS [EnableCrossSchemaPushdown],
				[MappingTask].[EnableParallelRun] AS [EnableParallelRun],
				[MappingTask].[ErrorTaskEmail] AS [ErrorTaskEmail],
				[MappingTask].[InOutParameters] AS [InOutParameters],
				[MappingTask].[LastRunTime] AS [LastRunTime],
				[MappingTask].[MappingId] AS [MappingId],
				[MappingTask].[MaxLogs] AS [MaxLogs],
				[MappingTask].[Name] AS [Name],
				[MappingTask].[OrganizationId] AS [OrganizationId],
				[MappingTask].[ParamFileType] AS [ParamFileType],
				[MappingTask].[ParameterFileEncoding] AS [ParameterFileEncoding],
				[MappingTask].[PostProcessingCmd] AS [PostProcessingCmd],
				[MappingTask].[PreProcessingCmd] AS [PreProcessingCmd],
				[MappingTask].[RuntimeEnvironmentId] AS [RuntimeEnvironmentId],
				[MappingTask].[ScheduleId] AS [ScheduleId],
				[MappingTask].[SchemaMode] AS [SchemaMode],
				[MappingTask].[ShortDescription] AS [ShortDescription],
				[MappingTask].[SuccessTaskEmail] AS [SuccessTaskEmail],
				[MappingTask].[UpdateTime] AS [UpdateTime],
				[MappingTask].[UpdatedBy] AS [UpdatedBy],
				[MappingTask].[Verbose] AS [Verbose],
				[MappingTask].[WarningTaskEmail] AS [WarningTaskEmail]
				FROM [Reports_Library].[IICS].[JSONFile]
					OUTER APPLY OPENJSON([JSONFile].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[AgentId] [nvarchar](400) N'$."agentId"',
							[AutoTunedApplied] [bit] N'$."autoTunedApplied"',
							[AutoTunedAppliedType] [nvarchar](400) N'$."autoTunedAppliedType"',
							[CreateTime] [datetime2](7) N'$."createTime"',
							[CreatedBy] [nvarchar](400) N'$."createdBy"',
							[Description] [nvarchar](400) N'$."description"',
							[EnableCrossSchemaPushdown] [bit] N'$."enableCrossSchemaPushdown"',
							[EnableParallelRun] [bit] N'$."enableParallelRun"',
							[ErrorTaskEmail] [nvarchar](400) N'$."errorTaskEmail"',
							[InOutParameters] [nvarchar](400) N'$."inOutParameters"',
							[LastRunTime] [nvarchar](400) N'$."lastRunTime"',
							[MappingId] [nvarchar](400) N'$."mappingId"',
							[MaxLogs] [int] N'$."maxLogs"',
							[Name] [nvarchar](400) N'$."name"',
							[OrganizationId] [nvarchar](400) N'$."orgId"',
							[ParamFileType] [nvarchar](400) N'$."paramFileType"',
							[ParameterFileEncoding] [nvarchar](400) N'$."parameterFileEncoding"',
							[PostProcessingCmd] [nvarchar](400) N'$."postProcessingCmd"',
							[PreProcessingCmd] [nvarchar](400) N'$."preProcessingCmd"',
							[RuntimeEnvironmentId] [nvarchar](400) N'$."runtimeEnvironmentId"',
							[ScheduleId] [nvarchar](400) N'$."scheduleId"',
							[SchemaMode] [nvarchar](400) N'$."schemaMode"',
							[ShortDescription] [nvarchar](400) N'$."shortDescription"',
							[SuccessTaskEmail] [nvarchar](400) N'$."successTaskEmail"',
							[UpdateTime] [datetime2](7) N'$."updateTime"',
							[UpdatedBy] [nvarchar](400) N'$."updatedBy"',
							[Verbose] [bit] N'$."verbose"',
							[WarningTaskEmail] [nvarchar](400) N'$."warningTaskEmail"'
						) AS [MappingTask]
				WHERE
					[JSONFile].[Name] LIKE N'MappingTasks\%.json'
					AND [JSONFile].[Name] NOT LIKE N'%Exception%'
		) AS [Source]
			ON [Target].[IICSObjectId] = [Source].[IICSObjectId]
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				[IICSObjectId],
				[IICSObjectType],
				[AgentId],
				[AutoTunedApplied],
				[AutoTunedAppliedType],
				[CreateTime],
				[CreatedBy],
				[Description],
				[EnableCrossSchemaPushdown],
				[EnableParallelRun],
				[ErrorTaskEmail],
				[InOutParameters],
				[LastRunTime],
				[MappingId],
				[MaxLogs],
				[Name],
				[OrganizationId],
				[ParamFileType],
				[ParameterFileEncoding],
				[PostProcessingCmd],
				[PreProcessingCmd],
				[RuntimeEnvironmentId],
				[ScheduleId],
				[SchemaMode],
				[ShortDescription],
				[SuccessTaskEmail],
				[UpdateTime],
				[UpdatedBy],
				[Verbose],
				[WarningTaskEmail]
			)
			VALUES
			(
				[Source].[IICSObjectId],
				[Source].[IICSObjectType],
				[Source].[AgentId],
				[Source].[AutoTunedApplied],
				[Source].[AutoTunedAppliedType],
				[Source].[CreateTime],
				[Source].[CreatedBy],
				[Source].[Description],
				[Source].[EnableCrossSchemaPushdown],
				[Source].[EnableParallelRun],
				[Source].[ErrorTaskEmail],
				[Source].[InOutParameters],
				[Source].[LastRunTime],
				[Source].[MappingId],
				[Source].[MaxLogs],
				[Source].[Name],
				[Source].[OrganizationId],
				[Source].[ParamFileType],
				[Source].[ParameterFileEncoding],
				[Source].[PostProcessingCmd],
				[Source].[PreProcessingCmd],
				[Source].[RuntimeEnvironmentId],
				[Source].[ScheduleId],
				[Source].[SchemaMode],
				[Source].[ShortDescription],
				[Source].[SuccessTaskEmail],
				[Source].[UpdateTime],
				[Source].[UpdatedBy],
				[Source].[Verbose],
				[Source].[WarningTaskEmail]
			)
		WHEN MATCHED THEN UPDATE SET
			[IICSObjectType] = [Source].[IICSObjectType],
			[AgentId] = [Source].[AgentId],
			[AutoTunedApplied] = [Source].[AutoTunedApplied],
			[AutoTunedAppliedType] = [Source].[AutoTunedAppliedType],
			[CreateTime] = [Source].[CreateTime],
			[CreatedBy] = [Source].[CreatedBy],
			[Description] = [Source].[Description],
			[EnableCrossSchemaPushdown] = [Source].[EnableCrossSchemaPushdown],
			[EnableParallelRun] = [Source].[EnableParallelRun],
			[ErrorTaskEmail] = [Source].[ErrorTaskEmail],
			[InOutParameters] = [Source].[InOutParameters],
			[LastRunTime] = [Source].[LastRunTime],
			[MappingId] = [Source].[MappingId],
			[MaxLogs] = [Source].[MaxLogs],
			[Name] = [Source].[Name],
			[OrganizationId] = [Source].[OrganizationId],
			[ParamFileType] = [Source].[ParamFileType],
			[ParameterFileEncoding] = [Source].[ParameterFileEncoding],
			[PostProcessingCmd] = [Source].[PostProcessingCmd],
			[PreProcessingCmd] = [Source].[PreProcessingCmd],
			[RuntimeEnvironmentId] = [Source].[RuntimeEnvironmentId],
			[ScheduleId] = [Source].[ScheduleId],
			[SchemaMode] = [Source].[SchemaMode],
			[ShortDescription] = [Source].[ShortDescription],
			[SuccessTaskEmail] = [Source].[SuccessTaskEmail],
			[UpdateTime] = [Source].[UpdateTime],
			[UpdatedBy] = [Source].[UpdatedBy],
			[Verbose] = [Source].[Verbose],
			[WarningTaskEmail] = [Source].[WarningTaskEmail]
	;
	MERGE [IICS].[MappingTaskParameter] AS [Target]
		USING
		(
			SELECT
				[Mapping].[IICSObjectId],
				[MappingTaskParameters].[Name],
				[Mapping].[IICSObjectType],
				[MappingTaskParameters].[IICSParameterType],
				[MappingTaskParameters].[Id],
				[MappingTaskParameters].[BulkApiDBTarget],
				[MappingTaskParameters].[CurrentlyProcessedFileName],
				[MappingTaskParameters].[CustomQuery],
				[MappingTaskParameters].[Description],
				[MappingTaskParameters].[DynamicFileName],
				[MappingTaskParameters].[ExcludeDynamicFileNameField],
				[MappingTaskParameters].[ExtendedObject],
				[MappingTaskParameters].[FetchMode],
				[MappingTaskParameters].[FrsAsset],
				[MappingTaskParameters].[HandleSpecialChars],
				[MappingTaskParameters].[IsFileList],
				[MappingTaskParameters].[IsRESTModernSource],
				[MappingTaskParameters].[Label],
				[MappingTaskParameters].[NaturalOrder],
				[MappingTaskParameters].[NewFlatFile],
				[MappingTaskParameters].[NewObject],
				[MappingTaskParameters].[NewObjectName],
				[MappingTaskParameters].[ObjectLabel],
				[MappingTaskParameters].[ObjectName],
				[MappingTaskParameters].[OperationType],
				[MappingTaskParameters].[OverriddenFields],
				[MappingTaskParameters].[RetainFieldMetadata],
				[MappingTaskParameters].[RuntimeAttrs],
				[MappingTaskParameters].[RuntimeParameterData],
				[MappingTaskParameters].[ShowBusinessNames],
				[MappingTaskParameters].[SourceConnectionId],
				[MappingTaskParameters].[SourceObject],
				[MappingTaskParameters].[TargetConnectionId],
				[MappingTaskParameters].[TargetObject],
				[MappingTaskParameters].[TargetObjectLabel],
				[MappingTaskParameters].[TargetRefsV2],
				[MappingTaskParameters].[TargetSchemaMode],
				[MappingTaskParameters].[TargetUpdateColumns],
				[MappingTaskParameters].[Text],
				[MappingTaskParameters].[TruncateTarget],
				[MappingTaskParameters].[Type],
				[MappingTaskParameters].[UseExactSrcNames]
				FROM [Reports_Library].[IICS].[JSONFile]
					OUTER APPLY OPENJSON([JSONFile].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[Parameters] [nvarchar](MAX) N'$."parameters"' AS JSON
						) AS [Mapping]
					OUTER APPLY OPENJSON([Mapping].[Parameters])
						WITH
						(
							[IICSParameterType] [nvarchar](400) N'$."@type"',
							[Id] [nvarchar](400) N'$."id"',
							[BulkApiDBTarget] [nvarchar](400) N'$."bulkApiDBTarget"',
							[CurrentlyProcessedFileName] [nvarchar](400) N'$."currentlyProcessedFileName"',
							[CustomQuery] [nvarchar](400) N'$."customQuery"',
							[Description] [nvarchar](400) N'$."description"',
							[DynamicFileName] [nvarchar](400) N'$."dynamicFileName"',
							[ExcludeDynamicFileNameField] [nvarchar](400) N'$."excludeDynamicFileNameField"',
							[ExtendedObject] [nvarchar](400) N'$."extendedObject"',
							[FetchMode] [nvarchar](400) N'$."fetchMode"',
							[FrsAsset] [nvarchar](400) N'$."frsAsset"',
							[HandleSpecialChars] [bit] N'$."handleSpecialChars"',
							[IsFileList] [nvarchar](400) N'$."isFileList"',
							[IsRESTModernSource] [bit] N'$."isRESTModernSource"',
							[Label] [nvarchar](400) N'$."label"',
							[Name] [nvarchar](400) N'$."name"',
							[NaturalOrder] [nvarchar](400) N'$."naturalOrder"',
							[NewFlatFile] [nvarchar](400) N'$."newFlatFile"',
							[NewObject] [nvarchar](400) N'$."newObject"',
							[NewObjectName] [nvarchar](400) N'$."newObjectName"',
							[ObjectLabel] [nvarchar](400) N'$."objectLabel"',
							[ObjectName] [nvarchar](400) N'$."objectName"',
							[OperationType] [nvarchar](400) N'$."operationType"',
							[OverriddenFields] [nvarchar](400) N'$."overriddenFields"',
							[RetainFieldMetadata] [nvarchar](400) N'$."retainFieldMetadata"',
							[RuntimeAttrs] [nvarchar](400) N'$."runtimeAttrs"',
							[RuntimeParameterData] [nvarchar](400) N'$."runtimeParameterData"',
							[ShowBusinessNames] [nvarchar](400) N'$."showBusinessNames"',
							[SourceConnectionId] [nvarchar](400) N'$."sourceConnectionId"',
							[SourceObject] [nvarchar](400) N'$."sourceObject"',
							[TargetConnectionId] [nvarchar](400) N'$."targetConnectionId"',
							[TargetObject] [nvarchar](400) N'$."targetObject"',
							[TargetObjectLabel] [nvarchar](400) N'$."targetObjectLabel"',
							[TargetRefsV2] [nvarchar](400) N'$."targetRefsV2"',
							[TargetSchemaMode] [nvarchar](400) N'$."targetSchemaMode"',
							[TargetUpdateColumns] [nvarchar](400) N'$."targetUpdateColumns"',
							[Text] [nvarchar](400) N'$."text"',
							[TruncateTarget] [bit] N'$."truncateTarget"',
							[Type] [nvarchar](400) N'$."type"',
							[UseExactSrcNames] [bit] N'$."useExactSrcNames"'
						) AS [MappingTaskParameters]
				WHERE
					[JSONFile].[Name] LIKE N'MappingTasks\%.json'
					AND [JSONFile].[Name] NOT LIKE N'%Exception%'
		) AS [Source]
			ON
				[Target].[IICSObjectId] = [Source].[Name]
				AND [Target].[Name] = [Source].[Name]
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				[IICSObjectId],
				[Name],
				[IICSObjectType],
				[IICSParameterType],
				[Id],
				[BulkApiDBTarget],
				[CurrentlyProcessedFileName],
				[CustomQuery],
				[Description],
				[DynamicFileName],
				[ExcludeDynamicFileNameField],
				[ExtendedObject],
				[FetchMode],
				[FrsAsset],
				[HandleSpecialChars],
				[IsFileList],
				[IsRESTModernSource],
				[Label],
				[NaturalOrder],
				[NewFlatFile],
				[NewObject],
				[NewObjectName],
				[ObjectLabel],
				[ObjectName],
				[OperationType],
				[OverriddenFields],
				[RetainFieldMetadata],
				[RuntimeAttrs],
				[RuntimeParameterData],
				[ShowBusinessNames],
				[SourceConnectionId],
				[SourceObject],
				[TargetConnectionId],
				[TargetObject],
				[TargetObjectLabel],
				[TargetRefsV2],
				[TargetSchemaMode],
				[TargetUpdateColumns],
				[Text],
				[TruncateTarget],
				[Type],
				[UseExactSrcNames]
			)
			VALUES
			(
				[Source].[IICSObjectId],
				[Source].[Name],
				[Source].[IICSObjectType],
				[Source].[IICSParameterType],
				[Source].[Id],
				[Source].[BulkApiDBTarget],
				[Source].[CurrentlyProcessedFileName],
				[Source].[CustomQuery],
				[Source].[Description],
				[Source].[DynamicFileName],
				[Source].[ExcludeDynamicFileNameField],
				[Source].[ExtendedObject],
				[Source].[FetchMode],
				[Source].[FrsAsset],
				[Source].[HandleSpecialChars],
				[Source].[IsFileList],
				[Source].[IsRESTModernSource],
				[Source].[Label],
				[Source].[NaturalOrder],
				[Source].[NewFlatFile],
				[Source].[NewObject],
				[Source].[NewObjectName],
				[Source].[ObjectLabel],
				[Source].[ObjectName],
				[Source].[OperationType],
				[Source].[OverriddenFields],
				[Source].[RetainFieldMetadata],
				[Source].[RuntimeAttrs],
				[Source].[RuntimeParameterData],
				[Source].[ShowBusinessNames],
				[Source].[SourceConnectionId],
				[Source].[SourceObject],
				[Source].[TargetConnectionId],
				[Source].[TargetObject],
				[Source].[TargetObjectLabel],
				[Source].[TargetRefsV2],
				[Source].[TargetSchemaMode],
				[Source].[TargetUpdateColumns],
				[Source].[Text],
				[Source].[TruncateTarget],
				[Source].[Type],
				[Source].[UseExactSrcNames]
			)
		WHEN MATCHED THEN UPDATE SET
			[IICSObjectType] = [Source].[IICSObjectType],
			[IICSParameterType] = [Source].[IICSParameterType],
			[Id] = [Source].[Id],
			[BulkApiDBTarget] = [Source].[BulkApiDBTarget],
			[CurrentlyProcessedFileName] = [Source].[CurrentlyProcessedFileName],
			[CustomQuery] = [Source].[CustomQuery],
			[Description] = [Source].[Description],
			[DynamicFileName] = [Source].[DynamicFileName],
			[ExcludeDynamicFileNameField] = [Source].[ExcludeDynamicFileNameField],
			[ExtendedObject] = [Source].[ExtendedObject],
			[FetchMode] = [Source].[FetchMode],
			[FrsAsset] = [Source].[FrsAsset],
			[HandleSpecialChars] = [Source].[HandleSpecialChars],
			[IsFileList] = [Source].[IsFileList],
			[IsRESTModernSource] = [Source].[IsRESTModernSource],
			[Label] = [Source].[Label],
			[NaturalOrder] = [Source].[NaturalOrder],
			[NewFlatFile] = [Source].[NewFlatFile],
			[NewObject] = [Source].[NewObject],
			[NewObjectName] = [Source].[NewObjectName],
			[ObjectLabel] = [Source].[ObjectLabel],
			[ObjectName] = [Source].[ObjectName],
			[OperationType] = [Source].[OperationType],
			[OverriddenFields] = [Source].[OverriddenFields],
			[RetainFieldMetadata] = [Source].[RetainFieldMetadata],
			[RuntimeAttrs] = [Source].[RuntimeAttrs],
			[RuntimeParameterData] = [Source].[RuntimeParameterData],
			[ShowBusinessNames] = [Source].[ShowBusinessNames],
			[SourceConnectionId] = [Source].[SourceConnectionId],
			[SourceObject] = [Source].[SourceObject],
			[TargetConnectionId] = [Source].[TargetConnectionId],
			[TargetObject] = [Source].[TargetObject],
			[TargetObjectLabel] = [Source].[TargetObjectLabel],
			[TargetRefsV2] = [Source].[TargetRefsV2],
			[TargetSchemaMode] = [Source].[TargetSchemaMode],
			[TargetUpdateColumns] = [Source].[TargetUpdateColumns],
			[Text] = [Source].[Text],
			[TruncateTarget] = [Source].[TruncateTarget],
			[Type] = [Source].[Type],
			[UseExactSrcNames] = [Source].[UseExactSrcNames]
	;
END
GO
CREATE OR ALTER PROCEDURE [IICS].[ProcessWorkflows]
AS
BEGIN
	SET NOCOUNT ON
	MERGE [IICS].[Workflow] AS [Target]
		USING
		(
			SELECT
				[Workflow].[IICSObjectId] AS [IICSObjectId],
				[Workflow].[IICSObjectType] AS [IICSObjectType],
				[Workflow].[CreateTime] AS [CreateTime],
				[Workflow].[CreatedBy] AS [CreatedBy],
				[Workflow].[Description] AS [Description],
				[Workflow].[ErrorTaskEmail] AS [ErrorTaskEmail],
				[Workflow].[MaxLogs] AS [MaxLogs],
				[Workflow].[Name] AS [Name],
				[Workflow].[OrganizationId] AS [OrganizationId],
				[Workflow].[ScheduleId] AS [ScheduleId],
				[Workflow].[SuccessTaskEmail] AS [SuccessTaskEmail],
				[Workflow].[UpdateTime] AS [UpdateTime],
				[Workflow].[UpdatedBy] AS [UpdatedBy],
				[Workflow].[WarningTaskEmail] AS [WarningTaskEmail]
				FROM [Reports_Library].[IICS].[JSONFile]
					OUTER APPLY OPENJSON([JSONFile].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[CreateTime] [datetime2](7) N'$."createTime"',
							[CreatedBy] [nvarchar](400) N'$."createdBy"',
							[Description] [nvarchar](400) N'$."description"',
							[ErrorTaskEmail] [nvarchar](400) N'$."errorTaskEmail"',
							[MaxLogs] [int] N'$."maxLogs"',
							[Name] [nvarchar](400) N'$."name"',
							[OrganizationId] [nvarchar](400) N'$."orgId"',
							[ScheduleId] [nvarchar](400) N'$."scheduleId"',
							[SuccessTaskEmail] [nvarchar](400) N'$."successTaskEmail"',
							[UpdateTime] [datetime2](7) N'$."updateTime"',
							[UpdatedBy] [nvarchar](400) N'$."updatedBy"',
							[WarningTaskEmail] [nvarchar](400) N'$."warningTaskEmail"'
						) AS [Workflow]
				WHERE
					[JSONFile].[Name] LIKE N'Workflows\%.json'
					AND [JSONFile].[Name] NOT LIKE N'%Exception%'
		) AS [Source]
			ON [Target].[IICSObjectId] = [Source].[IICSObjectId]
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				[IICSObjectId],
				[IICSObjectType],
				[CreateTime],
				[CreatedBy],
				[Description],
				[ErrorTaskEmail],
				[MaxLogs],
				[Name],
				[OrganizationId],
				[ScheduleId],
				[SuccessTaskEmail],
				[UpdateTime],
				[UpdatedBy],
				[WarningTaskEmail]
			)
			VALUES
			(
				[Source].[IICSObjectId],
				[Source].[IICSObjectType],
				[Source].[CreateTime],
				[Source].[CreatedBy],
				[Source].[Description],
				[Source].[ErrorTaskEmail],
				[Source].[MaxLogs],
				[Source].[Name],
				[Source].[OrganizationId],
				[Source].[ScheduleId],
				[Source].[SuccessTaskEmail],
				[Source].[UpdateTime],
				[Source].[UpdatedBy],
				[Source].[WarningTaskEmail]
			)
		WHEN MATCHED THEN UPDATE SET
			[IICSObjectType] = [Source].[IICSObjectType],
			[CreateTime] = [Source].[CreateTime],
			[CreatedBy] = [Source].[CreatedBy],
			[Description] = [Source].[Description],
			[ErrorTaskEmail] = [Source].[ErrorTaskEmail],
			[MaxLogs] = [Source].[MaxLogs],
			[Name] = [Source].[Name],
			[OrganizationId] = [Source].[OrganizationId],
			[ScheduleId] = [Source].[ScheduleId],
			[SuccessTaskEmail] = [Source].[SuccessTaskEmail],
			[UpdateTime] = [Source].[UpdateTime],
			[UpdatedBy] = [Source].[UpdatedBy],
			[WarningTaskEmail] = [Source].[WarningTaskEmail]
	;
	MERGE [IICS].[WorkflowTask] AS [Target]
		USING
		(
			SELECT
				[Workflow].[IICSObjectId],
				[WorkflowTask].[Name],
				[Workflow].[IICSObjectType],
				[WorkflowTask].[IICSTaskType],
				[WorkflowTask].[StopOnError],
				[WorkflowTask].[StopOnWarning],
				[WorkflowTask].[TaskId],
				[WorkflowTask].[Type]
				FROM [Reports_Library].[IICS].[JSONFile]
					OUTER APPLY OPENJSON([JSONFile].[Content])
						WITH
						(
							[IICSObjectId] [nvarchar](400) N'$."id"',
							[IICSObjectType] [nvarchar](400) N'$."@type"',
							[Tasks] [nvarchar](MAX) N'$."tasks"' AS JSON
						) AS [Workflow]
					OUTER APPLY OPENJSON([Workflow].[Tasks])
						WITH
						(
							[IICSTaskType] [nvarchar](400) N'$."@type"',
							[Name] [nvarchar](400) N'$."name"',
							[StopOnError] [nvarchar](400) N'$."stopOnError"',
							[StopOnWarning] [nvarchar](400) N'$."stopOnWarning"',
							[TaskId] [nvarchar](400) N'$."taskId"',
							[Type] [nvarchar](400) N'$."type"'
						) AS [WorkflowTask]
				WHERE
					[JSONFile].[Name] LIKE N'Workflows\%.json'
					AND [JSONFile].[Name] NOT LIKE N'%Exception%'
		) AS [Source]
			ON
				[Target].[IICSObjectId] = [Source].[Name]
				AND [Target].[Name] = [Source].[Name]
		WHEN NOT MATCHED BY SOURCE THEN DELETE
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				[IICSObjectId],
				[Name],
				[IICSObjectType],
				[IICSTaskType],
				[StopOnError],
				[StopOnWarning],
				[TaskId],
				[Type]
			)
			VALUES
			(
				[Source].[IICSObjectId],
				[Source].[Name],
				[Source].[IICSObjectType],
				[Source].[IICSTaskType],
				[Source].[StopOnError],
				[Source].[StopOnWarning],
				[Source].[TaskId],
				[Source].[Type]
			)
		WHEN MATCHED THEN UPDATE SET
			[IICSObjectType] = [Source].[IICSObjectType],
			[IICSTaskType] = [Source].[IICSTaskType],
			[StopOnError] = [Source].[StopOnError],
			[StopOnWarning] = [Source].[StopOnWarning],
			[TaskId] = [Source].[TaskId],
			[Type] = [Source].[Type]
	;
END
GO
CREATE OR ALTER PROCEDURE [IICS].[Process]
AS
BEGIN
	SET NOCOUNT ON
	EXEC [IICS].[ProcessConnections]
	EXEC [IICS].[ProcessSchedules]
	EXEC [IICS].[ProcessMappings]
	EXEC [IICS].[ProcessMappingTasks]
	EXEC [IICS].[ProcessWorkflows]
END
GO
