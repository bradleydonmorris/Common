ForEach ($Folder In (Get-ChildItem -Path "C:\Users\bradley.morris\source\repos\K9SearchOK"))
{
    If (Test-Path -Path (Join-Path -Path $Folder.FullName -ChildPath ".git\config"))
    {
        
        If (Select-String -Path (Join-Path -Path $Folder.FullName -ChildPath ".git\config") -Pattern "[user]" -SimpleMatch -Quiet)
        {
            Write-Host -Object ("Has It: " + (Join-Path -Path $Folder.FullName -ChildPath ".git\config"));
        }
        Else
        {
            Write-Host -Object ("Needs It: " + (Join-Path -Path $Folder.FullName -ChildPath ".git\config"));
            Add-Content -Path (Join-Path -Path $Folder.FullName -ChildPath ".git\config") -Value "`n[user]`n`tname = Bradley Morris`n`temail = bradleydonmorris@hotmail.com`n";
        }
    }
}
