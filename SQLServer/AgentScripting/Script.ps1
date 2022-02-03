<#
Requires SqlServer module which can be installed by running the following as Admin.
    Install-Module -Name SqlServer

Output is purposely surpressed so that this will run as a SQL Agent job
    without failure. Commit and Push notoifications on the GIT server
    should be used to provide feedback instead of relying on this script
    for that feedback.

This script can be ran on ONE SQL server and will script SQL Agent obejcts
    from ALL SQL Instances listed in the Instances array in the config.json file.

This script must exist in the root of the local GIT repository folder.
    And, config.json must exist in the same folder as this script.

Sample config.json
{
	"RemoteGITBranch": "master",
	"Instances":
	[
		"SQLSERVER1",
		"SQLSERVER2\\Accounting"
	]
}
#>

[String] $RepositoryFolder = [IO.Path]::GetDirectoryName($PSCommandPath)
$Config = ConvertFrom-Json -InputObject $([IO.File]::ReadAllText([IO.Path]::Combine($RepositoryFolder, "config.json")));

Import-Module -Name SqlServer
[String] $CurrentExecution = [DateTime]::UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fffffff");
[String] $LastExecutionFilePath = [IO.Path]::Combine($RepositoryFolder, "LastExecution.txt");
[String] $LastExecution = $null;
[DateTime] $LastExecutionTime = [DateTime]::MinValue;
[System.Collections.Hashtable] $ObjectFiles = [System.Collections.Hashtable]::new();

If ([IO.File]::Exists($LastExecutionFilePath))
{
    $LastExecution = [IO.File]::ReadAllText($LastExecutionFilePath);
}
If (![String]::IsNullOrEmpty($LastExecution))
{
    $LastExecutionTime = [DateTime]::SpecifyKind([DateTime]::ParseExact($LastExecution, "yyyy-MM-dd HH:mm:ss.fffffff", [CultureInfo]::InvariantCulture), [DateTimeKind]::Utc);
}
[String] $CommitMessage = "Automated Script and Commit - " + $CurrentExecution + "Z";

Set-Location -Path $RepositoryFolder;
[Microsoft.SqlServer.Management.Smo.ScriptingOptions] $ScriptionOptions = [Microsoft.SqlServer.Management.Smo.ScriptingOptions]::new();
$ScriptionOptions.AgentAlertJob = $true;
$ScriptionOptions.AgentNotify = $true;
$ScriptionOptions.ScriptOwner = $true;

