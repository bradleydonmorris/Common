# Common

This is a private repository of SQL, PowerShell and other script that I use or reference regularly.

To create the **orep** function, add the following line to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile**

```
orep() {
  repopath=$(awk -v FS="$1=" 'NF>1{print $2}' /c/Users/$(whoami)/source/repos/.paths)
  cd $repopath
}
```

To make CAP.ps1 executable from Git Bash for Windows, add the following line to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile.d\aliases.sh**.

```
alias cap='powershell -File /c/Users/$(whoami)/source/repos/bradleydonmorris/Common/CAP.ps1'
```

Additional aliases that may be needed...
```
alias glg='git log --graph --full-history -10 --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
```

