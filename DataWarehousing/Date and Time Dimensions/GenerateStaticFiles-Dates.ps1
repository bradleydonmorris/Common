Import-Module -Name "SqlServer"
[String] $Directory = [IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\StaticDataSets\Dimensions\Dates");
[String] $ConnectionString = "Server=localhost;Initial Catalog=master;Persist Security Info=False;Integrated Security=SSPI;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;";
[String] $QueryTemplate = @"
SET DATEFIRST 1
DECLARE @Year [int] = {@Year}

DECLARE @BeginDate [date] = DATEFROMPARTS(@Year, 1, 1)
DECLARE @EndDate [date] = DATEFROMPARTS(@Year, 12, 31)

;WITH
	[Date]
	(
		[Date]
	)
	AS
	(
		SELECT
			[Date].[Date]
			FROM
			(
				SELECT @BeginDate AS [Date]
			) AS [Date]

		UNION ALL
		SELECT
			[Date].[Date]
			FROM
			(
				SELECT DATEADD([DAY], 1, [Date].[Date]) AS [Date]
					FROM [Date]
			) AS [Date]
			WHERE [Date].[Date] <= @EndDate
	)
	SELECT
		FORMAT([Date].[Date], 'yyyy-MM-dd') AS [Date],
		CONVERT([int], FORMAT([Date].[Date], 'yyyyMMdd'), 0) AS [DateKey],
		CONVERT([int], FORMAT([Date].[Date], 'yyyyMMdd'), 0) AS [DateNumber],
		FORMAT([Date].[Date], 'yyyy-MM-dd') AS [DateName],

		FORMAT([Date].[Century], 'yyyy-MM-dd') AS [Century],
		CONVERT([int], FORMAT([Date].[Century], 'yyyyMMdd'), 0) AS [CenturyKey],
		[Date].[CenturyNumber],
		(
			FORMAT([Date].[CenturyNumber], '0')
			+
			CASE
				WHEN [Date].[CenturyNumber] IN (11, 12, 13)
					THEN 'th'
				WHEN RIGHT(FORMAT([Date].[CenturyNumber], '0'), 1) = '1'
					THEN 'st'
				WHEN RIGHT(FORMAT([Date].[CenturyNumber], '0'), 1) = '2'
					THEN 'nd'
				WHEN RIGHT(FORMAT([Date].[CenturyNumber], '0'), 1) = '3'
					THEN 'rd'
				ELSE 'th'
			END
		) AS [CenturyName],
			
		FORMAT([Date].[Year], 'yyyy-MM-dd') AS [Year],
		CONVERT([int], FORMAT([Date].[Year], 'yyyyMMdd'), 0) AS [YearKey],
		CONVERT([int], FORMAT([Date].[Year], 'yyyy'), 0) AS [YearNumber],
		FORMAT([Date].[Year], 'yyyy-MM-dd') AS [YearName],

		FORMAT([Date].[Semester], 'yyyy-MM-dd') AS [Semester],
		CONVERT([int], FORMAT([Date].[Semester], 'yyyyMMdd'), 0) AS [SemesterKey],
		[Date].[SemesterNumber],
		FORMAT([Date].[Semester], 'yyyy-MM-dd') AS [SemesterName],

		FORMAT([Date].[Trimester], 'yyyy-MM-dd') AS [Trimester],
		CONVERT([int], FORMAT([Date].[Trimester], 'yyyyMMdd'), 0) AS [TrimesterKey],
		[Date].[TrimesterNumber],
		FORMAT([Date].[Trimester], 'yyyy-MM-dd') AS [TrimesterName],

		FORMAT([Date].[Quarter], 'yyyy-MM-dd') AS [Quarter],
		CONVERT([int], FORMAT([Date].[Quarter], 'yyyyMMdd'), 0) AS [QuarterKey],
		[Date].[QuarterNumber],
		FORMAT([Date].[Quarter], 'yyyy-MM-dd') AS [QuarterName],

		FORMAT([Date].[Month], 'yyyy-MM-dd') AS [Month],
		CONVERT([int], FORMAT([Date].[Month], 'yyyyMMdd'), 0) AS [MonthKey],
		MONTH([Date].[Month]) AS [MonthNumber],
		FORMAT([Date].[Month], 'yyyy-MM-dd') AS [MonthName],

		FORMAT([Date].[ISOWeek], 'yyyy-MM-dd') AS [ISOWeek],
		CONVERT([int], FORMAT([Date].[ISOWeek], 'yyyyMMdd'), 0) AS [ISOWeekKey],
		[Date].[ISOWeekNumber],
		CONCAT(FORMAT([Date].[ISOWeek], 'yyyy'), '-W', FORMAT([Date].[ISOWeekNumber], '00')) AS [ISOWeekName],

		FORMAT([Date].[Date], 'dddd') AS [DayOfWeekName],
		FORMAT(DATEPART([DAYOFYEAR], [Date].[Date]), '000') AS [DayOfYearName],
		FORMAT(DAY([Date].[Date]), '00') AS [DayOfMonthName]

		FROM
		(
			SELECT
				[Date].[Date],

				DATEFROMPARTS
				(
					CONVERT
					(
						[int],
						CONCAT
						(
							FORMAT(((YEAR([Date].[Date]) - 1) / 100), '00'),
							'01'
						),
						1
					),
					1,
					1
				) AS [Century],

				(1 + (YEAR([Date].[Date]) - 1) / 100) AS [CenturyNumber],


				DATEFROMPARTS(YEAR([Date].[Date]), 1, 1) AS [Year],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 6
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 1, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 7 AND 12
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 7, 1)
				END AS [Semester],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 6
						THEN 1
					WHEN MONTH([Date].[Date]) BETWEEN 7 AND 12
						THEN 2
				END AS [SemesterNumber],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 4
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 1, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 5 AND 8
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 5, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 9 AND 12
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 9, 1)
				END AS [Trimester],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 4
						THEN 1
					WHEN MONTH([Date].[Date]) BETWEEN 5 AND 8
						THEN 2
					WHEN MONTH([Date].[Date]) BETWEEN 9 AND 12
						THEN 3
				END AS [TrimesterNumber],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 3
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 1, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 4 AND 6
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 4, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 7 AND 9
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 6, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 10 AND 12
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 10, 1)
				END AS [Quarter],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 3
						THEN 1
					WHEN MONTH([Date].[Date]) BETWEEN 4 AND 6
						THEN 2
					WHEN MONTH([Date].[Date]) BETWEEN 7 AND 9
						THEN 3
					WHEN MONTH([Date].[Date]) BETWEEN 10 AND 12
						THEN 4
				END AS [QuarterNumber],
				DATEFROMPARTS(YEAR([Date].[Date]), MONTH([Date].[Date]), 1) AS [Month],

				CASE
					WHEN [Date].[Date] > '0001-01-06'
						THEN
							CASE DATEPART([ISO_WEEK], [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -6, [Date].[Date])) THEN DATEADD([DAY], -6, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -5, [Date].[Date])) THEN DATEADD([DAY], -5, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -4, [Date].[Date])) THEN DATEADD([DAY], -4, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -3, [Date].[Date])) THEN DATEADD([DAY], -3, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -2, [Date].[Date])) THEN DATEADD([DAY], -2, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -1, [Date].[Date])) THEN DATEADD([DAY], -1, [Date].[Date])
								ELSE DATEADD([DAY],  0, [Date].[Date])
							END
						ELSE '0001-01-01'
				END AS [ISOWeek],
				DATEPART([ISO_WEEK], [Date].[Date]) AS [ISOWeekNumber]
				FROM [Date]
		) AS [Date]
        ORDER BY [Date].[DateKey]
		OPTION (MAXRECURSION 32767)
