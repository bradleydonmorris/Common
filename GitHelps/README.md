# Common \ PowerShell

[Common](https://github.com/bradleydonmorris/Common) \ GitHelps

To create the **repo** function, add the following line to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile**.

```shell
source /c/Users/$(whoami)/source/repos/bradleydonmorris/Common/GitHelps/RepositoryBashFunctions.sh
```

Some of the commands in the **repo** function utilize the **.paths** file outlined below.
1. **`repo open bdmj`**: opens the repo directory specified in the **.paths** file with the provided alias. (bdmj in this case.)
2. **`repo list`**: lists the contents of the **.paths** file formatted for display.
3. **`repo add myRepo`**: adds the current directory to the **.paths** with the provided alias. (myRepo in this case)
4. **`repo vs`**: opens Visual Studio. If a **.sln** file exists in the current directory named after the current directory, it will open that solution. Otherwise it will open the current directory as a folder in Visual Studio.
5. **`repo iis`**: starts IIS Express server for the site defined in **C:\Users\\%username%\Documents\IISExpress\config\applicationhost.config** where the site name matches the current directory name.
6. **`repo cap [message]`**: commits and pushes the current repository/directory. The message is optional. If not provided, one will be generated.
(USE WITH CARE. WILL NOT SET UPSTREAM BRANCH!)
7. **`repo graph`**: displays simple graph history for the current repository/directory.


Sample **/c/Users/$(whoami)/source/repos/.paths** file contents. Adjust as needed.
```shell
common=/c/Users/bradley.morris/source/repos/bradleydonmorris/Common
bdmme=/c/Users/bradley.morris/source/repos/bradleydonmorris/BradleyDonMorris.me
ghbdm=/c/Users/bradley.morris/source/repos/bradleydonmorris/bradleydonmorris
jt=/c/Users/bradley.morris/source/repos/bradleydonmorris/JournalTemplate
gitt=/c/Users/bradley.morris/source/repos/bradleydonmorris/GitTesting
```
