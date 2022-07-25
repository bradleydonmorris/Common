#[String] $SQLInstance = "tsd-sql02-aws.fox.local"; #"TUL-IT-WL-18";
#[String[]] $Databases = @( "JSI_Reporting" );
#[String] $OutputDirectory = "C:\Users\bmorris\source\repos\FRACDEV\data"

[String] $SQLInstance = "TUL-IT-WL-18";
[String[]] $Databases = @( "AdventureWorks2019" );
[String] $OutputDirectory = "C:\Users\bmorris\source\repos\bradleydonmorris\DDLDump"


#To prevent objects (tables, views, functions, procs, etc.) from being scripted unnecessarily.
[Collections.ArrayList] $ExcludedSchemas = @(
    #Database Roles
        "db_datareader", "db_datawriter", "db_denydatareader", "db_denydatawriter",
        "db_ddladmin", "db_backupoperator", "db_accessadmin", "db_owner", "db_securityadmin",
    #System Schemas
        "guest", "INFORMATION_SCHEMA", "sys"
);

Clear-Host;
[void] [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')
[String] $DateTimeStamp = [DateTime]::UtcNow.ToString("yyyyMMdd_HHmmss");
[String] $Go = "`r`nGO";
If (![IO.Directory]::Exists($OutputDirectory))
{
    [void] [IO.Directory]::CreateDirectory($OutputDirectory);
}
[Microsoft.SqlServer.Management.Smo.Server] $SmoServer = [Microsoft.SqlServer.Management.Smo.Server]::new($SQLInstance);
[Microsoft.SqlServer.Management.Smo.ScriptingOptions] $SmoScriptingOptions = [Microsoft.SqlServer.Management.Smo.ScriptingOptions]::new();
$SmoScriptingOptions.ClusteredIndexes = $true;
$SmoScriptingOptions.FullTextIndexes = $true;
$SmoScriptingOptions.NonClusteredIndexes = $true;
$SmoScriptingOptions.Indexes = $true;
$SmoScriptingOptions.SchemaQualify = $true;
$SmoScriptingOptions.Statistics = $true;
$SmoScriptingOptions.Triggers = $true;
$SmoScriptingOptions.Permissions = $true;
$SmoScriptingOptions.DriChecks = $true;
$SmoScriptingOptions.DriDefaults = $true;

[String[]] $ObjectTypes = @( "Users", "Roles", "Schemas", "Types", "Tables", "ForeignKeys", "Functions", "Views", "Procedures" );
[Collections.Hashtable] $Files = [Collections.Hashtable]::new();
[void] $Files.Add("Database", [String]::Empty);

ForEach ($ObjectType In $ObjectTypes)
{
    [void] $Files.Add($ObjectType, [Collections.ArrayList]::new());
}

ForEach ($Database In $Databases)
{
Write-Host $Database
    [Microsoft.SqlServer.Management.Smo.Database] $SmoDatabase = $SmoServer.Databases[$Database];

    If ($SmoDatabase -ne $null)
    {
        [String] $DatabaseDirectoryPath = [IO.Path]::Combine($OutputDirectory, $SmoDatabase.Name);
        If (![IO.Directory]::Exists($DatabaseDirectoryPath))
        {
            [void] [IO.Directory]::CreateDirectory($DatabaseDirectoryPath);
        }

        #Adding line breaks to make the script more readable
        [String] $DatabaseScript = $SmoDatabase.Script().Replace("ALTER DATABASE", "`r`nALTER DATABASE");

        #Including database owner
        $DatabaseScript += "`r`nALTER AUTHORIZATION ON DATABASE::[" + $Database + "] TO [" + $SmoDatabase.Owner + "]";

        [String] $DatabaseFilePath = [IO.Path]::Combine(
            $DatabaseDirectoryPath,
            "Database.sql"
        );
        $DatabaseScript += $Go;
        [void] [IO.File]::WriteAllText(
            $DatabaseFilePath,
            $DatabaseScript
        );
        $Files["Database"] = $DatabaseFilePath;

        [String] $UsersDirectoryPath = [IO.Path]::Combine($DatabaseDirectoryPath, "Users");
        If (![IO.Directory]::Exists($UsersDirectoryPath))
        {
            [void] [IO.Directory]::CreateDirectory($UsersDirectoryPath);
        }
        ForEach ($User In $SmoDatabase.Users)
        {
            [String] $UserFileName = $User.Name.Replace("\", "_");

            #Exclude system accounts
            If (
                $User.Name -ne "dbo" -and
                $User.Name -ne "guest" -and
                $User.Name -ne "INFORMATION_SCHEMA" -and
                $User.Name -ne "sys"
            )
            {
                [String] $UserFilePath = [IO.Path]::ChangeExtension(
                    [IO.Path]::Combine(
                        $UsersDirectoryPath,
                        $UserFileName
                    ),
                    ".sql"
                );
                [String] $UserScript = $User.Script();
                [void] [IO.File]::WriteAllText($UserFilePath, $UserScript);
                [void] $Files["Users"].Add($UserFilePath);
            }
        }

        [String] $RolesDirectoryPath = [IO.Path]::Combine($DatabaseDirectoryPath, "Roles");
        If (![IO.Directory]::Exists($RolesDirectoryPath))
        {
            [void] [IO.Directory]::CreateDirectory($RolesDirectoryPath);
        }
        ForEach ($Role In $SmoDatabase.Roles)
        {
            [String] $RoleFilePath = [IO.Path]::ChangeExtension(
                [IO.Path]::Combine(
                    $RolesDirectoryPath,
                    $Role.Name
                ),
                ".sql"
            );
            [String] $RoleScript = "";
            If ($Role.IsFixedRole)
            {
                $RoleScript = "--Fixed Role Should already exists`r`n--" + $Role.Script();
            }
            
            #public is not scriptable via SMO.
            ElseIf ($Role.Name -eq "public")
            {
                $RoleScript = "--Fixed Role Should already exists`r`n--CREATE ROLE [public]";
            }
            
            Else
            {
                $RoleScript = $Role.Script();
            }
            ForEach ($Member In $Role.EnumMembers())
            {
                $RoleScript += "`r`nALTER ROLE [" + $Role.Name + "] ADD MEMBER [" + $Member + "]";
            }
            $RoleScript += $Go;
            [void] [IO.File]::WriteAllText($RoleFilePath, $RoleScript);
            [void] $Files["Roles"].Add($RoleFilePath);
        }

        ForEach ($Schema In $SmoDatabase.Schemas)
        {
            If (!$ExcludedSchemas.Contains($Schema.Name))
            {
                [String] $SchemaDirectoryPath = [IO.Path]::Combine($DatabaseDirectoryPath, $Schema.Name);
                [String] $SchemaFilePath = [IO.Path]::Combine($SchemaDirectoryPath, "Schema.sql");
                If (![IO.Directory]::Exists($SchemaDirectoryPath))
                {
                    [void] [IO.Directory]::CreateDirectory($SchemaDirectoryPath);
                }
                [void] [IO.File]::WriteAllText($SchemaFilePath, $Schema.Script() + $Go);
                [void] $Files["Schemas"].Add($SchemaFilePath);
                ForEach ($ObjectTypeDirectory In @("Types", "Tables", "ForeignKeys", "Procedures", "Views", "Functions"))
                {
                    [String] $ObjectTypeDirectoryPath = [IO.Path]::Combine($SchemaDirectoryPath, $ObjectTypeDirectory);
                    If (![IO.Directory]::Exists($ObjectTypeDirectoryPath))
                    {
                        [void] [IO.Directory]::CreateDirectory($ObjectTypeDirectoryPath);
                    }
                }
            }
        }
    
        ForEach ($Type In $SmoDatabase.UserDefinedTableTypes)
        {
            If (!$ExcludedSchemas.Contains($Function.Schema))
            {
                [String] $TypeFilePath = [IO.Path]::ChangeExtension(
                    [IO.Path]::Combine(
                        $DatabaseDirectoryPath,
                        $Type.Schema,
                        "Functions",
                        $Type.Name
                    ),
                    ".sql"
                 );
                [void] [IO.File]::WriteAllText($TypeFilePath, $Type.Script() + $Go);
                [void] $Files["Types"].Add($TypeFilePath);
            }
        }

        ForEach ($Type In $SmoDatabase.UserDefinedTypes)
        {
            If (!$ExcludedSchemas.Contains($Function.Schema))
            {
                [String] $TypeFilePath = [IO.Path]::ChangeExtension(
                    [IO.Path]::Combine(
                        $DatabaseDirectoryPath,
                        $Type.Schema,
                        "Functions",
                        $Type.Name
                    ),
                    ".sql"
                 );
                [void] [IO.File]::WriteAllText($TypeFilePath, $Type.Script() + $Go);
                [void] $Files["Types"].Add($TypeFilePath);
            }
        }
    
        ForEach ($Type In $SmoDatabase.UserDefinedDataTypes)
        {
            If (!$ExcludedSchemas.Contains($Function.Schema))
            {
                [String] $TypeFilePath = [IO.Path]::ChangeExtension(
                    [IO.Path]::Combine(
                        $DatabaseDirectoryPath,
                        $Type.Schema,
                        "Functions",
                        $Type.Name
                    ),
                    ".sql"
                 );
                [void] [IO.File]::WriteAllText($TypeFilePath, $Type.Script() + $Go);
                [void] $Files["Types"].Add($TypeFilePath);
            }
        }

        ForEach ($Table In $SmoDatabase.Tables)
        {
            If (!$ExcludedSchemas.Contains($Table.Schema))
            {
                [String] $TableFilePath = [IO.Path]::ChangeExtension(
                    [IO.Path]::Combine(
                        $DatabaseDirectoryPath,
                        $Table.Schema,
                        "Tables",
                        $Table.Name
                    ),
                    ".sql"
                );
                [String] $TableScript = $Table.Script($SmoScriptingOptions) + "`r`n`r`n"

<#
                ForEach ($Index In $Table.Indexes)
                {
                    If ($Index.IndexKeyType -ne "DriPrimaryKey")
                    {
                        $TableScript += "`r`n" + $Index.Script() + $Go;
                    }
                }
#
                ForEach ($Check In $Table.Checks)
                {
                    $TableScript += "`r`n" + $Check.Script() + $Go;
                }
                
                [void] [IO.File]::WriteAllText($TableFilePath, $TableScript + $Go);
                [void] $Files["Tables"].Add($TableFilePath);

                ForEach ($ForeignKey In $Table.ForeignKeys)
                {
                    If (!$ExcludedSchemas.Contains($Table.Schema))
                    {
                        [String] $ForeignKeyFilePath = [IO.Path]::ChangeExtension(
                            [IO.Path]::Combine(
                                $DatabaseDirectoryPath,
                                $Table.Schema,
                                "ForeignKeys",
                                $ForeignKey.Name
                            ),
                            ".sql"
                        );
                        [void] [IO.File]::WriteAllText($ForeignKeyFilePath, $ForeignKey.Script() + $Go);
                        [void] $Files["ForeignKeys"].Add($ForeignKeyFilePath);
                    }
                }
            }
        }

        ForEach ($Function In $SmoDatabase.UserDefinedFunctions)
        {
            If (!$ExcludedSchemas.Contains($Function.Schema))
            {
                [String] $FunctionFilePath = [IO.Path]::ChangeExtension(
                    [IO.Path]::Combine(
                        $DatabaseDirectoryPath,
                        $Function.Schema,
                        "Functions",
                        $Function.Name
                    ),
                    ".sql"
                 );
                [void] [IO.File]::WriteAllText($FunctionFilePath, $Function.Script() + $Go);
                [void] $Files["Functions"].Add($FunctionFilePath);
            }
        }

        ForEach ($View In $SmoDatabase.Views)
        {
            If (!$ExcludedSchemas.Contains($View.Schema))
            {
                [String] $ViewFilePath = [IO.Path]::ChangeExtension(
                    [IO.Path]::Combine(
                        $DatabaseDirectoryPath,
                        $View.Schema,
                        "Views",
                        $View.Name
                    ),
                    ".sql"
                 );
                [void] [IO.File]::WriteAllText($ViewFilePath, $View.Script() + $Go);
                [void] $Files["Views"].Add($ViewFilePath);
            }
        }

        ForEach ($StoredProcedure In $SmoDatabase.StoredProcedures)
        {
            If (!$ExcludedSchemas.Contains($StoredProcedure.Schema))
            {
                [String] $StoredProcedureFilePath = [IO.Path]::ChangeExtension(
                    [IO.Path]::Combine(
                        $DatabaseDirectoryPath,
                        $StoredProcedure.Schema,
                        "Procedures",
                        $StoredProcedure.Name
                    ),
                    ".sql"
                 );
                [void] [IO.File]::WriteAllText($StoredProcedureFilePath, $StoredProcedure.Script() + $Go);
                [void] $Files["Procedures"].Add($StoredProcedureFilePath);
            }
        }
    }
}

[String] $ExecuteFilePath = [IO.Path]::Combine(
    $DatabaseDirectoryPath,
    "ExecuteAllScripts.sql"
);
[void] [IO.File]::WriteAllText(
    $ExecuteFilePath,
    (
        "--This script must be executed in SQLCMD mode.`r`n" +
        ":on error exit`r`n" +
        ":setvar __IsSqlComdEnabled `"True`"`r`n" +
        "GO`r`n" +
        "IF N'`$(__IsSqlCmdEnabled)' NOT LIKE N'True'`r`n" +
        "`tBEGIN`r`n" +
        "`t`tPRINT N'SQLCMS mode must be enabled to successfully execute this script.'`r`n" +
        "`r`n`t`tSET NOEXEC ON`r`n" +
        "`tEND`r`n" +
        "GO`r`n"
    )
);
[void] [IO.File]::AppendAllText($ExecuteFilePath, ("`r`n:r " + $DatabaseFilePath + "`r`n"));
ForEach ($ObjectType In $ObjectTypes)
{
    [void] [IO.File]::AppendAllText($ExecuteFilePath, ("`r`n--" + $ObjectType + "`r`n"));
    ForEach ($FilePath In $Files[$ObjectType])
    {
        [void] [IO.File]::AppendAllText($ExecuteFilePath, (":r " + $FilePath + "`r`n"));
    }
}
