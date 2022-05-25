USE [Reports_Library]
GO
CREATE OR ALTER VIEW [dbo].[udv_NPS_Survey_Mediatech_Output]
/*  Changes
	Date		Jira Issue	Developer			Comment
	2022-04-05	ITDMP-147	Bradley Morris		Called by IICS Object: Default/Europcar NPS/EuropCar NPS Data
												Returns records to send to Mediatech
*/
AS
	SELECT
		[Cra001].[KNUM] AS [Rental_agreement_number],
		[tblCountries].[Code2] AS [Residence_country_code],
		[Cra001].[LNAME] AS [Surname],
		[Cra001].[FNAME] AS [First_Name],
		CASE
			WHEN [t_api_license].[company_name] = 'GREENWAY'
				THEN [GDS_Locations_Out].[GDS_Code]
			ELSE [Cra001].[LOC_OUT]
		END AS [CO_Station_code],
		FORMAT([Cra001].[DATE_OUT], 'yyyy-MM-dd HH:mm:ss') AS [Charged_Checkout_date],
		CASE
			WHEN [t_api_license].[company_name] = 'GREENWAY'
				THEN [GDS_Locations_In].[GDS_Code]
			ELSE [Cra001].[LOC_IN]
		END AS [CI_Station_code],
		FORMAT([Cra001].[DATE_IN], 'yyyy-MM-dd HH:mm:ss') AS [Charged_Checkin_date],
		[CraRate].[RateCode] AS [Product_Type_Code],
		'' AS [Delivery_Flag],
		'' AS [Collection_Flag],
		'US' AS [CO_Country_Code],
		CASE
			WHEN [t_person].[preferred_language] IS NULL THEN 'EN'
			WHEN [t_person].[preferred_language] = 'ENGLISH' THEN 'EN'
			ELSE [t_person].[preferred_language]
		END AS [Prefered_language],
		[CDetail].[Aoth4] AS [Email],
		[Cfleet01].[Class] AS [SIPP],
		[Cfleet01].[Make],
		'' AS [Model_ID],
		[Cfleet01].[Model],
		CASE
			WHEN [t_api_license].[company_name] = 'GREENWAY'
				THEN 'EP'
			ELSE 'FX'
		END AS [Brand_Code],
		[t_reservation].[partner_confirmation_key] AS [Reservation_number],
		'' AS [CO_Station_Area_Code],
		'' AS [CO_Station_Area],
		'' AS [CO_Station_Region_Code],
		'' AS [CO_Station_Region],
		CASE
			WHEN [CraExtra_Amount_Summed].[Knum] IS NULL
				THEN 'N'
			ELSE 'Y'
		END AS [Upgrade_Flag],
		CASE
			WHEN [Cra001].[FUEL_PP_FLAG] = 1
				THEN 'Y'
			ELSE 'N'
		END AS [FTO_Flag],
		[Cra001].[CHECKED_OUT_BY] AS [CO Agent CODE],
		[Cra001].[CHECKED_IN_BY] AS [CI Agent CODE],
		[Setup].[Name] AS [CO_Station_Name],
		CASE
			WHEN [Cra001].[SOURCE] = 23
				THEN 'Y'
			ELSE 'N'
		END AS [Flag walk-in],
		CASE
			WHEN [Cra001].[LOC_OUT] <> [Cra001].[LOC_IN]
				THEN 'Y'
			ELSE 'N'
		END AS [One-way Flag],
		'' AS [Up-selling Flag],
		'' AS [Down-selling Flag],
		'' AS [Downgrade Flag],
		[cpay].[CO] AS [IDF_CTR_FRN],

		CASE
			WHEN [Cra001].[LOC_OUT] = 'DEN' THEN 'Y'
			WHEN [Cra001].[LOC_OUT] = 'LAX' THEN 'Y'
			WHEN [Cra001].[LOC_OUT] = 'MCO' THEN 'Y'
			WHEN [Cra001].[LOC_OUT] = 'MIA' THEN 'Y'
			WHEN [Cra001].[LOC_OUT] = 'ONT' THEN 'Y'
			WHEN [Cra001].[LOC_OUT] = 'RSW' THEN 'Y'
			WHEN [Cra001].[LOC_OUT] = 'SFO' THEN 'Y'
			WHEN [Cra001].[LOC_OUT] = 'SLC' THEN 'Y'
			WHEN [Cra001].[LOC_OUT] = 'SNA' THEN 'Y'
			WHEN [Cra001].[LOC_OUT] = 'LAS' THEN 'Y'
			ELSE 'N'
		END AS [FLG_SHTTL],
		'D' AS [survey_run_type]
		FROM [42080].[dbo].[Cra001]
			JOIN [42080].[dbo].[CDetail]
				ON [Cra001].[KNUM] = [CDetail].[Knum]
			JOIN [42080].[dbo].[Cemp01] AS [Cemp01_CheckIn]
				ON [Cra001].[CHECKED_IN_BY] = [Cemp01_CheckIn].[EmpID]
			JOIN [42080].[dbo].[Cemp01] AS [Cemp01_CheckOut]
				ON [Cra001].[CHECKED_OUT_BY] = [Cemp01_CheckOut].[EmpID]
			LEFT OUTER JOIN [42080].[dbo].[CraRate] WITH (NOLOCK)
				ON [CraRate].[ID] = [Cra001].[RateID]
			LEFT OUTER JOIN [42080].[dbo].[Cfleet01] WITH (NOLOCK)
				ON [Cfleet01].[Num] = [Cra001].[UNUM]
			LEFT OUTER JOIN [Reports_Library].[dbo].[GDS_Locations] AS [GDS_Locations_Out] WITH (NOLOCK)
				ON [GDS_Locations_Out].[Loc] = [Cra001].[LOC_OUT]
			LEFT OUTER JOIN [Reports_Library].[dbo].[GDS_Locations] AS [GDS_Locations_In] WITH (NOLOCK)
				ON [GDS_Locations_In].[Loc] = [Cra001].[LOC_IN]
			LEFT OUTER JOIN [42080].[dbo].[tblCountries]
				ON [tblCountries].[CountryCode] = [Cra001].[COUNTRY]
			LEFT OUTER JOIN [42080].[dbo].[Setup] WITH (NOLOCK)
				ON [Setup].[Location] = [Cra001].[LOC_OUT]
			LEFT OUTER JOIN [JSI_Reporting].[dbo].[t_reservation]
				ON [t_reservation].[integ_resv_conf_num] = [Cra001].[CONFIRMATION]
			LEFT OUTER JOIN [JSI_Reporting].[dbo].[t_person] WITH (NOLOCK)
				ON [t_person].[person_id] = [t_reservation].[person_id]
			LEFT OUTER JOIN
			(
				SELECT DISTINCT [SB_CraExtra_Amount_Summed_By_Knum_and_Code].[Knum]
					FROM [42080].[dbo].[SB_CraExtra_Amount_Summed_By_Knum_and_Code]
					WHERE
						[SB_CraExtra_Amount_Summed_By_Knum_and_Code].[Code] IN ('UPGRD', 'UPSELL')
						AND [SB_CraExtra_Amount_Summed_By_Knum_and_Code].[Amount] > 0
			) AS [CraExtra_Amount_Summed]
				ON [CraExtra_Amount_Summed].[Knum] = [Cra001].[KNUM]
			LEFT OUTER JOIN [JSI_Reporting].[dbo].[t_api_license]
				ON [t_api_license].[api_license_id] = [t_reservation].[api_license_id]
			LEFT JOIN
			(
				SELECT
					[cpay].[KNUM],
					[cpay].[CO],
					RTRIM(LTRIM([cpay].[CO])) AS [trim_co],
					CASE
						WHEN LEN([cpay].[CO]) < 4
							THEN 'Customer'
						ELSE [cpay].[CO]
					END AS [case_co],
					SUM([cpay].[AMOUNT]) AS [charge_amount],
					SUM
					(
						CASE
							WHEN CHARINDEX('%', [cpay].[DESCRIPTION]) > 0
								THEN [cpay].[AMOUNT]
							ELSE 0
						END
					) AS [tax_amount]
					FROM [42080].[dbo].[cpay] (NOLOCK)
					WHERE
						[cpay].[PAY_CHARGE] = 'C'
						AND LEN([cpay].[CO]) > 4
						AND [cpay].[CO] NOT IN ('01402', '01099')
					GROUP BY
						[cpay].[KNUM],
						[cpay].[CO]
			) AS [cpay]
				ON [cpay].[KNUM] = [Cra001].[KNUM]
		INNER JOIN [dbo].[NPSSurveyMediatechRecordStatus]
			ON [Cra001].[KNUM] = [NPSSurveyMediatechRecordStatus].[RentalAggreementNumber]
		WHERE
			[NPSSurveyMediatechRecordStatus].[SentOnUTC] IS NULL
			AND CAST([Cra001].[DATE_IN] AS [date]) >= '01-Oct-2021'
			AND [CDetail].Aoth4 IS NOT NULL
			AND [CDetail].Aoth4 != ''
			AND [Cra001].KNUM NOT LIKE '%D01'
			AND [Cra001].[TYPE] != 'V'
			AND [Cra001].DBR != 'NON-REV'
