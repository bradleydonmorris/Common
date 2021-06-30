#!/bin/bash

#/c/Users/$(whoami)

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
			repopath=$(awk -v FS="$2=" 'NF>1{print $2}' ~/source/repos/.paths)
			cd $repopath
		elif [ $1 == "add" ]
		then
			showUsage="false"
			repopath=$(awk -v fs="$2=" 'nf>1{print $2}' ~/source/repos/.paths)
			if [ -z "${repopath}" ]
			then
				printf '%s=%s\n' $2 $PWD >> ~/source/repos/.paths
				printf 'Adding Repo Alias\n\t%s=%s' $repoAlias $PWD
			else
				printf '"%s" is already in use!' $2
			fi
		elif [ $1 == "list" ]
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
			done < ~/source/repos/.paths
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
			done < ~/source/repos/.users
			echo '---------  ---------------------  ---------------------------------------------------------------'
			echo
			echo 'To set user for the current directory use the following:'
			echo '  repo user {Name}'
			echo
			echo 'To see all users for for all defined repos use the following:'
			echo '  repo allusers'
		elif [ $1 == "vs" ]
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
		elif [ $1 == "iis" ]
		then
			showUsage="false"
			iispath="/c/Program Files/IIS Express/iisexpress.exe"
			siteName=${PWD##*/} 
			"$iispath" -site:$siteName &
		elif [ $1 == "cap" ]
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
		elif [ $1 == "graph" ]
		then
			showUsage="false"
			git log --graph --full-history -10 --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
		elif [ $1 == "user" ]
		then
			showUsage="false"
			if [ $# -lt 2 ]
			then
				gitUserName=$(git config --local user.name)
				gitUserEmail=$(git config --local user.Email)
				echo "Current Settings:"
				echo "  Git User Name: $gitUserName"
				echo "  Git Email Name: $gitUserEmail"
			else
				gitUserNameEmail=$(awk -v FS="$2=" 'NF>1{print $2}' ~/source/repos/.users)
				readarray -d , -t gitUserArray <<<"$gitUserNameEmail"
				gitUserName="${gitUserArray[0]}"
				gitUserEmail="${gitUserArray[1]}"
				git config --local user.name "$gitUserName"
				git config --local user.email "$gitUserEmail"
			fi
		elif [ $1 == "globaluser" ]
		then
			showUsage="false"
			if [ $# -lt 2 ]
			then
				gitUserName=$(git config --global user.name)
				gitUserEmail=$(git config --global user.Email)
				echo "Current Settings:"
				echo "  Git User Name: $gitUserName"
				echo "  Git Email Name: $gitUserEmail"
			else
				gitUserNameEmail=$(awk -v FS="$2=" 'NF>1{print $2}' ~/source/repos/.users)
				readarray -d , -t gitUserArray <<<"$gitUserNameEmail"
				gitUserName="${gitUserArray[0]}"
				gitUserEmail="${gitUserArray[1]}"
				git config --global user.name "$gitUserName"
				git config --global user.email "$gitUserEmail"
			fi
		elif [ $1 == "clone" ]
		then
			if [ $# -lt 5 ]
			then
				showUsage="true"
			else
				showUsage="false"
				gitURL="$2"
				gitRepoName=$(basename $gitURL .git)
				gitDirectory="$HOME/source/repos/"$3"/"
				cd "$gitDirectory"
				git clone $gitURL $gitRepoName
				gitDirectory="$HOME/source/repos/"$3"/"$gitRepoName
				cd "$gitDirectory"

				gitUserNameEmail=$(awk -v FS="$5=" 'NF>1{print $2}' ~/source/repos/.users)
				readarray -d , -t gitUserArray <<<"$gitUserNameEmail"
				gitUserName="${gitUserArray[0]}"
				gitUserEmail="${gitUserArray[1]}"
				echo "Setting GIT User:"
				echo "  Git User Name: $gitUserName"
				echo "  Git Email Name: $gitUserEmail"
				git config --local user.name "$gitUserName"
				git config --local user.email "$gitUserEmail"

				repoAlias="$4"
				repopath=$(awk -v fs="$repoAlias=" 'nf>1{print $2}' ~/source/repos/.paths)
				if [ -z "${repopath}" ]
				then
					printf '%s=%s\n' $repoAlias $PWD >> ~/source/repos/.paths
					printf 'Adding Repo Alias\n\t%s=%s' $repoAlias $PWD
				else
					printf '"%s" is already in use!' $repoAlias
				fi
			fi
		elif [ $1 == "allusers" ]
		then
			showUsage="false"
			currentDir=$PWD
			while IFS="" read -r line || [ -n "$line" ]
			do
				readarray -d = -t lineArray <<<"$line"
				name=${lineArray[0]//[$'\t\r\n ']}
				value=${lineArray[1]//[$'\t\r\n ']}
				cd $value
				gitUserName=$(git config --local user.name)
				gitUserEmail=$(git config --local user.Email)
				echo "Repo: $name"
				echo "  Path: $value"
				echo "  Git User Name: $gitUserName"
				echo "  Git Email Name: $gitUserEmail"
				echo
			done < ~/source/repos/.paths
			gitUserName=$(git config --global user.name)
			gitUserEmail=$(git config --global user.Email)
			echo "Global Setting:"
			echo "  Git User Name: $gitUserName"
			echo "  Git Email Name: $gitUserEmail"
			cd $currentDir
		else
			showUsage="true"
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
		echo '*  Clone a GIT repo and set it up for use with the "repo" functions.          *'
		echo '*  (All arguments are required.)                                              *'
		echo '*    repo clone {URL} {org} {alias} {user}                                    *'
		echo '*                                                                             *'
		echo '*******************************************************************************'
	fi
}