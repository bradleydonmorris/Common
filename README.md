# Common

This is a private repository of SQL, PowerShell and other script that I use or reference regularly.


To make CAP.ps1 executable from Git Bash for Windows, add the following line to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile.d\aliases.sh**.

```
alias cap='powershell -File /c/Users/$(whoami)/source/repos/bradleydonmorris/Common/CAP.ps1'
```

To create the **orep** function, add the following line to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile**

```
orep() {
  repopath=$(awk -v FS="$1=" 'NF>1{print $2}' /c/Users/$(whoami)/source/repos/.paths)
  cd $repopath
}
```

