#!/bin/bash
reposHomePath="/c/Users/$(whoami)/source/repos"

repo-list(){
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
	done < $reposHomePath/.paths
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
	done < $reposHomePath/.users
	echo '---------  ---------------------  ---------------------------------------------------------------'
	echo
	echo 'To set user for the current directory use the following:'
	echo '  repo user {Name}'
	echo
	echo 'To see all users for for all defined repos use the following:'
	echo '  repo allusers'

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
	done < $reposHomePath/.paths
	gitUserName=$(git config --global user.name)
	gitUserEmail=$(git config --global user.Email)
	echo "Global Setting:"
	echo "  Git User Name: $gitUserName"
	echo "  Git Email Name: $gitUserEmail"
	cd $currentDir
}

repo-open(){
	repopath=$(awk -v FS="$1=" 'NF>1{print $2}' $reposHomePath/.paths)
	cd $repopath
}

repo-add(){
	repopath=$(awk -v fs="$1=" 'nf>1{print $2}' $reposHomePath/.paths)
	if [ -z "${repopath}" ]
	then
		printf '%s=%s\n' $1 $PWD >> $reposHomePath/.paths
		printf 'Adding Repo Alias\n\t%s=%s' $repoAlias $PWD
	else
		printf '"%s" is already in use!' $1
	fi
}

repo-listuser() {
	gitUserName=$(git config --local user.name)
	gitUserEmail=$(git config --local user.Email)
	echo "Current Settings:"
	echo "  Git User Name: $gitUserName"
	echo "  Git Email Name: $gitUserEmail"
}

repo-user(){
	gitUserNameEmail=$(awk -v FS="$1=" 'NF>1{print $2}' $reposHomePath/.users)
	readarray -d , -t gitUserArray <<<"$gitUserNameEmail"
	gitUserName="${gitUserArray[0]}"
	gitUserEmail="${gitUserArray[1]}"
	echo "Setting GIT User:"
	echo "  Git User Name: $gitUserName"
	echo "  Git Email Name: $gitUserEmail"
	git config --local user.name "$gitUserName"
	git config --local user.email "$gitUserEmail"
}

repo-listglobaluser() {
	gitUserName=$(git config --global user.name)
	gitUserEmail=$(git config --global user.Email)
	echo "Current Settings:"
	echo "  Git User Name: $gitUserName"
	echo "  Git Email Name: $gitUserEmail"
}

repo-globaluser(){
	gitUserNameEmail=$(awk -v FS="$1=" 'NF>1{print $2}' $reposHomePath/.users)
	readarray -d , -t gitUserArray <<<"$gitUserNameEmail"
	gitUserName="${gitUserArray[0]}"
	gitUserEmail="${gitUserArray[1]}"
	git config --global user.name "$gitUserName"
	git config --global user.email "$gitUserEmail"
}

repo-vs(){
	devenv="/c/Program Files (x86)/Microsoft Visual Studio/2019/Professional/Common7/IDE/devenv.exe"
	repoDirName=${PWD##*/}
	solfile=$(awk -v FS="$repoDirName=" 'NF>1{print $2}' $reposHomePath/.vspaths)
	if [ ! -f "$solfile" ]
	then
		solfile=${PWD##*/}".sln"
	fi
	if [ ! -f "$solfile" ]
	then
		solfile=${PWD}
	fi
	echo "Opening $solfile"
	"$devenv" "$solfile" &
}

repo-iis(){
	iispath="/c/Program Files/IIS Express/iisexpress.exe"
	siteName=${PWD##*/} 
	"$iispath" -site:$siteName &
}

repo-cap(){
	commitMessage=$1
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
}

repo-graph(){
	git log --graph --full-history -10 --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
}

repo-clone(){
	gitURL="$1"
	gitRepoName=$(basename $gitURL .git)
	gitDirectory="$reposHomePath/"$2"/"
	cd "$gitDirectory"
	git clone $gitURL $gitRepoName
	gitDirectory="$reposHomePath/"$2"/"$gitRepoName
	cd "$gitDirectory"
	repo-user $4
	repo-add $3
}

repo-showusage() {
	echo
	echo '***REPO FUNCTIONS USAGE********************************************************'
	echo '*                                                                             *'
	echo '*  List detailed information about the repos configs.                         *'
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
}

repo-ws() {
	currentDir=$PWD
	workspace=$(awk -v FS="$1=" 'NF>1{print $2}' $reposHomePath/.workspaces)
	IFS=,
	for repoName in $workspace
	do
		repo-open $repoName
		repo-vs
	done
	cd "$currentDir"
	cd "$currentDir"
}

repo() {
	if [ $# -lt 1 ]
	then
		repo-showusage
	else
		if [ $1 == "help" ]
		then
			repo-showusage
		elif [ $1 == "open" ]
		then
			repo-open $2
		elif [ $1 == "ws" ]
		then
			repo-openws $2
		elif [ $1 == "add" ]
		then
			showUsage="false"
			repo-add $2
		elif [ $1 == "list" ]
		then
			repo-list
		elif [ $1 == "vs" ]
		then
			repo-vs
		elif [ $1 == "iis" ]
		then
			repo-iis
		elif [ $1 == "cap" ]
		then
			repo-cap $2
		elif [ $1 == "graph" ]
		then
			repo-graph
		elif [ $1 == "user" ]
		then
			if [ $# -lt 2 ]
			then
				repo-listuser
			else
				repo-user
			fi
		elif [ $1 == "globaluser" ]
		then
			if [ $# -lt 2 ]
			then
				repo-listglobaluser
			else
				repo-globaluser
			fi
		elif [ $1 == "clone" ]
		then
			if [ $# -lt 5 ]
			then
				repo-showusage
			else
				repo-clone $2 $3 $4 $5
			fi
		elif [ $1 == "allusers" ]
		then
			repo-list
		else
			repo-showusage
		fi
	fi
}