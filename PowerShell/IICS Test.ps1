$Session = Get-IICSv2Session -UserName "bmorris@foxrentacar.com" -Password "1BluePipe$";


[String] $Directory = "C:\Users\bmorris\Documents\IICS\JSONDump\Connections";
If ([System.IO.Directory]::Exists($Directory))
{
    Remove-Item -Path $Directory -Recurse -Force;
}
If (![System.IO.Directory]::Exists($Directory))
{
    [void] [System.IO.Directory]::CreateDirectory($Directory);
}
$Connections = (
                    Get-IICSv2Connections -Session $Session |
                        ConvertFrom-Json -Depth 100
);
$Connections |
    ConvertTo-Json -Depth 100 |
    Out-File -FilePath ($Directory + ".json");

ForEach ($Connection In $Connections)
{
    [String] $OutFilePath = $Directory + "\" + $Connection.id + ".json"
    Try
    {
        Get-IICSv2Connection -Session $Session -Id $MappingTask.id |
            ConvertFrom-Json -Depth 100 |
            ConvertTo-Json -Depth 100 |
            Out-File -FilePath $OutFilePath;
    }
    catch
    {
        $_.Exception |
            ConvertTo-Json |
            Out-File -FilePath $OutFilePath;
    }
}

<#
$Mappings = (
                    Get-IICSv2Mappings -Session $Session |
                        ConvertFrom-Json -Depth 100
);
$Mappings |
    ConvertTo-Json -Depth 100 |
    Out-File -FilePath "C:\Users\bmorris\Documents\IICS\JSONDump\Mappings.json";

ForEach ($Mapping In $Mappings)
{
    [String] $OutFilePath = "C:\Users\bmorris\Documents\IICS\JSONDump\Mappings\" + $Mapping.id + ".json"
    Try
    {
        Get-IICSv2Mapping -Session $Session -Id $Mapping.id |
            ConvertFrom-Json -Depth 100 |
            ConvertTo-Json -Depth 100 |
            Out-File -FilePath $OutFilePath;
    }
    catch
    {
        $_.Exception.Message |
            Out-File -FilePath ([System.IO.Path]::ChangeExtension($OutFilePath, ".exception.txt"));
    }
}

$MappingTasks = (
                    Get-IICSv2MappingTasks -Session $Session |
                        ConvertFrom-Json -Depth 100
);
$MappingTasks |
    ConvertTo-Json -Depth 100 |
    Out-File -FilePath "C:\Users\bmorris\Documents\IICS\JSONDump\MappingTasks.json";

ForEach ($MappingTask In $MappingTasks)
{
    [String] $OutFilePath = "C:\Users\bmorris\Documents\IICS\JSONDump\MappingTasks\" + $MappingTask.id + ".json"
    Try
    {
        Get-IICSv2MappingTask -Session $Session -Id $MappingTask.id |
            ConvertFrom-Json -Depth 100 |
            ConvertTo-Json -Depth 100 |
            Out-File -FilePath $OutFilePath;
    }
    catch
    {
        $_.Exception.Message |
            Out-File -FilePath ([System.IO.Path]::ChangeExtension($OutFilePath, ".exception.txt"));
    }
}

$Workflows = (
                    Get-IICSv2Workflows -Session $Session |
                        ConvertFrom-Json -Depth 100
);
$Workflows |
    ConvertTo-Json -Depth 100 |
    Out-File -FilePath "C:\Users\bmorris\Documents\IICS\JSONDump\Workflows.json";

ForEach ($Workflow In $Workflows)
{
    [String] $OutFilePath = "C:\Users\bmorris\Documents\IICS\JSONDump\Workflows\" + $Workflow.id + ".json"
    Try
    {
        Get-IICSv2Workflow -Session $Session -Id $Workflow.id |
            ConvertFrom-Json -Depth 100 |
            ConvertTo-Json -Depth 100 |
            Out-File -FilePath $OutFilePath;
    }
    catch
    {
        $_.Exception.Message |
            Out-File -FilePath ([System.IO.Path]::ChangeExtension($OutFilePath, ".exception.txt"));
    }
}
$Schedules = (
                    Get-IICSv2Schedules -Session $Session |
                        ConvertFrom-Json -Depth 100
);
$Schedules |
    ConvertTo-Json -Depth 100 |
    Out-File -FilePath "C:\Users\bmorris\Documents\IICS\JSONDump\Schedules.json";

ForEach ($Schedule In $Schedules)
{
    [String] $OutFilePath = "C:\Users\bmorris\Documents\IICS\JSONDump\Schedules\" + $Schedule.id + ".json"
    Try
    {
        Get-IICSv2Schedule -Session $Session -Id $Schedule.id |
            ConvertFrom-Json -Depth 100 |
            ConvertTo-Json -Depth 100 |
            Out-File -FilePath $OutFilePath;
    }
    catch
    {
        $_.Exception.Message |
            Out-File -FilePath ([System.IO.Path]::ChangeExtension($OutFilePath, ".exception.txt"));
    }
}
#>
