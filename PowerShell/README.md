# Common \ PowerShell

[Common](https://github.com/bradleydonmorris/Common) \ PowerShell

This is a private repository of PowerShell scripts that I use or reference regularly.

To make PowerShell functions usable throughout your PowerShell profile, add the following script snippet to your profile script.
 - For PowerShell 5, profile script is **C:\Users\\%username%\Documents\WindowsPowerShell\profile.ps1**.
 - For PowerShell 7, profile script is **C:\Users\\%username%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1**.

```powershell
Get-ChildItem -Filter "*.ps1" -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions")) |
	%{. $_.FullName }
```

