Import-Module -Name "SqlServer"
[String] $DatesOutputFile = [IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\StaticDataSets\Dimensions\Dates.tsv");
[String] $Directory = [IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\StaticDataSets\Dimensions\Dates");
[String] $ConnectionString = "Server=localhost;Initial Catalog=master;Persist Security Info=False;Integrated Security=SSPI;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;";
[String] $ConnectionString = "Server=tcp:k9searchok.database.windows.net,1433;Initial Catalog=K9SearchOK;Persist Security Info=False;User ID=k9searchoksa;Password=wpS&YhYh!3d9;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;"
[String] $HeaderLine = "DateKey`tCenturyKey`tYearKey`tSemesterKey`tTrimesterKey`tQuarterKey`tMonthKey`tISOWeekKey`tDate`tCentury`tYear`tSemester`tTrimester`tQuarter`tMonth`tISOWeek`tDateNumber`tCenturyNumber`tYearNumber`tSemesterNumber`tTrimesterNumber`tQuarterNumber`tMonthNumber`tISOWeekNumber`tDayOfYearNumber`tDayOfMonthNumber`tDayOfWeekMonthOccurrenceNumber`tDayOfWeekNumber`tUnixTimestamp`tDateShortName`tDateLongName`tDateMilitary`tCenturyName`tYearName`tSemesterName`tTrimesterName`tQuarterName`tMonthName`tDayOfYearName`tDayOfMonthName`tDayOfWeekMonthOccurrenceName`tDayOfWeekName`tSemesterAbbreviated`tTrimesterAbbreviated`tQuarterAbbreviated`tMonthAbbreviation`tDayOfWeekMonthOccurrenceAbbreviated`tDayOfWeekAbbreviated`tYearSemesterAbbreviated`tYearTrimesterAbbreviated`tYearQuarterAbbreviated`tYearMonthAbbreviation`tYearDayOfYearAbbreviated`tYearSemesterName`tYearTrimesterName`tYearQuarterName`tYearMonthName`tISOWeekName`tISOWeekDay`tWeekSegmentName";

Set-Content -Path $DatesOutputFile -Value $HeaderLine;
[String] $QueryTemplate = [IO.File]::ReadAllText([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\DataWarehousing\Date and Time Dimensions\SQLServer\DatesForYear.sql"));
(1..2500) | ForEach-Object -Process {
    [String] $Query = $QueryTemplate.Replace("{@Year}", $_.ToString());
    $Records = Invoke-Sqlcmd `
        -Query $Query `
        -ConnectionString $ConnectionString;
    [Boolean] $IsFirst = $true;
    ForEach ($Record In $Records)
    {
        [String] $Line = $Record["DateKey"].ToString() + "`t" + $Record["CenturyKey"] + "`t" + $Record["YearKey"] + "`t" + $Record["SemesterKey"] + "`t" + $Record["TrimesterKey"] + "`t" + $Record["QuarterKey"] + "`t" + $Record["MonthKey"] + "`t" + $Record["ISOWeekKey"] +
			"`t" + $Record["Date"] + "`t" + $Record["Century"] + "`t" + $Record["Year"] + "`t" + $Record["Semester"] + "`t" + $Record["Trimester"] + "`t" + $Record["Quarter"] + "`t" + $Record["Month"] + "`t" + $Record["ISOWeek"] +
			"`t" + $Record["DateNumber"] + "`t" + $Record["CenturyNumber"] + "`t" + $Record["YearNumber"] + "`t" + $Record["SemesterNumber"] + "`t" + $Record["TrimesterNumber"] + "`t" + $Record["QuarterNumber"] + "`t" + $Record["MonthNumber"] + "`t" + $Record["ISOWeekNumber"] + "`t" + $Record["DayOfYearNumber"] + "`t" + $Record["DayOfMonthNumber"] + "`t" + $Record["DayOfWeekMonthOccurrenceNumber"] + "`t" + $Record["DayOfWeekNumber"] +
			"`t" + $Record["UnixTimestamp"] +
			"`t" + $Record["DateShortName"] + "`t" + $Record["DateLongName"] + "`t" + $Record["DateMilitary"] + "`t" + $Record["CenturyName"] + "`t" + $Record["YearName"] + "`t" + $Record["SemesterName"] + "`t" + $Record["TrimesterName"] + "`t" + $Record["QuarterName"] + "`t" + $Record["MonthName"] + "`t" + $Record["DayOfYearName"] + "`t" + $Record["DayOfMonthName"] + "`t" + $Record["DayOfWeekMonthOccurrenceName"] + "`t" + $Record["DayOfWeekName"] +
			"`t" + $Record["SemesterAbbreviated"] + "`t" + $Record["TrimesterAbbreviated"] + "`t" + $Record["QuarterAbbreviated"] + "`t" + $Record["MonthAbbreviation"] + "`t" + $Record["DayOfWeekMonthOccurrenceAbbreviated"] + "`t" + $Record["DayOfWeekAbbreviated"] + "`t" + $Record["YearSemesterAbbreviated"] + "`t" + $Record["YearTrimesterAbbreviated"] + "`t" + $Record["YearQuarterAbbreviated"] + "`t" + $Record["YearMonthAbbreviation"] + "`t" + $Record["YearDayOfYearAbbreviated"] +
			"`t" + $Record["YearSemesterName"] + "`t" + $Record["YearTrimesterName"] + "`t" + $Record["YearQuarterName"] + "`t" + $Record["YearMonthName"] + "`t" + $Record["ISOWeekName"] + "`t" + $Record["ISOWeekDay"] + "`t" + $Record["WeekSegmentName"];
        [String] $Year = $_.ToString().PadLeft(4, "0");
        [String] $Century = $Record["CenturyNumber"].ToString().PadLeft(2, "0");
        [String] $OutputDirectory = [IO.Path]::Combine($Directory, "Century_$Century");   
        [String] $OutputFile = [IO.Path]::Combine($OutputDirectory, [String]::Format("{0}.tsv", $Year));
        If ($IsFirst)
        {
            If (![IO.Directory]::Exists($OutputDirectory))
            {
                [void] [IO.Directory]::CreateDirectory($OutputDirectory);
            }
			[void] $Files.Add($OutputFile);
            Set-Content -Path $OutputFile -Value $HeaderLine;
            $IsFirst = $false;
            Write-Host $OutputFile;
        }
        Add-Content -Path $DatesOutputFile -Value $Line;
        Add-Content -Path $OutputFile -Value $Line;
    }
}
