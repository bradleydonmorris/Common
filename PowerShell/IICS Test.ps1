Get-ChildItem -Filter "*.ps1" -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions")) | %{. $_.FullName }

Function Export-IICSConnections()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [Object] $IICSSession,

        [Parameter(Mandatory=$true)]
        [String] $SQLInstance,

        [Parameter(Mandatory=$true)]
        [String] $SQLDatabase,

        [Parameter(Mandatory=$true)]
        [String] $OutputDirectory
    )
    If (![IO.Directory]::Exists([IO.Path]::Combine($OutputDirectory, "Connections")))
    {
        [void] [IO.Directory]::CreateDirectory([IO.Path]::Combine($OutputDirectory, "Connections"));
    }
    [String] $ConnectionsFilePath = [IO.Path]::Combine($OutputDirectory, "Connections.json")
    $Connections = (
                        Get-IICSv2Connections -Session $IICSSession |
                            ConvertFrom-Json -Depth 100
    );
    $Connections |
        ConvertTo-Json -Depth 100 |
        Out-File -FilePath $ConnectionsFilePath;
    If ([IO.File]::Exists($ConnectionsFilePath))
    {
        Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name "Connections.json" -Content ([IO.File]::ReadAllText($ConnectionsFilePath));
    }
    ForEach ($Connection In $Connections)
    {
        Try
        {
            [String] $OutFilePath = [IO.Path]::Combine($OutputDirectory, "Connections", $Connection.id + ".json");
            Get-IICSv2Connection -Session $IICSSession -Id $Connection.id |
                ConvertFrom-Json -Depth 100 |
                ConvertTo-Json -Depth 100 |
                Out-File -FilePath $OutFilePath;
            If ([IO.File]::Exists($OutFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("Connections\" + [IO.Path]::GetFileName($OutFilePath)) -Content ([IO.File]::ReadAllText($OutFilePath));
            }
        }
        catch
        {
            [String] $ErrorFilePath = [IO.Path]::Combine($OutputDirectory, "Connections", $Connection.id + ".Exception.json");
            [void] [IO.File]::WriteAllText(
                $ErrorFilePath,
                "{ `"Exception`": `"" + $_.Exception + "`" }"
            );
            If ([IO.File]::Exists($ErrorFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("Connections\" + [IO.Path]::GetFileName($ErrorFilePath)) -Content ([IO.File]::ReadAllText($ErrorFilePath));
            }
        }
    }
}

Function Export-IICSMappings()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [Object] $IICSSession,

        [Parameter(Mandatory=$true)]
        [String] $SQLInstance,

        [Parameter(Mandatory=$true)]
        [String] $SQLDatabase,

        [Parameter(Mandatory=$true)]
        [String] $OutputDirectory
    )
    If (![IO.Directory]::Exists([IO.Path]::Combine($OutputDirectory, "Mappings")))
    {
        [void] [IO.Directory]::CreateDirectory([IO.Path]::Combine($OutputDirectory, "Mappings"));
    }
    [String] $MappingsFilePath = [IO.Path]::Combine($OutputDirectory, "Mappings.json")
    $Mappings = (
                        Get-IICSv2Mappings -Session $IICSSession |
                            ConvertFrom-Json -Depth 100
    );
    $Mappings |
        ConvertTo-Json -Depth 100 |
        Out-File -FilePath $MappingsFilePath;
    If ([IO.File]::Exists($MappingsFilePath))
    {
        Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name "Mappings.json" -Content ([IO.File]::ReadAllText($MappingsFilePath));
    }
    ForEach ($Mapping In $Mappings)
    {
        [String] $OutFilePath = [IO.Path]::Combine($OutputDirectory, "Mappings", $Mapping.id + ".json");
        Try
        {
            Get-IICSv2Mapping -Session $IICSSession -Id $Mapping.id |
                ConvertFrom-Json -Depth 100 |
                ConvertTo-Json -Depth 100 |
                Out-File -FilePath $OutFilePath;
            If ([IO.File]::Exists($OutFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("Mappings\" + [IO.Path]::GetFileName($OutFilePath)) -Content ([IO.File]::ReadAllText($OutFilePath));
            }
        }
        catch
        {
            [String] $ErrorFilePath = [IO.Path]::Combine($OutputDirectory, "Mappings", $Mapping.id + ".Exception.json");
            [void] [IO.File]::WriteAllText(
                $ErrorFilePath,
                "{ `"Exception`": `"" + $_.Exception + "`" }"
            );
            If ([IO.File]::Exists($ErrorFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("Mappings\" + [IO.Path]::GetFileName($ErrorFilePath)) -Content ([IO.File]::ReadAllText($ErrorFilePath));
            }
        }
    }
}

Function Export-IICSMappingTasks()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [Object] $IICSSession,

        [Parameter(Mandatory=$true)]
        [String] $SQLInstance,

        [Parameter(Mandatory=$true)]
        [String] $SQLDatabase,

        [Parameter(Mandatory=$true)]
        [String] $OutputDirectory
    )
    If (![IO.Directory]::Exists([IO.Path]::Combine($OutputDirectory, "MappingTasks")))
    {
        [void] [IO.Directory]::CreateDirectory([IO.Path]::Combine($OutputDirectory, "MappingTasks"));
    }
    [String] $MappingTasksFilePath = [IO.Path]::Combine($OutputDirectory, "MappingTasks.json")
    $MappingTasks = (
                        Get-IICSv2MappingTasks -Session $IICSSession |
                            ConvertFrom-Json -Depth 100
    );
    $MappingTasks |
        ConvertTo-Json -Depth 100 |
        Out-File -FilePath $MappingTasksFilePath;
    If ([IO.File]::Exists($MappingTasksFilePath))
    {
        Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name "MappingTasks.json" -Content ([IO.File]::ReadAllText($MappingTasksFilePath));
    }
    ForEach ($MappingTask In $MappingTasks)
    {
        [String] $OutFilePath = [IO.Path]::Combine($OutputDirectory, "MappingTasks", $MappingTask.id + ".json");
        Try
        {
            Get-IICSv2MappingTask -Session $IICSSession -Id $MappingTask.id |
                ConvertFrom-Json -Depth 100 |
                ConvertTo-Json -Depth 100 |
                Out-File -FilePath $OutFilePath;
            If ([IO.File]::Exists($OutFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("MappingTasks\" + [IO.Path]::GetFileName($OutFilePath)) -Content ([IO.File]::ReadAllText($OutFilePath));
            }
        }
        catch
        {
            [String] $ErrorFilePath = [IO.Path]::Combine($OutputDirectory, "MappingTasks", $Connection.id + ".Exception.json");
            [void] [IO.File]::WriteAllText(
                $ErrorFilePath,
                "{ `"Exception`": `"" + $_.Exception + "`" }"
            );
            If ([IO.File]::Exists($ErrorFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("MappingTasks\" + [IO.Path]::GetFileName($ErrorFilePath)) -Content ([IO.File]::ReadAllText($ErrorFilePath));
            }
        }
    }
}

Function Export-IICSWorkflows()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [Object] $IICSSession,

        [Parameter(Mandatory=$true)]
        [String] $SQLInstance,

        [Parameter(Mandatory=$true)]
        [String] $SQLDatabase,

        [Parameter(Mandatory=$true)]
        [String] $OutputDirectory
    )
    If (![IO.Directory]::Exists([IO.Path]::Combine($OutputDirectory, "Workflows")))
    {
        [void] [IO.Directory]::CreateDirectory([IO.Path]::Combine($OutputDirectory, "Workflows"));
    }
    [String] $WorkflowsFilePath = [IO.Path]::Combine($OutputDirectory, "Workflows.json")
    $Workflows = (
                        Get-IICSv2Workflows -Session $IICSSession |
                            ConvertFrom-Json -Depth 100
    );
    $Workflows |
        ConvertTo-Json -Depth 100 |
        Out-File -FilePath $WorkflowsFilePath;
    If ([IO.File]::Exists($WorkflowsFilePath))
    {
        Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name "Workflows.json" -Content ([IO.File]::ReadAllText($WorkflowsFilePath));
    }
    ForEach ($Workflow In $Workflows)
    {
        [String] $OutFilePath = [IO.Path]::Combine($OutputDirectory, "Workflows", $Workflow.id + ".json");
        Try
        {
            Get-IICSv2Workflow -Session $IICSSession -Id $Workflow.id |
                ConvertFrom-Json -Depth 100 |
                ConvertTo-Json -Depth 100 |
                Out-File -FilePath $OutFilePath;
            If ([IO.File]::Exists($OutFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("Workflows\" + [IO.Path]::GetFileName($OutFilePath)) -Content ([IO.File]::ReadAllText($OutFilePath));
            }
        }
        catch
        {
            [String] $ErrorFilePath = [IO.Path]::Combine($OutputDirectory, "Workflows", $Connection.id + ".Exception.json");
            [void] [IO.File]::WriteAllText(
                $ErrorFilePath,
                "{ `"Exception`": `"" + $_.Exception + "`" }"
            );
            If ([IO.File]::Exists($ErrorFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("Workflows\" + [IO.Path]::GetFileName($ErrorFilePath)) -Content ([IO.File]::ReadAllText($ErrorFilePath));
            }
        }
    }
}

Function Export-IICSSchedules()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [Object] $IICSSession,

        [Parameter(Mandatory=$true)]
        [String] $SQLInstance,

        [Parameter(Mandatory=$true)]
        [String] $SQLDatabase,

        [Parameter(Mandatory=$true)]
        [String] $OutputDirectory
    )
    If (![IO.Directory]::Exists([IO.Path]::Combine($OutputDirectory, "Schedules")))
    {
        [void] [IO.Directory]::CreateDirectory([IO.Path]::Combine($OutputDirectory, "Schedules"));
    }
    [String] $SchedulesFilePath = [IO.Path]::Combine($OutputDirectory, "Schedules.json")
    $Schedules = (
                        Get-IICSv2Schedules -Session $IICSSession |
                            ConvertFrom-Json -Depth 100
    );
    $Schedules |
        ConvertTo-Json -Depth 100 |
        Out-File -FilePath $SchedulesFilePath;
    If ([IO.File]::Exists($SchedulesFilePath))
    {
        Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name "Schedules.json" -Content ([IO.File]::ReadAllText($SchedulesFilePath));
    }
    ForEach ($Schedule In $Schedules)
    {
        [String] $OutFilePath = [IO.Path]::Combine($OutputDirectory, "Schedules", $Schedule.id + ".json");
        Try
        {
            Get-IICSv2Schedule -Session $IICSSession -Id $Schedule.id |
                ConvertFrom-Json -Depth 100 |
                ConvertTo-Json -Depth 100 |
                Out-File -FilePath $OutFilePath;
            If ([IO.File]::Exists($OutFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("Schedules\" + [IO.Path]::GetFileName($OutFilePath)) -Content ([IO.File]::ReadAllText($OutFilePath));
            }
        }
        catch
        {
            [String] $ErrorFilePath = [IO.Path]::Combine($OutputDirectory, "Schedules", $Connection.id + ".Exception.json");
            [void] [IO.File]::WriteAllText(
                $ErrorFilePath,
                "{ `"Exception`": `"" + $_.Exception + "`" }"
            );
            If ([IO.File]::Exists($ErrorFilePath))
            {
                Write-IICSJsonFileContent -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -Name ("Schedules\" + [IO.Path]::GetFileName($ErrorFilePath)) -Content ([IO.File]::ReadAllText($ErrorFilePath));
            }
        }
    }
}

Clear-Host;
$IICSSession = Get-IICSv2Session -UserName "bmorris@foxrentacar.com" -Password "1BluePipe$";
[String] $SQLInstance = "tsd-sql02-aws.fox.local";
[String] $SQLDatabase = "Reports_Library";

[String] $OutputDirectory = "C:\Users\bmorris\Documents\IICS\JSONDump";

If ([IO.Directory]::Exists($OutputDirectory))
{
    Remove-Item -Path $OutputDirectory -Recurse -Force;
}
If (![IO.Directory]::Exists($OutputDirectory))
{
    [void] [IO.Directory]::CreateDirectory($OutputDirectory);
}

Write-Host -Object "Exporting Connections";
Export-IICSConnections -IICSSession $IICSSession -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -OutputDirectory $OutputDirectory;

Write-Host -Object "Exporting Schedules";
Export-IICSSchedules -IICSSession $IICSSession -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -OutputDirectory $OutputDirectory;

Write-Host -Object "Exporting Mappings";
Export-IICSMappings -IICSSession $IICSSession -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -OutputDirectory $OutputDirectory;

Write-Host -Object "Exporting Mapping Tasks";
Export-IICSMappingTasks -IICSSession $IICSSession -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -OutputDirectory $OutputDirectory;

Write-Host -Object "Exporting Workflows";
Export-IICSWorkflows -IICSSession $IICSSession -SQLInstance $SQLInstance -SQLDatabase $SQLDatabase -OutputDirectory $OutputDirectory;

