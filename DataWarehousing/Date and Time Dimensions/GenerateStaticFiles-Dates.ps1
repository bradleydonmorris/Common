Import-Module -Name "SqlServer"
[String] $Delimiter = "|";
[String] $Extension = "psv";
[String] $Directory = [IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\StaticDataSets\Dimensions\Dates");
[String] $ConnectionString = "Server=localhost;Initial Catalog=master;Persist Security Info=False;Integrated Security=SSPI;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;";
[String] $ConnectionString = "Server=tcp:k9searchok.database.windows.net,1433;Initial Catalog=K9SearchOK;Persist Security Info=False;User ID=k9searchoksa;Password=wpS&YhYh!3d9;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;"



If (!$Extension.StartsWith("."))
{
    $Extension = ".$Extension";
}

[String] $HeaderLine = "DateKey|D|CenturyKey|D|YearKey|D|SemesterKey|D|TrimesterKey|D|QuarterKey|D|MonthKey|D|ISOWeekKey|D|Date|D|Century|D|Year|D|Semester|D|Trimester|D|Quarter|D|Month|D|ISOWeek|D|DateNumber|D|CenturyNumber|D|YearNumber|D|SemesterNumber|D|TrimesterNumber|D|QuarterNumber|D|MonthNumber|D|ISOWeekNumber|D|DayOfYearNumber|D|DayOfMonthNumber|D|DayOfWeekMonthOccurrenceNumber|D|DayOfWeekNumber|D|UnixTimestamp|D|DateShortName|D|DateLongName|D|DateMilitary|D|CenturyName|D|YearName|D|SemesterName|D|TrimesterName|D|QuarterName|D|MonthName|D|DayOfYearName|D|DayOfMonthName|D|DayOfWeekMonthOccurrenceName|D|DayOfWeekName|D|SemesterAbbreviated|D|TrimesterAbbreviated|D|QuarterAbbreviated|D|MonthAbbreviation|D|DayOfWeekMonthOccurrenceAbbreviated|D|DayOfWeekAbbreviated|D|YearSemesterAbbreviated|D|YearTrimesterAbbreviated|D|YearQuarterAbbreviated|D|YearMonthAbbreviation|D|YearDayOfYearAbbreviated|D|YearSemesterName|D|YearTrimesterName|D|YearQuarterName|D|YearMonthName|D|ISOWeekName|D|ISOWeekDay|D|WeekSegmentName";
$HeaderLine = $HeaderLine.Replace("|D|", $Delimiter);

[String] $QueryTemplate = [IO.File]::ReadAllText([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\DataWarehousing\Date and Time Dimensions\SQLServer\DatesForYear.sql"));
(2001..2030) | ForEach-Object -Process {
    [String] $Query = $QueryTemplate.Replace("{@Year}", $_.ToString());
    $Records = Invoke-Sqlcmd `
        -Query $Query `
        -ConnectionString $ConnectionString;
    [Boolean] $IsFirst = $true;
    ForEach ($Record In $Records)
    {
        [String] $Line = $Record["DateKey"] + $Delimiter + $Record["CenturyKey"] + $Delimiter + $Record["YearKey"] + $Delimiter + $Record["SemesterKey"] + $Delimiter + $Record["TrimesterKey"] + $Delimiter + $Record["QuarterKey"] + $Delimiter + $Record["MonthKey"] + $Delimiter + $Record["ISOWeekKey"] +
			$Delimiter + $Record["Date"] + $Delimiter + $Record["Century"] + $Delimiter + $Record["Year"] + $Delimiter + $Record["Semester"] + $Delimiter + $Record["Trimester"] + $Delimiter + $Record["Quarter"] + $Delimiter + $Record["Month"] + $Delimiter + $Record["ISOWeek"] +
			$Delimiter + $Record["DateNumber"] + $Delimiter + $Record["CenturyNumber"] + $Delimiter + $Record["YearNumber"] + $Delimiter + $Record["SemesterNumber"] + $Delimiter + $Record["TrimesterNumber"] + $Delimiter + $Record["QuarterNumber"] + $Delimiter + $Record["MonthNumber"] + $Delimiter + $Record["ISOWeekNumber"] + $Delimiter + $Record["DayOfYearNumber"] + $Delimiter + $Record["DayOfMonthNumber"] + $Delimiter + $Record["DayOfWeekMonthOccurrenceNumber"] + $Delimiter + $Record["DayOfWeekNumber"] +
			$Delimiter + $Record["UnixTimestamp"] +
			$Delimiter + $Record["DateShortName"] + $Delimiter + $Record["DateLongName"] + $Delimiter + $Record["DateMilitary"] + $Delimiter + $Record["CenturyName"] + $Delimiter + $Record["YearName"] + $Delimiter + $Record["SemesterName"] + $Delimiter + $Record["TrimesterName"] + $Delimiter + $Record["QuarterName"] + $Delimiter + $Record["MonthName"] + $Delimiter + $Record["DayOfYearName"] + $Delimiter + $Record["DayOfMonthName"] + $Delimiter + $Record["DayOfWeekMonthOccurrenceName"] + $Delimiter + $Record["DayOfWeekName"] +
			$Delimiter + $Record["SemesterAbbreviated"] + $Delimiter + $Record["TrimesterAbbreviated"] + $Delimiter + $Record["QuarterAbbreviated"] + $Delimiter + $Record["MonthAbbreviation"] + $Delimiter + $Record["DayOfWeekMonthOccurrenceAbbreviated"] + $Delimiter + $Record["DayOfWeekAbbreviated"] + $Delimiter + $Record["YearSemesterAbbreviated"] + $Delimiter + $Record["YearTrimesterAbbreviated"] + $Delimiter + $Record["YearQuarterAbbreviated"] + $Delimiter + $Record["YearMonthAbbreviation"] + $Delimiter + $Record["YearDayOfYearAbbreviated"] +
			$Delimiter + $Record["YearSemesterName"] + $Delimiter + $Record["YearTrimesterName"] + $Delimiter + $Record["YearQuarterName"] + $Delimiter + $Record["YearMonthName"] + $Delimiter + $Record["ISOWeekName"] + $Delimiter + $Record["ISOWeekDay"] + $Delimiter + $Record["WeekSegmentName"];
        [String] $Year = $_.ToString().PadLeft(4, "0");
        [String] $Century = $Record["CenturyNumber"].ToString().PadLeft(2, "0");
        [String] $OutputDirectory = [IO.Path]::Combine($Directory, "Century_$Century");   
        [String] $OutputFile = [IO.Path]::ChangeExtension(
            [IO.Path]::Combine(
                $OutputDirectory,
                [String]::Format("{0}.txt", $Year)
            ),
            $Extension
        );
        If ($IsFirst)
        {
            If (![IO.Directory]::Exists($OutputDirectory))
            {
                [void] [IO.Directory]::CreateDirectory($OutputDirectory);
            }
            Set-Content -Path $OutputFile -Value $HeaderLine;
            $IsFirst = $false;
            Write-Host $OutputFile;
        }
        Add-Content -Path $OutputFile -Value $Line;
    }
}

[String] $CombinedFile = [IO.Path]::ChangeExtension([String]::Format("{0}.txt", $Directory), $Extension);
$Files = @(Get-ChildItem -Path $Directory -Filter "*$Extension" -Exclude "Dates$Extension" -Recurse);
Set-Content -Encoding Utf8 -Path $CombinedFile -Value $HeaderLine;

$Files | ForEach-Object -Process {
    Get-Content -Path $_ |
        Select-Object -Skip 1 | 
        Add-Content -Encoding Utf8 -Path $CombinedFile
    ;
}
