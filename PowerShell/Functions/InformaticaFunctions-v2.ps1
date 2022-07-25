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
Function Get-IICSv2Session()
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
    [void] $ReturnValue.Headers.Add("icSessionId", $ResponseJSON.icSessionId);
    [void] $ReturnValue.URLs.Add("LogOut", ($ResponseJSON.serverUrl + "/api/v2/user/logout"));
    [void] $ReturnValue.URLs.Add("Mapping", ($ResponseJSON.serverUrl + "/api/v2/mapping"));
    [void] $ReturnValue.URLs.Add("MappingTask", ($ResponseJSON.serverUrl + "/api/v2/mttask"));
    [void] $ReturnValue.URLs.Add("ActivityLog", ($ResponseJSON.serverUrl + "/api/v2/activity/activityLog"));
    [void] $ReturnValue.URLs.Add("Workflow", ($ResponseJSON.serverUrl + "/api/v2/workflow"));
    [void] $ReturnValue.URLs.Add("User", ($ResponseJSON.serverUrl + "/api/v2/user"));
    [void] $ReturnValue.URLs.Add("Connection", ($ResponseJSON.serverUrl + "/api/v2/connection"));
    [void] $ReturnValue.URLs.Add("Schedule", ($ResponseJSON.serverUrl + "/api/v2/schedule"));
    
    Return $ReturnValue;
}
Function Get-IICSv2Connections()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri $Session.URLs.Connection -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}
Function Get-IICSv2Connection()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$true)]
        [System.String] $Id,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri ($Session.URLs.Connection + "/" + $Id) -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}
Function Get-IICSv2Mappings()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri $Session.URLs.Mapping -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}
Function Get-IICSv2Mapping()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$true)]
        [System.String] $Id,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri ($Session.URLs.Mapping + "/" + $Id) -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}
Function Get-IICSv2MappingTasks()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri $Session.URLs.MappingTask -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}

Function Get-IICSv2MappingTask()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$true)]
        [System.String] $Id,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri ($Session.URLs.MappingTask + "/" + $Id) -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}

Function Get-IICSv2Workflows()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri $Session.URLs.Workflow -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}

Function Get-IICSv2Workflow()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$true)]
        [System.String] $Id,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri ($Session.URLs.Workflow + "/" + $Id) -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}

Function Get-IICSv2Schedules()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri $Session.URLs.Schedule -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}

Function Get-IICSv2Schedule()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $Session,

        [Parameter(Mandatory=$true)]
        [System.String] $Id,

        [Parameter(Mandatory=$false)]
        [System.String] $Output
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-WebRequest -Uri ($Session.URLs.Schedule + "/" + $Id) -Headers $Session.Headers -Method Get;
    If (![String]::IsNullOrEmpty($Output))
    {
        [IO.File]::WriteAllText($Output, $Response.Content);
    }
    Return $Response.Content;
}






