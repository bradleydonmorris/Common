#!/bin/bash

repo() {
	showUsage="false"
	if [ $# -lt 1 ]
	then
		showUsage="false"
	else
		if [ $1 == "help" ]
		then
			showUsage="false"
		elif [ $1 == "open" ]
		then
			showUsage="true"
			repopath=$(awk -v FS="$2=" 'NF>1{print $2}' /c/Users/$(whoami)/source/repos/.paths)
			cd $repopath
		fi
		if [ $1 == "add" ]
		then
			showUsage="true"
			repopath=$(awk -v fs="$2=" 'nf>1{print $2}' /c/users/$(whoami)/source/repos/.paths)
			if [ -z "${repopath}" ]
			then
				printf '%s=%s\n' $2 $PWD >> /c/users/$(whoami)/source/repos/.paths
				printf 'adding\n\t%s=%s' $2 $PWD
			else
				printf '"%s" is already in use!' $2
			fi
		fi
		if [ $1 == "list" ]
		then
			showUsage="true"
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
			echo '  repo open {Name}'
			echo
			echo 'To add the current directory to .paths use the following:'
			echo '  repo add {Name}'
		fi
		if [ $1 == "vs" ]
		then
			showUsage="true"
			devenv="/c/Program Files (x86)/Microsoft Visual Studio/2019/Professional/Common7/IDE/devenv.exe"
			solfile=${PWD##*/}".sln"
			if [ -f $solfile ]
			then
				"$devenv" "${PWD}/${solfile}" &
			else
				"$devenv" "${PWD}" &
			fi
		fi
		if [ $1 == "iis" ]
		then
			showUsage="true"
			iispath="/c/Program Files/IIS Express/iisexpress.exe"
			siteName=${PWD##*/} 
			"$iispath" -site:$siteName &
		fi
		if [ $1 == "cap" ]
		then
			showUsage="true"
			commitMessage=$2
			changeCount=$(git status --porcelain=v1 | wc -l)
			if [ "$changeCount" != "0" ]
			then
				if [ -z "$commitMessage" ]
				then
					commitMessage=$(date --utc +"%Y-%m-%d %H:%M:%S.%N")" "$(whoami)", CAP Operation"
				fi
				git add .
				git commit --message "$commitMessage"
				git push
			else
				echo "No changes found."
			fi
		fi
		if [ $1 == "graph" ]
		then
			showUsage="true"
			git log --graph --full-history -10 --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
		fi
	fi
	if [ $showUsage == "false" ]
	then
		echo
		echo '***REPO FUNCTIONS USAGE*********************************************'
		echo '*                                                                  *'
		echo '*  List the directories in .paths.                                 *'
		echo '*    repo list                                                     *'
		echo '*                                                                  *'
		echo '*  Chanage to a repo directory listed in .paths.                   *'
		echo '*    repo open {Name}                                              *'
		echo '*                                                                  *'
		echo '*  Add the current directory to .paths.                            *'
		echo '*    repo add {Name}                                               *'
		echo '*                                                                  *'
		echo '*  Launch Visual Studio for the current directory.                 *'
		echo '*    repo add {Name}                                               *'
		echo '*                                                                  *'
		echo '*  Launch IIS Express for the current directory.                   *'
		echo '*    repo add {Name}                                               *'
		echo '*                                                                  *'
		echo '*  Commit and push the GIT repo in the current directory.          *'
		echo '*    repo cap [Message]                                            *'
		echo '*                                                                  *'
		echo '*  Display commit graph of the GIT repo in the current directory.  *'
		echo '*    repo graph                                                    *'
		echo '*                                                                  *'
		echo '********************************************************************'
	fi
}