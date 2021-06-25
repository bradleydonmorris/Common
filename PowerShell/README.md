# Common \ PowerShell

[Common](https://github.com/bradleydonmorris/Common) \ PowerShell

This is a private repository of SQL, PowerShell and other script that I use or reference regularly.

To make PowerShell functions usable throughout your PowerShell profile, add the following line to **C:\Users\\%username%\Documents\WindowsPowerShell\profile.ps1**.

```powershell
Get-ChildItem -Filter "*.ps1" -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions")) | %{. $_.FullName }
```

