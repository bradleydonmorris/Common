Function Write-IICSJsonFileContent()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [String] $SQLInstance,

        [Parameter(Mandatory=$true)]
        [String] $SQLDatabase,

        [Parameter(Mandatory=$true)]
        [String] $Name,

        [Parameter(Mandatory=$true)]
        [String] $Content
    )
    [String] $ConnectionString = "Server=$SQLInstance;" +
        "Initial Catalog=$SQLDatabase;" +
        "Integrated Security=SSPI;"
    [Data.SqlClient.SqlConnection] $SqlConnection = [Data.SqlClient.SqlConnection]::new($ConnectionString);
    [Data.SqlClient.SqlCommand] $SqlCommand = [Data.SqlClient.SqlCommand]::new();
    [void] $SqlConnection.Open();
    $SqlCommand.Connection = $SqlConnection;
    $SqlCommand.CommandType = [Data.CommandType]::StoredProcedure;
    $SqlCommand.CommandText = "[IICS].[WriteJSONFile]";
    [void] $SqlCommand.Parameters.AddWithValue("@Name", $Name);
    [void] $SqlCommand.Parameters.AddWithValue("@Content", $Content);
    [void] $SqlCommand.ExecuteNonQuery();
    [void] $SqlCommand.Dispose();
    If ($SqlConnection.State -ne [System.Data.ConnectionState]::Closed)
    {
        [void] $SqlConnection.Close();
    }
    [void] $SqlConnection.Dispose();
}
