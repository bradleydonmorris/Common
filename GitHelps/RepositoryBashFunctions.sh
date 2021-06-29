#!/bin/bash

repo() {
	showUsage="true"
	if [ $# -lt 1 ]
	then
		showUsage="true"
	else
		if [ $1 == "help" ]
		then
			showUsage="true"
		elif [ $1 == "open" ]
		then
			showUsage="false"
			repopath=$(awk -v FS="$2=" 'NF>1{print $2}' /c/Users/$(whoami)/source/repos/.paths)
			cd $repopath
		fi
		if [ $1 == "add" ]
		then
			showUsage="false"
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
			showUsage="false"
			echo
			echo '---REPO DIRECTORY LIST---------------------------------------------------------------------------'
			echo 'Name       Path'
			echo '---------  --------------------------------------------------------------------------------------'
			namePad='           '
			while IFS="" read -r line || [ -n "$line" ]
			do
				readarray -d = -t lineArray <<<"$line"
				name=${lineArray[0]}
				value=${lineArray[1]}
				printf '%s%s%s' "$name" "${namePad:${#name}}" "$value"
			done < /c/Users/$(whoami)/source/repos/.paths
			echo '---------  --------------------------------------------------------------------------------------'
			echo
			echo 'To chanage to a repo directory use the following:'
			echo '  repo open {Name}'
			echo
			echo 'To add the current directory to .paths use the following:'
			echo '  repo add {Name}'
			echo
			echo
			echo '---REPO USER LIST--------------------------------------------------------------------------------'
			echo 'Name       User Name,User Email'
			echo '---------  --------------------------------------------------------------------------------------'
			while IFS="" read -r line || [ -n "$line" ]
			do
				readarray -d = -t lineArray <<<"$line"
				name=${lineArray[0]}
				value=${lineArray[1]}
				printf '%s%s%s' "$name" "${namePad:${#name}}" "$value"
				#"$gitUserEmail"
			done < /c/Users/$(whoami)/source/repos/.users
			echo '---------  ---------------------  ---------------------------------------------------------------'
			echo
			echo 'To set user for the current directory use the following:'
			echo '  repo user {Name}'
		fi
		if [ $1 == "vs" ]
		then
			showUsage="false"
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
			showUsage="false"
			iispath="/c/Program Files/IIS Express/iisexpress.exe"
			siteName=${PWD##*/} 
			"$iispath" -site:$siteName &
		fi
		if [ $1 == "cap" ]
		then
			showUsage="false"
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
			showUsage="false"
			git log --graph --full-history -10 --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
		fi
		if [ $1 == "user" ]
		then
			showUsage="false"
			if [ $# -lt 2 ]
			then
				gitUserName=$(git config --local user.name)
				gitUserEmail=$(git config --local user.Email)
				echo "Current Settings:"
				echo "  Git User Name: $gitUserEmail"
				echo "  Git Email Name: $gitUserEmail"
			else
				gitUserNameEmail=$(awk -v FS="$2=" 'NF>1{print $2}' /c/Users/$(whoami)/source/repos/.users)
				readarray -d , -t gitUserArray <<<"$gitUserNameEmail"
				gitUserName="${gitUserArray[0]}"
				gitUserEmail="${gitUserArray[1]}"
				git config --local user.name "$gitUserName"
				git config --local user.email "$gitUserEmail"
			fi
		fi
	fi
	if [ $showUsage == "true" ]
	then
		echo
		echo '***REPO FUNCTIONS USAGE********************************************************'
		echo '*                                                                             *'
		echo '*  List the directories in .paths.                                            *'
		echo '*    repo list                                                                *'
		echo '*                                                                             *'
		echo '*  Chanage to a repo directory listed in .paths.                              *'
		echo '*    repo open {Name}                                                         *'
		echo '*                                                                             *'
		echo '*  Add the current directory to .paths.                                       *'
		echo '*    repo add {Name}                                                          *'
		echo '*                                                                             *'
		echo '*  Gets or set the GIT user for the current repo based on the list in .users. *'
		echo '*    repo user {Name}                                                         *'
		echo '*                                                                             *'
		echo '*  Launch Visual Studio for the current directory.                            *'
		echo '*    repo vs                                                                  *'
		echo '*                                                                             *'
		echo '*  Launch IIS Express for the current directory.                              *'
		echo '*    repo iis                                                                 *'
		echo '*                                                                             *'
		echo '*  Commit and push the GIT repo in the current directory.                     *'
		echo '*    repo cap [Message]                                                       *'
		echo '*                                                                             *'
		echo '*  Display commit graph of the GIT repo in the current directory.             *'
		echo '*    repo graph                                                               *'
		echo '*                                                                             *'
		echo '*******************************************************************************'
	fi
}