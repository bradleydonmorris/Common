# Common \ GitHelps

[Common](https://github.com/bradleydonmorris/Common) \ GitHelps

To create the **repo** function, add the following line to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile**.

```shell
source /c/Users/$(whoami)/source/repos/bradleydonmorris/Common/GitHelps/RepositoryBashFunctions.sh
```

1. **`repo ws bdm`**: opens the workspace which defines all the Visual Studio solutions/folders to open. (bdm in this case.)
1. **`repo open ghbdm`**: opens the repo directory specified in the **.paths** file with the provided alias. (ghbdm in this case.)
2. **`repo list`**: lists the contents of the **.paths** file formatted for display.
3. **`repo add myRepo`**: adds the current directory to the **.paths** with the provided alias. (myRepo in this case)
4. **`repo vs`**: opens Visual Studio. If a **.sln** file exists in the current directory named after the current directory, it will open that solution. Otherwise it will open the current directory as a folder in Visual Studio.
5. **`repo iis`**: starts IIS Express server for the site defined in **C:\Users\\%username%\Documents\IISExpress\config\applicationhost.config** where the site name matches the current directory name.
6. **`repo cap [message]`**: commits and pushes the current repository/directory. The message is optional. If not provided, one will be generated. This function is mainly used while on a dev or feature branch. It is not intended to be used for commit->merge->push type operations.
   _USE WITH CARE! WILL NOT SET UPSTREAM BRANCH! If you are on master/main locally and you **cap**, it will commit and push to master/main upstream._
7. **`repo graph`**: displays simple graph history for the current repository/directory.
8. **`repo user`**: gets the GIT user for the current repository/directory.
9. **`repo user bdm`**: sets the GIT user for the current repository/directory based on data in **.users**.
10. **`repo globaluser`**: gets the GIT global user.
11. **`repo user bdm`**: sets the GIT global user based on data in **.users**.

There are sample files for **[.paths](https://github.com/bradleydonmorris/Common/blob/master/GitHelps/.paths)**, **[.users](https://github.com/bradleydonmorris/Common/blob/master/GitHelps/.users)**, **[.vspaths](https://github.com/bradleydonmorris/Common/blob/master/GitHelps/.vspaths)**, and **[.workspaces](https://github.com/bradleydonmorris/Common/blob/master/GitHelps/.workspaces)**. These files should be stored in the directory defined in **$reposHomePath** in the **RepositoryBashFunctions.sh** file.
