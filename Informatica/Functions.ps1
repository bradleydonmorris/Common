Set-Alias ?: Ternary-Operator -Option AllScope
Filter Ternary-Operator()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ScriptBlock] $Condition,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ScriptBlock] $IfTrue,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ScriptBlock] $IfFalse
    )
    If (&$Condition)
    {
        &$IfTrue
    }
    Else
    {
        &$IfFalse
    }
}

Function ICS-LogIn()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.String] $UserName,

        [Parameter(Mandatory=$true)]
        [System.String] $Password
    )
    [System.Collections.Hashtable] $ReturnValue = @{};
    [void] $ReturnValue.Add("Headers", @{});
    [void] $ReturnValue.Add("URLs", @{});
    [void] $ReturnValue.URLs.Add("LogIn", "https://app.informaticaondemand.com/ma/api/v2/user/login");
    [void] $ReturnValue.Headers.Add("Content-Type", "application/json");
    [void] $ReturnValue.Headers.Add("Accept", "application/json");
    [System.String] $Body = "{`"@type`": `"login`",`"username`": `"{@UserName}`",`"password`":`"{@Password}`"}";
    $Body = $Body.Replace("{@UserName}", $UserName);
    $Body = $Body.Replace("{@Password}", $Password);
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri $ReturnValue.URLs.LogIn -Headers $ReturnValue.Headers -Method Post -Body $Body;
    $ResponseJSON = ConvertFrom-Json -InputObject $Response.Content;
    $ReturnValue.Add("ServerUrl", $ResponseJSON.serverUrl);
    $ReturnValue.Add("ICSessionId", $ResponseJSON.icSessionId);
    [void] $ReturnValue.Headers.Add("icSessionId", $ResponseJSON.icSessionId);
    [void] $ReturnValue.URLs.Add("LogOut", ($ResponseJSON.serverUrl + "/api/v2/user/logout"));
    [void] $ReturnValue.URLs.Add("Task", ($ResponseJSON.serverUrl + "/api/v2/task"));
    [void] $ReturnValue.URLs.Add("ActivityLog", ($ResponseJSON.serverUrl + "/api/v2/activity/activityLog"));
    [void] $ReturnValue.URLs.Add("Workflow", ($ResponseJSON.serverUrl + "/api/v2/workflow"));
    [void] $ReturnValue.URLs.Add("User", ($ResponseJSON.serverUrl + "/api/v2/user"));
    [void] $ReturnValue.URLs.Add("Connection", ($ResponseJSON.serverUrl + "/api/v2/connection"));
    
    Return $ReturnValue;
}

Function ICS-Connection-Export()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$true)]
        [System.String] $ExportFilePath
    )
    [System.String] $LineTemplate = "{@Id}`t{@Name}`t{@ConnectionType}`t{@Description}`t{@CreateTime}`t{@UpdateTime}`t{@CreatedBy}`t{@UpdatedBy}`t{@Host}`t{@InstanceName}`t{@AdjustedJDBCHostName}`t{@Port}`t{@Database}`t{@Schema}`t{@UserName}";
    Set-Content -Path $ExportFilePath -Value $LineTemplate.Replace("{@", "").Replace("}", "");

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri $Session.URLs.Connection -Headers $Session.Headers -Method Get;
    $ResponseJSON = ConvertFrom-Json -InputObject $Response.Content;
    If ($ResponseJSON.Length -gt 0)
    {
        ForEach ($Connection In $ResponseJSON)
        {
            [System.String] $Line = $LineTemplate;
            $Line = $Line.Replace("{@Id}", (?: {[System.String]::IsNullOrEmpty($Connection.id)} {[System.String]::Empty} {$Connection.id}));
            $Line = $Line.Replace("{@Name}", (?: {[System.String]::IsNullOrEmpty($Connection.name)} {[System.String]::Empty} {$Connection.name}));
            $Line = $Line.Replace("{@ConnectionType}", (?: {[System.String]::IsNullOrEmpty($Connection.type)} {[System.String]::Empty} {$Connection.type}));
            $Line = $Line.Replace("{@Description}", (?: {[System.String]::IsNullOrEmpty($Connection.description)} {[System.String]::Empty} {$Connection.description}));
            $Line = $Line.Replace("{@CreateTime}", (?: {[System.String]::IsNullOrEmpty($Connection.createTime)} {[System.String]::Empty} {$Connection.createTime}));
            $Line = $Line.Replace("{@UpdateTime}", (?: {[System.String]::IsNullOrEmpty($Connection.updateTime)} {[System.String]::Empty} {$Connection.updateTime}));
            $Line = $Line.Replace("{@CreatedBy}", (?: {[System.String]::IsNullOrEmpty($Connection.createdBy)} {[System.String]::Empty} {$Connection.createdBy}));
            $Line = $Line.Replace("{@UpdatedBy}", (?: {[System.String]::IsNullOrEmpty($Connection.updatedBy)} {[System.String]::Empty} {$Connection.updatedBy}));
            $Line = $Line.Replace("{@Host}", (?: {[System.String]::IsNullOrEmpty($Connection.host)} {[System.String]::Empty} {$Connection.host}));
            $Line = $Line.Replace("{@InstanceName}", (?: {[System.String]::IsNullOrEmpty($Connection.instanceName)} {[System.String]::Empty} {$Connection.instanceName}));
            $Line = $Line.Replace("{@AdjustedJDBCHostName}", (?: {[System.String]::IsNullOrEmpty($Connection.adjustedJdbcHostName)} {[System.String]::Empty} {$Connection.adjustedJdbcHostName}));
            $Line = $Line.Replace("{@Port}", (?: {[System.String]::IsNullOrEmpty($Connection.port)} {[System.String]::Empty} {$Connection.port}));
            $Line = $Line.Replace("{@Database}", (?: {[System.String]::IsNullOrEmpty($Connection.database)} {[System.String]::Empty} {$Connection.database}));
            $Line = $Line.Replace("{@Schema}", (?: {[System.String]::IsNullOrEmpty($Connection.schema)} {[System.String]::Empty} {$Connection.schema}));
            $Line = $Line.Replace("{@UserName}", (?: {[System.String]::IsNullOrEmpty($Connection.username)} {[System.String]::Empty} {$Connection.username}));
            Add-Content -Path $ExportFilePath -Value $Line;
        }
    }
}

Function Main()
{
    [System.Object[]] $ICSSession = ICS-LogIn -UserName "bradleymorris@matrixservice.com" -Password "turtlefish";
    [System.String] $ConnectionsFilePath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($PSCommandPath), "Connections.txt")
    ICS-Connection-Export -Session $ICSSession -ExportFilePath $ConnectionsFilePath

    #ICS-Task -Session $ICSSession -Type WORKFLOW;

    #ICS-ActivityLog-Export -Session $ICSSession -ExportFilePath $TempCSVPath;
    #ICS-User-Export -Session $ICSSession -ExportFilePath $TempCSVPath;
    #ICS-LogOut -Session $ICSSession;
    Write-Host -Object $ConnectionsFilePath;
}

Clear-Host;
Main;