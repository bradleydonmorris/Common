<#
Clear-Host;

[DateTime] $NowUTC = [DateTime]::UtcNow;
ToDateDouble -dateTime $NowUTC
ToTimeDouble -dateTime $NowUTC
ToDateTimeDouble -dateTime $NowUTC
#>

Function ToDateDouble()
{
    Param
    (
        [DateTime] $dateTime
    )
    [Double] $returnDouble = 0;
    if (![Double]::TryParse($dateTime.ToString("yyyyMMdd"), [ref] $returnDouble))
    {
        throw [ArgumentException]::new("Unable to pasre date to Double/Double.");
    }
    return $returnDouble;
}
<#
		public static Double ToDateDouble(this DateTime dateTime)
		{
			Double returnDouble;
			if (!Double.TryParse(dateTime.ToString("yyyyMMdd"), out returnDouble))
				throw new ArgumentException("Unable to pasre date to Double/Double.");
			return returnDouble;
		}
#>

Function ToTimeDouble()
{
    Param
    (
        [DateTime] $dateTime
    )
    [Double] $returnDouble = 0;
	[TimeSpan] $timeSpan = ($dateTime - ([DateTime]::new($dateTime.Year, $dateTime.Month, $dateTime.Day, 0, 0, 0, 0, $dateTime.Kind)));
    if (![Double]::TryParse(("0." + $timeSpan.TotalMilliseconds.ToString("0000000")), [ref] $returnDouble))
    {
        throw [ArgumentException]::new("Unable to pasre date to Double/Double.");
    }
    return $returnDouble;
}
<#
		public static Double ToTimeDouble(this DateTime dateTime)
		{
			Double returnDouble;
			TimeSpan timeSpan = (dateTime - (new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, 0, 0, 0, 0, dateTime.Kind)));
			if (!Double.TryParse("0." + timeSpan.TotalMilliseconds.ToString("0000000"), out returnDouble))
				throw new ArgumentException("Unable to pasre date to Double.");
			return returnDouble;
		}
#>


Function ToDateTimeDouble()
{
    Param
    (
        [DateTime] $dateTime
    )
    [Double] $returnDouble = 0;
    [Double] $dateDouble = 0;
    [Double] $timeDouble = 0;
    if (![Double]::TryParse($dateTime.ToString("yyyyMMdd"), [ref] $dateDouble))
    {
        throw [ArgumentException]::new("Unable to pasre date to Double/Double.");
    }
	[TimeSpan] $timeSpan = ($dateTime - ([DateTime]::new($dateTime.Year, $dateTime.Month, $dateTime.Day, 0, 0, 0, 0, $dateTime.Kind)));
    if (![Double]::TryParse(($dateDouble.ToString("00000000") + "." + $timeSpan.TotalMilliseconds.ToString("0000000")), [ref] $returnDouble))
    {
        throw [ArgumentException]::new("Unable to pasre date to Double/Double.");
    }
    return $returnDouble;
}

Function Get-ElapsedTime()
{
	Param
	(
        [System.DateTime] $BeginTime,
        [System.DateTime] $EndTime
	)
    [System.Object] $ReturnValue = ConvertFrom-Json -InputObject "{ BeginTime:null, EndTime:null, BeginTicks:null, EndTicks:null, Ticks:null,  DecimalSeconds:null, Formatted:null }";
    [System.TimeSpan] $TimeSpan = [System.TimeSpan]::new($EndTime.Ticks - $BeginTime.Ticks);
    $ReturnValue.DecimalSeconds = $TimeSpan.TotalSeconds;
    $ReturnValue.BeginTime = $BeginTime;
    $ReturnValue.EndTime = $EndTime;
    $ReturnValue.BeginTicks = $BeginTime.Ticks;
    $ReturnValue.EndTicks = $EndTime.Ticks;
    $ReturnValue.Ticks = $TimeSpan.Ticks;
    [System.Double] $DecimalSecondsRemaining = $ReturnValue.DecimalSeconds;
    [System.Int32] $Days = [Int32][System.Math]::Floor($DecimalSecondsRemaining / 86400);
    $DecimalSecondsRemaining -= ($Days * 86400);
    [System.Int32] $Hours = [Int32][System.Math]::Floor($DecimalSecondsRemaining / 3600);
    $DecimalSecondsRemaining -= ($Hours * 3600);
    [System.Int32] $Minutes = [Int32][System.Math]::Floor($DecimalSecondsRemaining / 60);
    $DecimalSecondsRemaining -= ($Minutes * 60);
    [System.String] $ReturnValue.Formatted = "{@Hours}:{@Minutes}:{@Seconds}";
    If ($Days -gt 0)
    {
	    $ReturnValue.Formatted = "{@Days}d " + $ReturnValue.Formatted;
	    $ReturnValue.Formatted = $ReturnValue.Formatted.Replace("{@Days}", $Days.ToString());
    }
    $ReturnValue.Formatted = $ReturnValue.Formatted.Replace("{@Hours}", $Hours.ToString().PadLeft(2, '0'));
    $ReturnValue.Formatted = $ReturnValue.Formatted.Replace("{@Minutes}", $Minutes.ToString().PadLeft(2, '0'));
    $ReturnValue.Formatted = $ReturnValue.Formatted.Replace("{@Seconds}", $DecimalSecondsRemaining.ToString("0.0000000").PadLeft(10, '0'));
    Return $ReturnValue;
}
