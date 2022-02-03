# Common \ SQL Agent Scripting

[Common](https://github.com/bradleydonmorris/Common) \ SQL Agent Scripting

- Script.ps1

  - Is used to script out all SQL Agent objects on the chosen SQL instances.

- config.json

  - Is used to define the instances to script Agent objects from.

  - Sample :

    ```json
    {
    	"RemoteGITBranch": "master",
    	"Instances":
    	[
    		"SQLSERVER1",
    		"SQLSERVER2\\Accounting"
    	]
    }
    ```




A separate script for each object is created and stored in a folder structure exemplified below. Illegal path characters will be removed from the names and replaced with "_".

```
SQLAgentScripting                             -This should be the root GIT repository folder
    \Script.ps1
    \config.json
    \SERVER1                                  -A separate folder will be created for each SQL instance
        \1-Operators                          -    object type (Operators, Alerts, and Jobs)
            \[Uncategorized]                  -    and category
                \DBA.sql                      -A separate file will be created for each object
        \2-Alerts
            \Dang Developers
                \Deadlock.sql
        \3-Jobs
            \Database Maintenance
                \Do The Backups.sql
                \Rebuild those indexes.sql
    \SERVER2_Accounting                       -Note the use of and underscore in place of the backslash in the instance name.
        \1-Operators
            \[Uncategorized]
                \DBA.sql
        \2-Alerts
            \Poor Code Writing Errors
                \Deadlock.sql
        \3-Jobs
            \Database Maintenance
                \Do The Backups.sql
                \Rebuild those indexes.sql
            \Fin Jobs
                \CreateGLDump.sql
```

