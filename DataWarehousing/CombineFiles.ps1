Clear-Host;
<#

$outFile = "C:\Users\bmorris\source\repos\bradleydonmorris\StaticDataSets\Dimensions\Times\timesall.txt"

$inFiles = @(Get-ChildItem -Path "C:\Users\bmorris\source\repos\bradleydonmorris\StaticDataSets\Dimensions\Times" -Filter *.tsv)

Get-Content $inFiles[0].FullName -First 1 | Set-Content -Encoding Utf8 -Path $outFile

foreach ($file in $inFiles) {
  Get-Content -Path $file.FullName | Select-Object -Skip 1 | 
    Add-Content -Encoding Utf8 -Path $outFile 
}
#>

Clear-Host;
$outFile = "C:\Users\bmorris\source\repos\bradleydonmorris\StaticDataSets\Dimensions\Dates\datesall.txt"

$inFiles = @(Get-ChildItem -Path "C:\Users\bmorris\source\repos\bradleydonmorris\StaticDataSets\Dimensions\Dates" -Recurse -Filter *.tsv)

Get-Content $inFiles[0].FullName -First 1 | Set-Content -Encoding Utf8 -Path $outFile

foreach ($file in $inFiles) {
  Get-Content -Path $file.FullName | Select-Object -Skip 1 | 
    Add-Content -Encoding Utf8 -Path $outFile 
}