GO
CREATE OR ALTER PROCEDURE [dbo].[NPSSurvey_Mediatech_GatherRecordsToSend]
AS
/*  Changes
	Date		Jira Issue	Developer			Comment
	2022-04-05	ITDMP-147	Bradley Morris		Called by IICS Object: Default/Europcar NPS/EuropCar NPS Data
													Called as a Pre SQL task inside the mapping.
												Loads NPSSurveyDailyMediatechRecordStatus with records to send based
												on the records in udv_NPS_Survey that are not currently in the table.
*/
BEGIN
	SET NOCOUNT ON
	INSERT
		INTO [dbo].[NPSSurveyMediatechRecordStatus]
		(
			[RentalAggreementNumber],
			[CheckInDate],
			[SentOnUTC]
		)
		SELECT
			[NPSSurveyMediatechRecord].[RentalAggreementNumber],
			[NPSSurveyMediatechRecord].[CheckInDate],
			NULL AS [SentOnUTC]
			FROM
			(
				SELECT DISTINCT
					[Cra001].[KNUM] AS [RentalAggreementNumber],
					[Cra001].[DATE_IN] AS [CheckInDate]
					FROM [42080].[dbo].[Cra001]
						JOIN [42080].[dbo].[CDetail]
							ON [Cra001].[KNUM] = [CDetail].[Knum]
						JOIN [42080].[dbo].[Cemp01] AS [Cemp01_CheckIn]
							ON [Cra001].[CHECKED_IN_BY] = [Cemp01_CheckIn].[EmpID]
						JOIN [42080].[dbo].[Cemp01] AS [Cemp01_CheckOut]
							ON [Cra001].[CHECKED_OUT_BY] = [Cemp01_CheckOut].[EmpID]
						LEFT OUTER JOIN [42080].[dbo].[CraRate] WITH (NOLOCK)
							ON [CraRate].[ID] = [Cra001].[RateID]
						LEFT OUTER JOIN [42080].[dbo].[Cfleet01] WITH (NOLOCK)
							ON [Cfleet01].[Num] = [Cra001].[UNUM]
						LEFT OUTER JOIN [Reports_Library].[dbo].[GDS_Locations] AS [GDS_Locations_Out] WITH (NOLOCK)
							ON [GDS_Locations_Out].[Loc] = [Cra001].[LOC_OUT]
						LEFT OUTER JOIN [Reports_Library].[dbo].[GDS_Locations] AS [GDS_Locations_In] WITH (NOLOCK)
							ON [GDS_Locations_In].[Loc] = [Cra001].[LOC_IN]
						LEFT OUTER JOIN [42080].[dbo].[tblCountries]
							ON [tblCountries].[CountryCode] = [Cra001].[COUNTRY]
						LEFT OUTER JOIN [42080].[dbo].[Setup] WITH (NOLOCK)
							ON [Setup].[Location] = [Cra001].[LOC_OUT]
						LEFT OUTER JOIN [JSI_Reporting].[dbo].[t_reservation]
							ON [t_reservation].[integ_resv_conf_num] = [Cra001].[CONFIRMATION]
						LEFT OUTER JOIN [JSI_Reporting].[dbo].[t_person] WITH (NOLOCK)
							ON [t_person].[person_id] = [t_reservation].[person_id]
						LEFT OUTER JOIN
						(
							SELECT DISTINCT [SB_CraExtra_Amount_Summed_By_Knum_and_Code].[Knum]
								FROM [42080].[dbo].[SB_CraExtra_Amount_Summed_By_Knum_and_Code]
								WHERE
									[SB_CraExtra_Amount_Summed_By_Knum_and_Code].[Code] IN ('UPGRD', 'UPSELL')
									AND [SB_CraExtra_Amount_Summed_By_Knum_and_Code].[Amount] > 0
						) AS [CraExtra_Amount_Summed]
							ON [CraExtra_Amount_Summed].[Knum] = [Cra001].[KNUM]
						LEFT OUTER JOIN [JSI_Reporting].[dbo].[t_api_license]
							ON [t_api_license].[api_license_id] = [t_reservation].[api_license_id]
						LEFT JOIN
						(
							SELECT
								[cpay].[KNUM],
								[cpay].[CO],
								RTRIM(LTRIM([cpay].[CO])) AS [trim_co],
								CASE
									WHEN LEN([cpay].[CO]) < 4
										THEN 'Customer'
									ELSE [cpay].[CO]
								END AS [case_co],
								SUM([cpay].[AMOUNT]) AS [charge_amount],
								SUM
								(
									CASE
										WHEN CHARINDEX('%', [cpay].[DESCRIPTION]) > 0
											THEN [cpay].[AMOUNT]
										ELSE 0
									END
								) AS [tax_amount]
								FROM [42080].[dbo].[cpay] (NOLOCK)
								WHERE
									[cpay].[PAY_CHARGE] = 'C'
									AND LEN([cpay].[CO]) > 4
									AND [cpay].[CO] NOT IN ('01402', '01099')
								GROUP BY
									[cpay].[KNUM],
									[cpay].[CO]
						) AS [cpay]
							ON [cpay].[KNUM] = [Cra001].[KNUM]
					WHERE
						CAST([Cra001].[DATE_IN] AS [date]) >= '01-Oct-2021'
						AND [CDetail].Aoth4 IS NOT NULL
						AND [CDetail].Aoth4 != ''
						AND [Cra001].KNUM NOT LIKE '%D01'
						AND [Cra001].[TYPE] != 'V'
						AND [Cra001].DBR != 'NON-REV'
			) AS [NPSSurveyMediatechRecord]
				LEFT OUTER JOIN [NPSSurveyMediatechRecordStatus]
					ON [NPSSurveyMediatechRecord].[RentalAggreementNumber] = [NPSSurveyMediatechRecordStatus].[RentalAggreementNumber]
			WHERE [NPSSurveyMediatechRecordStatus].[RentalAggreementNumber] IS NULL
