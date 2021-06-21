#!/usr/bin/env pwsh
[String] $GITRemoteShowOrigin = git remote show origin |
    Out-String;
[String] $GITFetchURL = $GITRemoteShowOrigin.Split("`n")[1].Replace("  Fetch URL: ", "");
Write-Host $("CAPing to " + $GITFetchURL);
[String] $CommitMessage = [DateTime]::UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fffffffK") + "{@Identifier} - {@Action}";
[String] $Output = git status --porcelain=v1 |
    Out-String;
If ($Output.Length -gt 0)
{
    $CommitMessage = $CommitMessage.Replace("{@Action}", "Commit and Push");
    Add-Content -Path "CAP.log" -Value $CommitMessage.Replace("{@Identifier}", " (" + $env:COMPUTERNAME + ":" + $env:USERDOMAIN + "\" + $env:USERNAME + ")");
    Add-Content -Path "CAP.log" -Value $Output;
    git add . *>$null;
    git commit --message $CommitMessage.Replace("{@Identifier}", "") *>$null;
    git push origin "master" -q *>$null
}
Else
{
    Add-Content -Path "CAP.log" -Value $CommitMessage.Replace("{@Action}", "No Changes").Replace("{@Identifier}", " (" + $env:COMPUTERNAME + ":" + $env:USERDOMAIN + "\" + $env:USERNAME + ")");
}
