# Common \ PowerShell \ Functions

[Common](https://github.com/bradleydonmorris/Common) \ PowerShellPowerShell

This is a private repository of SQL, PowerShell and other script that I use or reference regularly.

*Remember to replace **{username}** with the appropriate Windows user name.*


To make PowerShell functions usable throughout your PowerShell profile, add the following line to **C:\Users\\{username}\Documents\WindowsPowerShell\profile.ps1**.

`Get-ChildItem -Filter "*.ps1" -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions")) | %{. $_.FullName }`

