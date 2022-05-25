Set-Alias ?: Get-TernaryOperator -Option AllScope
Filter Get-TernaryOperator()
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
Function Get-IICSLogin()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.String] $UserName,

        [Parameter(Mandatory=$true)]
        [System.String] $Password
    )
    https://dm-us.informaticacloud.com/saas/public/core/v3/login
    [System.Collections.Hashtable] $ReturnValue = @{};
    [void] $ReturnValue.Add("Headers", @{});
    [void] $ReturnValue.Add("URLs", @{});
    [void] $ReturnValue.URLs.Add("LogIn", "https://dm-us.informaticacloud.com/saas/public/core/v3/login");
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


Function Get-IICSSession()
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
    [void] $ReturnValue.URLs.Add("LogIn", "https://dm-us.informaticacloud.com/ma/api/v2/user/login");
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
    [void] $ReturnValue.Headers.Add("INFA-SESSION-ID", $ResponseJSON.icSessionId);
    [void] $ReturnValue.URLs.Add("LogOut", ($ResponseJSON.serverUrl + "/api/v2/user/logout"));
    [void] $ReturnValue.URLs.Add("Task", ($ResponseJSON.serverUrl + "/api/v2/task"));
    [void] $ReturnValue.URLs.Add("ActivityLog", ($ResponseJSON.serverUrl + "/api/v2/activity/activityLog"));
    [void] $ReturnValue.URLs.Add("Workflow", ($ResponseJSON.serverUrl + "/api/v2/workflow"));
    [void] $ReturnValue.URLs.Add("User", ($ResponseJSON.serverUrl + "/api/v2/user"));
    [void] $ReturnValue.URLs.Add("Connection", ($ResponseJSON.serverUrl + "/api/v2/connection"));
    
    Return $ReturnValue;
}

Function Get-IICSConnections()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session
    )
    [System.Collections.ArrayList] $RetrunValue = [System.Collections.ArrayList]::new();

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri $Session.URLs.Connection -Headers $Session.Headers -Method Get;
    $ResponseJSON = ConvertFrom-Json -InputObject $Response.Content;
    If ($ResponseJSON.Length -gt 0)
    {
        ForEach ($Connection In $ResponseJSON)
        {
            [System.Collections.Hashtable] $Object = [System.Collections.Hashtable]::new();
            [void] $Object.Add("ConnectionType", (?: {[System.String]::IsNullOrEmpty($Connection.type)} {[System.String]::Empty} {$Connection.type}));
            [void] $Object.Add("Description", (?: {[System.String]::IsNullOrEmpty($Connection.description)} {[System.String]::Empty} {$Connection.description}));
            [void] $Object.Add("CreateTime", (?: {[System.String]::IsNullOrEmpty($Connection.createTime)} {[System.String]::Empty} {$Connection.createTime}));
            [void] $Object.Add("UpdateTime", (?: {[System.String]::IsNullOrEmpty($Connection.updateTime)} {[System.String]::Empty} {$Connection.updateTime}));
            [void] $Object.Add("CreatedBy", (?: {[System.String]::IsNullOrEmpty($Connection.createdBy)} {[System.String]::Empty} {$Connection.createdBy}));
            [void] $Object.Add("UpdatedBy", (?: {[System.String]::IsNullOrEmpty($Connection.updatedBy)} {[System.String]::Empty} {$Connection.updatedBy}));
            [void] $Object.Add("Host", (?: {[System.String]::IsNullOrEmpty($Connection.host)} {[System.String]::Empty} {$Connection.host}));
            [void] $Object.Add("InstanceName", (?: {[System.String]::IsNullOrEmpty($Connection.instanceName)} {[System.String]::Empty} {$Connection.instanceName}));
            [void] $Object.Add("AdjustedJDBCHostName", (?: {[System.String]::IsNullOrEmpty($Connection.adjustedJdbcHostName)} {[System.String]::Empty} {$Connection.adjustedJdbcHostName}));
            [void] $Object.Add("Port", (?: {[System.String]::IsNullOrEmpty($Connection.port)} {[System.String]::Empty} {$Connection.port}));
            [void] $Object.Add("Database", (?: {[System.String]::IsNullOrEmpty($Connection.database)} {[System.String]::Empty} {$Connection.database}));
            [void] $Object.Add("Schema", (?: {[System.String]::IsNullOrEmpty($Connection.schema)} {[System.String]::Empty} {$Connection.schema}));
            [void] $Object.Add("UserName", (?: {[System.String]::IsNullOrEmpty($Connection.username)} {[System.String]::Empty} {$Connection.username}));
            [void] $RetrunValue.Add($Object);
        }
    }
    Return $RetrunValue;
}