END
GO
CREATE OR ALTER PROCEDURE [dbo].[NPSSurvey_Mediatech_MarkRecordsSent]
AS
/*  Changes
	Date		Jira Issue	Developer			Comment
	2022-04-05	ITDMP-147	Bradley Morris		Called by IICS Object: Default/Europcar NPS/EuropCar NPS Data
													Called as a Post SQL task inside the mapping.
												Sets the SentOnUTC datetime field so that the records will
												not be pulled again by udv_NPS_Survey_Mediatech_ToSend
*/
BEGIN
	SET NOCOUNT ON
	DECLARE @SentOn [datetime2](7) = SYSUTCDATETIME()
	UPDATE [dbo].[NPSSurveyMediatechRecordStatus]
		SET [SentOnUTC] = @SentOn
		WHERE [SentOnUTC] IS NULL
END
GO
/*
--Pre SQL
EXEC [Reports_Library].[dbo].[NPSSurvey_Mediatech_GatherRecordsToSend]

--Source Query
SELECT * FROM [dbo].[udv_NPS_Survey_Mediatech_Output]

--Post SQL
EXEC [Reports_Library].[dbo].[NPSSurvey_Mediatech_MarkRecordsSent]
*/
--
--SELECT * FROM [dbo].[NPSSurveyDailyMediatechRecordStatus]