"@

(1..2500) | ForEach-Object -Process {
    [String] $Query = $QueryTemplate.Replace("{@Year}", $_.ToString());
    $Records = Invoke-Sqlcmd `
        -Query $Query `
        -ConnectionString $ConnectionString;
    [Boolean] $IsFirst = $true;
    ForEach ($Record In $Records)
    {
        [String] $Line = $Record["Date"] + "`t" + $Record["DateKey"] + "`t" + $Record["DateNumber"] + "`t" + $Record["DateName"] + "`t" +
            $Record["Century"] + "`t" + $Record["CenturyKey"] + "`t" + $Record["CenturyNumber"] + "`t" + $Record["CenturyName"] + "`t" +
            $Record["Year"] + "`t" + $Record["YearKey"] + "`t" + $Record["YearNumber"] + "`t" + $Record["YearName"] + "`t" +
            $Record["Semester"] + "`t" + $Record["SemesterKey"] + "`t" + $Record["SemesterNumber"] + "`t" + $Record["SemesterName"] + "`t" +
            $Record["Trimester"] + "`t" + $Record["TrimesterKey"] + "`t" + $Record["TrimesterNumber"] + "`t" + $Record["TrimesterName"] + "`t" +
            $Record["Quarter"] + "`t" + $Record["QuarterKey"] + "`t" + $Record["QuarterNumber"] + "`t" + $Record["QuarterName"] + "`t" +
            $Record["Month"] + "`t" + $Record["MonthKey"] + "`t" + $Record["MonthNumber"] + "`t" + $Record["MonthName"] + "`t" +
            $Record["ISOWeek"] + "`t" + $Record["ISOWeekKey"] + "`t" + $Record["ISOWeekNumber"] + "`t" + $Record["ISOWeekName"] + "`t" +
            $Record["DayOfWeekName"] + "`t" + $Record["DayOfYearName"] + "`t" + $Record["DayOfMonthName"];
        [String] $Year = $_.ToString().PadLeft(4, "0");
        [String] $Century = $Record["CenturyNumber"].ToString().PadLeft(2, "0");
        [String] $OutputDirectory = [IO.Path]::Combine($Directory, $Century);   
        [String] $OutputFile = [IO.Path]::Combine($OutputDirectory, [String]::Format("{0}.tsv", $Year));
        If ($IsFirst)
        {
            If (![IO.Directory]::Exists($OutputDirectory))
            {
                [void] [IO.Directory]::CreateDirectory($OutputDirectory);
            }
            Set-Content -Path $OutputFile -Value "Date`tDateKey`tDateNumber`tDateName`tCentury`tCenturyKey`tCenturyNumber`tCenturyName`tYear`tYearKey`tYearNumber`tYearName`tSemester`tSemesterKey`tSemesterNumber`tSemesterName`tTrimester`tTrimesterKey`tTrimesterNumber`tTrimesterName`tQuarter`tQuarterKey`tQuarterNumber`tQuarterName`tMonth`tMonthKey`tMonthNumber`tMonthName`tISOWeek`tISOWeekKey`tISOWeekNumber`tISOWeekName`tDayOfWeekName`tDayOfYearName`tDayOfMonthName";
            $IsFirst = $false;
            Write-Host $OutputFile;
        }
        Add-Content -Path $OutputFile -Value $Line;
    }
}