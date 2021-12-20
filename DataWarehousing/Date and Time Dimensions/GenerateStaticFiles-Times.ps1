Import-Module -Name "SqlServer"
[String] $Directory = [IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\StaticDataSets\Dimensions\Times");
[String] $ConnectionString = "Server=localhost;Initial Catalog=master;Persist Security Info=False;Integrated Security=SSPI;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;";
[String] $QueryTemplate = @"
SET DATEFIRST 1
DECLARE @Hour [int] = {@Hour}

DECLARE @BeginTime [datetime] = DATETIMEFROMPARTS(1900, 1, 1, @Hour, 0, 0, 0)
DECLARE @EndTime [datetime] = DATETIMEFROMPARTS(1900, 1, 1, @Hour, 59, 59, 0)

;WITH
	[Time]
	(
		[Time]
	)
	AS
	(
		SELECT
			[Time].[Time]
			FROM
			(
				SELECT @BeginTime AS [Time]
			) AS [Time]

		UNION ALL
		SELECT
			[Time].[Time]
			FROM
			(
				SELECT DATEADD([SECOND], 1, [Time].[Time]) AS [Time]
					FROM [Time]
			) AS [Time]
			WHERE [Time].[Time] <= @EndTime
	)
		SELECT
			FORMAT([Time].[Time], 'HH:mm:ss') AS [Time],
			CONVERT([int], FORMAT([Time].[Time], 'HHmmss'), 0) AS [TimeKey],
			CONVERT([int], FORMAT([Time].[Time], 'HHmmss'), 0) AS [TimeNumber],
			FORMAT([Time].[Time], 'HH:mm:ss') AS [TimeName],

			FORMAT([Time].[Hour], 'HH:mm:ss') AS [Hour],
			CONVERT([int], FORMAT([Time].[Hour], 'HHmmss'), 0) AS [HourKey],
			[Time].[HourNumber],
			FORMAT([Time].[Hour], 'HH:mm:ss') AS [HourName],

			FORMAT([Time].[HalfHour], 'HH:mm:ss') AS [HalfHour],
			CONVERT([int], FORMAT([Time].[HalfHour], 'HHmmss'), 0) AS [HalfHourKey],
			[Time].[HalfHourNumber],
			FORMAT([Time].[HalfHour], 'HH:mm:ss') AS [HalfHourName],

			FORMAT([Time].[QuarterHour], 'HH:mm:ss') AS [QuarterHour],
			CONVERT([int], FORMAT([Time].[QuarterHour], 'HHmmss'), 0) AS [QuarterHourKey],
			[Time].[QuarterHourNumber],
			FORMAT([Time].[QuarterHour], 'HH:mm:ss') AS [QuarterHourName],

			FORMAT([Time].[Minute], 'HH:mm:ss') AS [Minute],
			CONVERT([int], FORMAT([Time].[Minute], 'HHmmss'), 0) AS [MinuteKey],
			[Time].[MinuteNumber],
			FORMAT([Time].[Minute], 'HH:mm:ss') AS [MinuteName],

			FORMAT([Time].[TimeOfDay], 'HH:mm:ss') AS [TimeOfDay],
			CONVERT([int], FORMAT([Time].[TimeOfDay], 'HHmmss'), 0) AS [TimeOfDayKey],
			[Time].[TimeOfDayNumber],
			FORMAT([Time].[TimeOfDay], 'HH:mm:ss') AS [TimeOfDayName],

			FORMAT([Time].[SubTimeOfDay], 'HH:mm:ss') AS [SubTimeOfDay],
			CONVERT([int], FORMAT([Time].[SubTimeOfDay], 'HHmmss'), 0) AS [SubTimeOfDayKey],
			[Time].[SubTimeOfDayNumber],
			FORMAT([Time].[SubTimeOfDay], 'HH:mm:ss') AS [SubTimeOfDayName]

			FROM
			(
				SELECT
					[Time].[Time],

					DATETIMEFROMPARTS(1900, 1, 1, [Time].[HourNumber], 0, 0, 0) AS [Hour],
					[Time].[HourNumber] AS [HourNumber],

					CASE
						WHEN [Time].[MinuteNumber] BETWEEN 0 AND 29
							THEN DATETIMEFROMPARTS(1900, 1, 1, [Time].[HourNumber], 0, 0, 0)
						WHEN [Time].[MinuteNumber] BETWEEN 30 AND 59
							THEN DATETIMEFROMPARTS(1900, 1, 1, [Time].[HourNumber], 30, 0, 0)
					END AS [HalfHour],
					CASE
						WHEN [Time].[MinuteNumber] BETWEEN 0 AND 29
							THEN 1
						WHEN [Time].[MinuteNumber] BETWEEN 30 AND 59
							THEN 2
					END AS [HalfHourNumber],

					CASE
						WHEN [Time].[MinuteNumber] BETWEEN 0 AND 14
							THEN DATETIMEFROMPARTS(1900, 1, 1, [Time].[HourNumber], 0, 0, 0)
						WHEN [Time].[MinuteNumber] BETWEEN 15 AND 29
							THEN DATETIMEFROMPARTS(1900, 1, 1, [Time].[HourNumber], 15, 0, 0)
						WHEN [Time].[MinuteNumber] BETWEEN 30 AND 44
							THEN DATETIMEFROMPARTS(1900, 1, 1, [Time].[HourNumber], 30, 0, 0)
						WHEN [Time].[MinuteNumber] BETWEEN 45 AND 59
							THEN DATETIMEFROMPARTS(1900, 1, 1, [Time].[HourNumber], 45, 0, 0)
					END AS [QuarterHour],
					CASE
						WHEN [Time].[MinuteNumber] BETWEEN 0 AND 14
							THEN 1
						WHEN [Time].[MinuteNumber] BETWEEN 15 AND 29
							THEN 2
						WHEN [Time].[MinuteNumber] BETWEEN 30 AND 44
							THEN 3
						WHEN [Time].[MinuteNumber] BETWEEN 45 AND 59
							THEN 4
					END AS [QuarterHourNumber],

					DATETIMEFROMPARTS(1900, 1, 1, [Time].[HourNumber], [Time].[MinuteNumber], 0, 0) AS [Minute],
					[Time].[MinuteNumber],

					CASE
						WHEN [Time].[HourNumber] BETWEEN 0 AND 4
							THEN DATETIMEFROMPARTS(1900, 1, 1, 0, 0, 0, 0)
						WHEN [Time].[HourNumber] BETWEEN 5 AND 11
							THEN DATETIMEFROMPARTS(1900, 1, 1, 5, 0, 0, 0)
						WHEN [Time].[HourNumber] BETWEEN 12 AND 17
							THEN DATETIMEFROMPARTS(1900, 1, 1, 12, 0, 0, 0)
						WHEN [Time].[HourNumber] BETWEEN 18 AND 23
							THEN DATETIMEFROMPARTS(1900, 1, 1, 18, 0, 0, 0)
					END AS [TimeOfDay],
					CASE
						WHEN [Time].[HourNumber] BETWEEN 0 AND 4
							THEN 0
						WHEN [Time].[HourNumber] BETWEEN 5 AND 11
							THEN 5
						WHEN [Time].[HourNumber] BETWEEN 12 AND 17
							THEN 12
						WHEN [Time].[HourNumber] BETWEEN 18 AND 23
							THEN 18
					END AS [TimeOfDayNumber],

					CASE
						WHEN [Time].[HourNumber] BETWEEN 0 AND 4
							THEN DATETIMEFROMPARTS(1900, 1, 1, 0, 0, 0, 0)
						WHEN [Time].[HourNumber] BETWEEN 5 AND 9
							THEN DATETIMEFROMPARTS(1900, 1, 1, 5, 0, 0, 0)
						WHEN [Time].[HourNumber] BETWEEN 10 AND 11
							THEN DATETIMEFROMPARTS(1900, 1, 1, 10, 0, 0, 0)
						WHEN [Time].[HourNumber] BETWEEN 12 AND 14
							THEN DATETIMEFROMPARTS(1900, 1, 1, 12, 0, 0, 0)
						WHEN [Time].[HourNumber] BETWEEN 15 AND 17
							THEN DATETIMEFROMPARTS(1900, 1, 1, 15, 0, 0, 0)
						WHEN [Time].[HourNumber] BETWEEN 18 AND 19
							THEN DATETIMEFROMPARTS(1900, 1, 1, 18, 0, 0, 0)
						WHEN [Time].[HourNumber] BETWEEN 20 AND 23
							THEN DATETIMEFROMPARTS(1900, 1, 1, 20, 0, 0, 0)
					END AS [SubTimeOfDay],
					CASE
						WHEN [Time].[HourNumber] BETWEEN 0 AND 4
							THEN 1
						WHEN [Time].[HourNumber] BETWEEN 5 AND 9
							THEN 2
						WHEN [Time].[HourNumber] BETWEEN 10 AND 11
							THEN 3
						WHEN [Time].[HourNumber] BETWEEN 12 AND 14
							THEN 4
						WHEN [Time].[HourNumber] BETWEEN 15 AND 17
							THEN 5
						WHEN [Time].[HourNumber] BETWEEN 18 AND 19
							THEN 6
						WHEN [Time].[HourNumber] BETWEEN 20 AND 23
							THEN 7
					END AS [SubTimeOfDayNumber]

					FROM
					(
						SELECT
							[Time].[Time],
							DATEPART([HOUR], [Time].[Time]) AS [HourNumber],
							DATEPART([MINUTE], [Time].[Time]) AS [MinuteNumber]
							FROM [Time]
					) AS [Time]
			) AS [Time]
		ORDER BY [Time].[Time] ASC
		OPTION (MAXRECURSION 32767);
"@


If (![IO.Directory]::Exists($Directory))
{
    [void] [IO.Directory]::CreateDirectory($Directory);
}
(0..23) | ForEach-Object -Process {
    
    [String] $Query = $QueryTemplate.Replace("{@Hour}", $_.ToString());
    $Records = Invoke-Sqlcmd `
        -Query $Query `
        -ConnectionString $ConnectionString;
    [Boolean] $IsFirst = $true;
    ForEach ($Record In $Records)
    {
        [String] $Line = $Record["Time"] + "`t" + $Record["TimeKey"] + "`t" + $Record["TimeNumber"] + "`t" + $Record["TimeName"] + "`t" +
            $Record["Hour"] + "`t" + $Record["HourKey"] + "`t" + $Record["HourNumber"] + "`t" + $Record["HourName"] + "`t" +
            $Record["HalfHour"] + "`t" + $Record["HalfHourKey"] + "`t" + $Record["HalfHourNumber"] + "`t" + $Record["HalfHourName"] + "`t" +
            $Record["QuarterHour"] + "`t" + $Record["QuarterHourKey"] + "`t" + $Record["QuarterHourNumber"] + "`t" + $Record["QuarterHourName"] + "`t" +
            $Record["Minute"] + "`t" + $Record["MinuteKey"] + "`t" + $Record["MinuteNumber"] + "`t" + $Record["MinuteName"] + "`t" +
            $Record["TimeOfDay"] + "`t" + $Record["TimeOfDayKey"] + "`t" + $Record["TimeOfDayNumber"] + "`t" + $Record["TimeOfDayName"] + "`t" +
            $Record["SubTimeOfDay"] + "`t" + $Record["SubTimeOfDayKey"] + "`t" + $Record["SubTimeOfDayNumber"] + "`t" + $Record["SubTimeOfDayName"];

        [String] $Hour = $_.ToString().PadLeft(2, "0");
        [String] $OutputFile = [IO.Path]::Combine($Directory, [String]::Format("{0}.tsv", $Hour));
        If ($IsFirst)
        {
            Set-Content -Path $OutputFile -Value "Time`tTimeKey`tTimeNumber`tTimeName`tHour`tHourKey`tHourNumber`tHourName`tHalfHour`tHalfHourKey`tHalfHourNumber`tHalfHourName`tQuarterHour`tQuarterHourKey`tQuarterHourNumber`tQuarterHourName`tMinute`tMinuteKey`tMinuteNumber`tMinuteName`tTimeOfDay`tTimeOfDayKey`tTimeOfDayNumber`tTimeOfDayName`tSubTimeOfDay`tSubTimeOfDayKey`tSubTimeOfDayNumber`tSubTimeOfDayName";
            $IsFirst = $false;
            Write-Host $OutputFile;
        }
        Add-Content -Path $OutputFile -Value $Line;
    }
}