Function Get-IICSTasks()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session
    )
    [System.Collections.ArrayList] $RetrunValue = [System.Collections.ArrayList]::new();

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host $Session.URLs.Task;
    $Response = Invoke-WebRequest -Uri $Session.URLs.Task -Headers $Session.Headers -Method Get;
    $Response.Content | Out-File -FilePath "C:\Users\bmorris\Documents\IICS\temp.json";
    $ResponseJSON = ConvertFrom-Json -InputObject $Response.Content;
    If ($ResponseJSON.Length -gt 0)
    {
        ForEach ($Connection In $ResponseJSON)
        {
            [System.Collections.Hashtable] $Object = [System.Collections.Hashtable]::new();
            [void] $Object.Add("ConnectionType", (?: {[System.String]::IsNullOrEmpty($Connection.type)} {[System.String]::Empty} {$Connection.type}));
            [void] $Object.Add("Description", (?: {[System.String]::IsNullOrEmpty($Connection.description)} {[System.String]::Empty} {$Connection.description}));
            [void] $Object.Add("CreateTime", (?: {[System.String]::IsNullOrEmpty($Connection.createTime)} {[System.String]::Empty} {$Connection.createTime}));
            [void] $Object.Add("UpdateTime", (?: {[System.String]::IsNullOrEmpty($Connection.updateTime)} {[System.String]::Empty} {$Connection.updateTime}));
            [void] $Object.Add("CreatedBy", (?: {[System.String]::IsNullOrEmpty($Connection.createdBy)} {[System.String]::Empty} {$Connection.createdBy}));
            [void] $Object.Add("UpdatedBy", (?: {[System.String]::IsNullOrEmpty($Connection.updatedBy)} {[System.String]::Empty} {$Connection.updatedBy}));
            [void] $Object.Add("Host", (?: {[System.String]::IsNullOrEmpty($Connection.host)} {[System.String]::Empty} {$Connection.host}));
            [void] $Object.Add("InstanceName", (?: {[System.String]::IsNullOrEmpty($Connection.instanceName)} {[System.String]::Empty} {$Connection.instanceName}));
            [void] $Object.Add("AdjustedJDBCHostName", (?: {[System.String]::IsNullOrEmpty($Connection.adjustedJdbcHostName)} {[System.String]::Empty} {$Connection.adjustedJdbcHostName}));
            [void] $Object.Add("Port", (?: {[System.String]::IsNullOrEmpty($Connection.port)} {[System.String]::Empty} {$Connection.port}));
            [void] $Object.Add("Database", (?: {[System.String]::IsNullOrEmpty($Connection.database)} {[System.String]::Empty} {$Connection.database}));
            [void] $Object.Add("Schema", (?: {[System.String]::IsNullOrEmpty($Connection.schema)} {[System.String]::Empty} {$Connection.schema}));
            [void] $Object.Add("UserName", (?: {[System.String]::IsNullOrEmpty($Connection.username)} {[System.String]::Empty} {$Connection.username}));
            [void] $RetrunValue.Add($Object);
        }
    }
    Return $RetrunValue;
}


Function Export-IICSConnections()
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
