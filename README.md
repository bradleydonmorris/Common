# Common

This is a private repository of SQL, PowerShell and other script that I use or reference regularly.

To create the **repo** function, add the contents of [**RepositoryBashFunctions.sh**](https://github.com/bradleydonmorris/Common/blob/master/RepositoryBashFunctions.sh) to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile**.

Some of these commands utilize the **.paths** file outlined below.
1. **`repo open bdmj`**: opens the repo directory specified in the **.paths** file with the provided alias. (bdmj in this case.)
2. **`repo list`**: lists the contents of the **.paths** file formatted for display.
3. **`repo add myRepo`**: adds the current directory to the **.paths** with the provided alias. (myRepo in this case)
4. **`repo vs`**: opens Visual Studio. If a **.sln** file exists in the current directory named after the current directory, it will open that solution. Otherwise it will open the current directory.
5. **`repo iis`**: starts IIS Express server for the site defined in **C:\Users\\%username%\Documents\IISExpress\config\applicationhost.config** where the site name matches the current directory name.
6. **`repo cap [message]`**: commits and pushes the current repository/directory. The message is optional. If not provided, one will be generated.


Sample **/c/Users/$(whoami)/source/repos/.paths** file contents. Adjust as needed.
```shell
common=/c/Users/bradley.morris/source/repos/bradleydonmorris/Common
bdmme=/c/Users/bradley.morris/source/repos/bradleydonmorris/BradleyDonMorris.me
ghbdm=/c/Users/bradley.morris/source/repos/bradleydonmorris/bradleydonmorris
jt=/c/Users/bradley.morris/source/repos/bradleydonmorris/JournalTemplate
plm=/c/Users/bradley.morris/source/repos/PLM
mfs=/c/Users/bradley.morris/source/repos/MainframeService
```

To make CAP.ps1 executable from Git Bash for Windows, add the following lines to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile.d\aliases.sh**.

```shell
alias cap='powershell -File /c/Users/$(whoami)/source/repos/bradleydonmorris/Common/CAP.ps1'
```

Additional aliases that may be needed...
```shell
alias glg='git log --graph --full-history -10 --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
```
