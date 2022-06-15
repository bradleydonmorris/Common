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
        [SupportsWildcards()]
        [String] $ServerInstance,

        [Parameter(Mandatory=$true,
                Position=1,
                HelpMessage="Database name")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [String] $Database,

        [Parameter(Mandatory=$true,
                Position=1,
                HelpMessage="Path to SQL query file (*.sql)")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [String] $InputFile
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
    Return $ReturnValue;
}