Import-Module -Name SqlServer
ForEach ($Instance in $Config.Instances)
{
    [String] $InstancePath = [IO.Path]::Combine($RepositoryFolder, $Instance.Replace("\", "_"));
    If (![IO.Directory]::Exists($InstancePath))
    {
        [void] [IO.Directory]::CreateDirectory($InstancePath);
    }
    [Microsoft.SqlServer.Management.Smo.Server] $Server = [Microsoft.SqlServer.Management.Smo.Server]::new($Instance);

    ForEach ($File In $(Get-ChildItem -Path $InstancePath -Filter "*.sql"))
    {
        [void] $ObjectFiles.Add($File, $false); #Assumes all objects are deleted till proven otherwise
    }

    [String] $OperatorsPath = [IO.Path]::Combine(
        $InstancePath,
        "1-Operators"
    );
    If (![IO.Directory]::Exists($OperatorsPath))
    {
        [void] [IO.Directory]::CreateDirectory($OperatorsPath);
    }
    ForEach ($OperatorCategory In $Server.JobServer.OperatorCategories)
    {
        [String] $OperatorCategoryPath = [IO.Path]::Combine(
            $OperatorsPath,
            [String]::Join("_", $OperatorCategory.Name.Split([IO.Path]::GetInvalidFileNameChars()))
        );
        If (![IO.Directory]::Exists($OperatorCategoryPath))
        {
            [void] [IO.Directory]::CreateDirectory($OperatorCategoryPath);
        }
    }
    ForEach ($Operator In $Server.JobServer.Operators)
    {
        [String] $OperatorPath = [IO.Path]::ChangeExtension(
            [IO.Path]::Combine(
                $OperatorsPath,
                [String]::Join("_", $Operator.CategoryName.Split([IO.Path]::GetInvalidFileNameChars())),
                [String]::Join("_", $Operator.Name.Split([IO.Path]::GetInvalidFileNameChars()))
            ),
            "sql"
        );
        $ObjectFiles[$OperatorPath] = $true;
        [IO.File]::WriteAllText($OperatorPath, $Operator.Script($ScriptionOptions));
    }

    [String] $AlertsPath = [IO.Path]::Combine(
        $InstancePath,
        "2-Alerts"
    );
    If (![IO.Directory]::Exists($AlertsPath))
    {
        [void] [IO.Directory]::CreateDirectory($AlertsPath);
    }
    ForEach ($AlertCategory In $Server.JobServer.AlertCategories)
    {
        [String] $AlertCategoryPath = [IO.Path]::Combine(
            $AlertsPath,
            [String]::Join("_", $AlertCategory.Name.Split([IO.Path]::GetInvalidFileNameChars()))
        );
        If (![IO.Directory]::Exists($AlertCategoryPath))
        {
            [void] [IO.Directory]::CreateDirectory($AlertCategoryPath);
        }
    }
    ForEach ($Alert In $Server.JobServer.Alerts)
    {
        [String] $AlertPath = [IO.Path]::ChangeExtension(
            [IO.Path]::Combine(
                $AlertsPath,
                [String]::Join("_", $Alert.CategoryName.Split([IO.Path]::GetInvalidFileNameChars())),
                [String]::Join("_", $Alert.Name.Split([IO.Path]::GetInvalidFileNameChars()))
            ),
            "sql"
        );
        $ObjectFiles[$AlertPath] = $true;
        [IO.File]::WriteAllText($AlertPath, $Alert.Script($ScriptionOptions));
    }

    [String] $JobsPath = [IO.Path]::Combine(
        $InstancePath,
        "3-Jobs"
    );
    If (![IO.Directory]::Exists($JobsPath))
    {
        [void] [IO.Directory]::CreateDirectory($JobsPath);
    }
    ForEach ($JobCategory In $Server.JobServer.JobCategories)
    {
        [String] $JobCategoryPath = [IO.Path]::Combine(
            $JobsPath,
            [String]::Join("_", $JobCategory.Name.Split([IO.Path]::GetInvalidFileNameChars()))
        );
        If (![IO.Directory]::Exists($JobCategoryPath))
        {
            [void] [IO.Directory]::CreateDirectory($JobCategoryPath);
        }
    }
    ForEach ($Job In $Server.JobServer.Jobs)
    {
        [String] $JobPath = [IO.Path]::ChangeExtension(
            [IO.Path]::Combine(
                $JobsPath,
                [String]::Join("_", $Job.Category.Split([IO.Path]::GetInvalidFileNameChars())),
                [String]::Join("_", $Job.Name.Split([IO.Path]::GetInvalidFileNameChars()))
            ),
            "sql"
        );
        $ObjectFiles[$JobPath] = $true;
        If (
            ($Job.DateCreated -ge $LastExecutionTime) -or
            ($Job.DateLastModified -ge $LastExecutionTime)
        )
        {
            [IO.File]::WriteAllText($JobPath, $Job.Script($ScriptionOptions));
        }
    }
    Break;
}
[void] [IO.File]::WriteAllText($LastExecutionFilePath, $CurrentExecution);

#If the SQL Agent object (file) exists in the folder, but is no longer on the SQL instance
#    then the file needs to be removed from the folder before commit and push.
ForEach ($ObjectFile In ($ObjectFiles.GetEnumerator() | Where-Object { $_.Value -eq $false }))
{
    If (
        !$ObjectFile.Value -and
        [IO.File]::Exists($ObjectFile.Key)
    )
    {
        Write-Host -Object ($ObjectFile.Value.ToString().PadRight(6, " ") + $ObjectFile.Key);
    }
}

#Using *>$null to suppress output from GIT

#Commit changes and push upstream
git add . *>$null
git commit -m $CommitMessage *>$null

#using "-q" on push. GIT push always throws an error even when successful
git push origin $Config.RemoteGITBranch -q *>$null


[String] $Output = git status --porcelain=v1 |
    Out-String;
If ($Output.Length -gt 0)
{
    git add --all *>$null;
    git commit --message $CommitMessage *>$null;
    git push origin $Config.RemoteGITBranch -q *>$null
}
