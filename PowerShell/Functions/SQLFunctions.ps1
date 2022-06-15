#Invoke-SqlcmdLongString is used to overcome character limitations of Invoke-Sqlcmd
#   Only returns scalar string. First column of first row. Not entire record set.
Function Invoke-SqlcmdScalarLongString()
{
    Param
    (
        [Parameter(Mandatory=$true,
                Position=1,
                HelpMessage="SQL Server instance name")]
        [ValidateNotNullOrEmpty()]
        [String] $ServerInstance,

        [Parameter(Mandatory=$true,
                Position=2,
                HelpMessage="Database name")]
        [ValidateNotNullOrEmpty()]
        [String] $Database,

        [Parameter(Mandatory=$true,
                Position=3,
                HelpMessage="Path to SQL query file (*.sql)")]
        [ValidateNotNullOrEmpty()]
        [String] $InputFile,

        [Parameter(Mandatory=$false,
                Position=4,
                HelpMessage="(Optional) Path to file where results will be saved")]
        [String] $OutputFile,

        [Parameter(Mandatory=$false,
                Position=5,
                HelpMessage="(Optional) Indicates if resulting string should be pretty formatted as json")]
        [switch] $FormatAsJson
    )
    [String] $ReturnValue = $null;
    [System.Data.SqlClient.SqlCommand] $SqlCommand = [System.Data.SqlClient.SqlCommand]::new();
    $SqlCommand.CommandType = [System.Data.CommandType]::Text;
    $SqlCommand.CommandText = [System.IO.File]::ReadAllText($InputFile);
    $SqlCommand.Connection = [System.Data.SqlClient.SqlConnection]::new("Server=$ServerInstance;Initial Catalog=$Database;Integrated Security=SSPI;");
    [void] $SqlCommand.Connection.Open();
    [System.Data.SqlClient.SqlDataReader] $SqlDataReader = $SqlCommand.ExecuteReader();
    While ($SqlDataReader.Read())
    {
        $ReturnValue = $SqlDataReader.GetString(0);
        Break;
    }
    [void] $SqlDataReader.Close();
    If ($SqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed)
    {
        [void] $SqlCommand.Connection.Close();
    }
    [void] $SqlCommand.Dispose();
    if ($FormatAsJson)
    {
        $discarded = ConvertFrom-Json -InputObject $ReturnValue;
        $ReturnValue = ConvertTo-Json -InputObject $discarded -Depth 100;
    }
    If (![String]::IsNullOrEmpty($OutputFile))
    {
        [System.IO.File]::WriteAllText($OutputFile, $ReturnValue);
    }
    Else
    {
        Return $ReturnValue;
    }
}
