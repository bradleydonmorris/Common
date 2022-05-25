--TRUNCATE TABLE [dbo].[NPSSurveyDailyMediatechRecordStatus]
DECLARE @Date [datetime] = '2022-04-05 23:59:59'
DECLARE @SentOnUTC [datetime] = '1970-01-01 00:00:00'
DECLARE @RowCount [bigint]
	INSERT
		INTO [dbo].[NPSSurveyDailyMediatechRecordStatus]
		(
			[RentalAggreementNumber],
			[SentOnUTC]
		)
		SELECT DISTINCT
			[udv_NPS_Survey].[RA] AS [RentalAggreementNumber],
			@SentOnUTC AS [SentOnUTC]
			FROM [dbo].[udv_NPS_Survey] WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[NPSSurveyDailyMediatechRecordStatus]
					ON [udv_NPS_Survey].[RA] = [NPSSurveyDailyMediatechRecordStatus].[RentalAggreementNumber]
			WHERE
				[udv_NPS_Survey].[Survey_Destination] = 'Europcar Mediatech'
				AND [NPSSurveyDailyMediatechRecordStatus].[SentOnUTC] IS NULL
	SET @RowCount = @@ROWCOUNT
SELECT COUNT(*) AS [InTable], @RowCount AS [InsertedThisTime] FROM [dbo].[NPSSurveyDailyMediatechRecordStatus]

/*
		SELECT COUNT(*)
			--[udv_NPS_Survey].[RA] AS [RentalAggreementNumber],
			--[udv_NPS_Survey].[MaxDATEIN] AS [ChargedCheckInDate],
			--NULL AS [SentOnUTC]
			FROM
			(
				SELECT
					[udv_NPS_Survey].[RA],
					MAX([udv_NPS_Survey].[DATEIN]) AS [MaxDATEIN]
					FROM [dbo].[udv_NPS_Survey]
					WHERE [udv_NPS_Survey].[Survey_Destination] = 'Europcar Mediatech'
					GROUP BY [udv_NPS_Survey].[RA]
			) AS [udv_NPS_Survey]
				LEFT OUTER JOIN [dbo].[NPSSurveyDailyMediatechRecordStatus]
					ON [udv_NPS_Survey].[RA] = [NPSSurveyDailyMediatechRecordStatus].[RentalAggreementNumber]
			WHERE [NPSSurveyDailyMediatechRecordStatus].[SentOnUTC] IS NULL
			ORDER BY [udv_NPS_Survey].[MaxDATEIN] ASC
*/