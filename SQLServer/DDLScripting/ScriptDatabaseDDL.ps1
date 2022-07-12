[String] $SQLInstance = "tsd-sql02-aws.fox.local"; #"TUL-IT-WL-18";
[String] $Database = "JSI_Reporting";

Clear-Host;
[void] [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')
[String] $DateTimeStamp = [DateTime]::UtcNow.ToString("yyyyMMdd_HHmmss");
[String] $Go = "`r`nGO";
[String] $OutputDirectory = "C:\Users\bmorris\source\repos\FRACDEV\data"
    #[IO.Path]::Combine([IO.Path]::GetDirectoryName($PSCommandPath), "Output");
If (![IO.Directory]::Exists($OutputDirectory))
{
    [void] [IO.Directory]::CreateDirectory($OutputDirectory);
}
[Microsoft.SqlServer.Management.Smo.Server] $SmoServer = [Microsoft.SqlServer.Management.Smo.Server]::new($SQLInstance);
[Microsoft.SqlServer.Management.Smo.ScriptingOptions] $SmoScriptingOptions = [Microsoft.SqlServer.Management.Smo.ScriptingOptions]::new();

[Microsoft.SqlServer.Management.Smo.Database] $SmoDatabase = $SmoServer.Databases[$Database];
If ($SmoDatabase -ne $null)
{
    [String] $DatabaseDirectoryPath = [IO.Path]::Combine($OutputDirectory, $SmoDatabase.Name);
    $DatabaseDirectoryPath
    If (![IO.Directory]::Exists($DatabaseDirectoryPath))
    {
        [void] [IO.Directory]::CreateDirectory($DatabaseDirectoryPath);
    }
    [Collections.ArrayList] $SystemSchemas = @("db_accessadmin", "db_backupoperator", "db_datareader", "db_datawriter", "db_ddladmin", "db_denydatareader", "db_denydatawriter", "db_owner", "db_securityadmin", "guest", "INFORMATION_SCHEMA", "sys");
    ForEach ($Schema In $SmoDatabase.Schemas)
    {
        If (!$SystemSchemas.Contains($Schema.Name))
        {
            [String] $SchemaDirectoryPath = [IO.Path]::Combine($DatabaseDirectoryPath, $Schema.Name);
            [String] $SchemaFilePath = [IO.Path]::Combine($SchemaDirectoryPath, "Schema.sql");
            If (![IO.Directory]::Exists($SchemaDirectoryPath))
            {
                [void] [IO.Directory]::CreateDirectory($SchemaDirectoryPath);
            }
            [void] [IO.File]::WriteAllText($SchemaFilePath, $Schema.Script() + $Go);
            ForEach ($ObjectTypeDirectory In @("Tables", "Procedures", "Views", "Functions"))
            {
                [String] $ObjectTypeDirectoryPath = [IO.Path]::Combine($SchemaDirectoryPath, $ObjectTypeDirectory);
                If (![IO.Directory]::Exists($ObjectTypeDirectoryPath))
                {
                    [void] [IO.Directory]::CreateDirectory($ObjectTypeDirectoryPath);
                }
            }
        }
    }
    ForEach ($Table In $SmoDatabase.Tables)
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
        [void] [IO.File]::WriteAllText($TableFilePath, $Table.Script() + $Go);
    }
}
<#

$path = "D:\Backups\DB_SchemaBackup\"+"$date_"
 
$serverInstance = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $ServerName
$IncludeTypes = @("Tables","StoredProcedures","Views","UserDefinedFunctions", "Triggers") #object you want do backup. 
$ExcludeSchemas = @("sys","Information_Schema")
$so = new-object ('Microsoft.SqlServer.Management.Smo.ScriptingOptions')
 
$dbs=$serverInstance.Databases #you can change this variable for a query for filter yours databases.
foreach ($db in $dbs)
{
       $dbname = "$db".replace("[","").replace("]","")
       $dbpath = "$path"+ "\"+"$dbname" + "\"
    if ( !(Test-Path $dbpath))
           {$null=new-item -type directory -name "$dbname"-path "$path"}
 
       foreach ($Type in $IncludeTypes)
       {
              $objpath = "$dbpath" + "$Type" + "\"
         if ( !(Test-Path $objpath))
           {$null=new-item -type directory -name "$Type"-path "$dbpath"}
              foreach ($objs in $db.$Type)
              {
                     If ($ExcludeSchemas -notcontains $objs.Schema ) 
                      {
                           $ObjName = "$objs".replace("[","").replace("]","")                  
                           $OutFile = "$objpath" + "$ObjName" + ".sql"
                           $objs.Script($so)+"GO" | out-File $OutFile
                      }
              }
       }     
}

#>