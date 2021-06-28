repo() {
	if [ $# -lt 1 ]
	then
		echo 'List the directories in .paths:'
		echo '  repo add {Name}'
		echo
		echo 'Chanage to a repo directory listed in .paths:'
		echo '  repo open {Name}'
		echo
		echo 'Add the current directory to .paths:'
		echo '  repo add {Name}'
		echo
		echo 'Launch Visual Studio for the current directory:'
		echo '  repo add {Name}'
		echo
		echo 'Launch IIS Express for the current directory:'
		echo '  repo add {Name}'
	else
		if [ $1 == "open" ]
		then
			repopath=$(awk -v FS="$2=" 'NF>1{print $2}' /c/Users/$(whoami)/source/repos/.paths)
			cd $repopath
		fi
		if [ $1 == "add" ]
		then
			repopath=$(awk -v fs="$2=" 'nf>1{print $2}' /c/users/$(whoami)/source/repos/.paths)
			if [ -z "${repopath}" ]
			then
				printf '%s=%s\n' $2 $pwd >> /c/users/$(whoami)/source/repos/.paths
				printf 'adding\n\t%s=%s' $2 $pwd
			else
				printf '"%s" is already in use!' $2
			fi
		fi
		if [ $1 == "list" ]
		then
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
			iispath="/c/Program Files/IIS Express/iisexpress.exe"
			siteName=${PWD##*/} 
			"$iispath" -site:$siteName &
		fi
	fi
}