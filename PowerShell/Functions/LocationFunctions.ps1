Function Get-SexagesimalAngle()
{
    Param
    (
        [Decimal] $DecimalDegrees
    )
    [Object] $ReturnValue = ConvertFrom-Json -InputObject @"
        {
			IsNegative: false,
            Degrees: 0,
            Minutes: 0,
            Seconds: 0,
            Milliseconds: 0,
            DD: 0.0,
            DMS: ""
        }
"@;
	$ReturnValue.DD = $DecimalDegrees;
	If ($DecimalDegrees -lt 0)
	{
		$ReturnValue.IsNegative = $true;
	}
	Else
	{
		$ReturnValue.IsNegative = $false;
	}
	while ($DecimalDegrees -lt -180.0)
	{
		$DecimalDegrees += 360.0;
	}
	while ($DecimalDegrees -gt 180.0)
	{
		$DecimalDegrees -= 360.0;
	}

	$DecimalDegrees = [Math]::Abs($DecimalDegrees);

	$ReturnValue.Degrees = [Int32][Math]::Floor($DecimalDegrees);
	$delta = $DecimalDegrees - $ReturnValue.Degrees;

	$seconds = [Int32][Math]::Floor(3600.0 * $delta);
	$ReturnValue.Seconds = $seconds % 60;
	$ReturnValue.Minutes = [Int32][Math]::Floor($seconds / 60.0);
	$delta = $delta * 3600.0 - $seconds;

	$ReturnValue.Milliseconds = [Int32](1000.0 * $delta);

	$ReturnValue.DMS = [String]::Format("{0}° {1:00}' {2:00}.{3:000}`"",
		$ReturnValue.Degrees,
		$ReturnValue.Minutes,
		$ReturnValue.Seconds,
		$ReturnValue.Milliseconds);

	Return $ReturnValue;
}

Function Get-LatLongConversions()
{
    Param
    (
        [Decimal] $LatitudeDecimalDegrees,
		[Decimal] $LongitudeDecimalDegrees
    )
    [Object] $ReturnValue = ConvertFrom-Json -InputObject @"
        {
			Latitude: {
				IsNegative: false,
				Degrees: 0,
				Minutes: 0,
				Seconds: 0,
				Milliseconds: 0,
				DD: 0.0,
				DMS: "",
				CardinalDirection: null
			},
            Longitude: {
				IsNegative: false,
				Degrees: 0,
				Minutes: 0,
				Seconds: 0,
				Milliseconds: 0,
				DD: 0.0,
				DMS: "",
				CardinalDirection: null
			}
        }
"@;
	$Lat = Get-SexagesimalAngle -DecimalDegrees $LatitudeDecimalDegrees;
	$ReturnValue.Latitude.IsNegative = $Lat.IsNegative;
	$ReturnValue.Latitude.Degrees = $Lat.Degrees;
	$ReturnValue.Latitude.Minutes = $Lat.Minutes;
	$ReturnValue.Latitude.Seconds = $Lat.Seconds;
	$ReturnValue.Latitude.Milliseconds = $Lat.Milliseconds;
	$ReturnValue.Latitude.DD = $Lat.DD;
	If ($Lat.IsNegative)
	{
		$ReturnValue.Latitude.CardinalDirection = "S";
	}
	Else
	{
		$ReturnValue.Latitude.CardinalDirection = "N";
	}
	$ReturnValue.Latitude.DMS = [String]::Format("{0}° {1:00}' {2:00}.{3:000}`" {4}",
		$ReturnValue.Latitude.Degrees,
		$ReturnValue.Latitude.Minutes,
		$ReturnValue.Latitude.Seconds,
		$ReturnValue.Latitude.Milliseconds,
		$ReturnValue.Latitude.CardinalDirection);

		$Long = Get-SexagesimalAngle -DecimalDegrees $LongitudeDecimalDegrees;
		$ReturnValue.Longitude.IsNegative = $Long.IsNegative;
		$ReturnValue.Longitude.Degrees = $Long.Degrees;
		$ReturnValue.Longitude.Minutes = $Long.Minutes;
		$ReturnValue.Longitude.Seconds = $Long.Seconds;
		$ReturnValue.Longitude.Milliseconds = $Long.Milliseconds;
		$ReturnValue.Longitude.DD = $Long.DD;
		If ($Long.IsNegative)
		{
			$ReturnValue.Longitude.CardinalDirection = "W";
		}
		Else
		{
			$ReturnValue.Longitude.CardinalDirection = "E";
		}
		$ReturnValue.Longitude.DMS = [String]::Format("{0}° {1:00}' {2:00}.{3:000}`" {4}",
			$ReturnValue.Longitude.Degrees,
			$ReturnValue.Longitude.Minutes,
			$ReturnValue.Longitude.Seconds,
			$ReturnValue.Longitude.Milliseconds,
			$ReturnValue.Longitude.CardinalDirection);
	
		Return $ReturnValue;
}


<#

$temp = Get-LatLongConversions -LatitudeDecimalDegrees 35.388588 -LongitudeDecimalDegrees -97.3610230     

$temp.Latitude;
$temp.Longitude;
#>