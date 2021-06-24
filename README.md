# Common

This is a private repository of SQL, PowerShell and other script that I use or reference regularly.

To create the **orep**, **lrep**, and **arep** functions, add the following lines to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile**

```
orep() {
  repopath=$(awk -v FS="$1=" 'NF>1{print $2}' /c/Users/$(whoami)/source/repos/.paths)
  cd $repopath
}

lrep() {
  echo 'Name       Path'
  echo '---------  --------------------------------------------------------------------------------------'
  namepad='           '
  while IFS="" read -r line || [ -n "$line" ]
  do
    readarray -d = -t lineary <<<"$line"
    name=${lineary[0]}
	value=${lineary[1]}
	
    printf '%s%s%s' "$name" "${namepad:${#name}}" "$value"
  done < /c/Users/$(whoami)/source/repos/.paths
  echo '---------  --------------------------------------------------------------------------------------'
  echo
  echo 'To chanage to a repo directory use the following:'
  echo '  orep {Name}'
}

arep() {
  repopath=$(awk -v FS="$1=" 'NF>1{print $2}' /c/Users/$(whoami)/source/repos/.paths)
  if [ -z "${repopath}" ]
  then
    printf '%s=%s\n' $1 $PWD >> /c/Users/$(whoami)/source/repos/.paths
    printf 'Adding\n\t%s=%s' $1 $PWD
  else
    printf '"%s" is already in use!' $1
  fi
}
```

Sample **/c/Users/$(whoami)/source/repos/.paths** file contents. Adjust as needed.
```
common=/c/Users/bradley.morris/source/repos/bradleydonmorris/Common
bdmme=/c/Users/bradley.morris/source/repos/bradleydonmorris/BradleyDonMorris.me
ghbdm=/c/Users/bradley.morris/source/repos/bradleydonmorris/bradleydonmorris
jt=/c/Users/bradley.morris/source/repos/bradleydonmorris/JournalTemplate
plm=/c/Users/bradley.morris/source/repos/PLM
mfs=/c/Users/bradley.morris/source/repos/MainframeService
```

To make CAP.ps1 executable from Git Bash for Windows, add the following lines to **C:\Users\\%username%\AppData\Local\Programs\Git\etc\profile.d\aliases.sh**.

```
alias cap='powershell -File /c/Users/$(whoami)/source/repos/bradleydonmorris/Common/CAP.ps1'
```

Additional aliases that may be needed...
```
alias glg='git log --graph --full-history -10 --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
```
