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
  echo
  echo 'To add the current directory to .paths use the following:'
  echo '  arep {Name}'
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

vsl() {
  devenv="/c/Program Files (x86)/Microsoft Visual Studio/2019/Professional/Common7/IDE/devenv.exe"
  solfile=${PWD##*/}".sln"
  if [ -f $solfile ]
  then
    "$devenv" "${PWD}/${solfile}" &
  else
    "$devenv" "${PWD}" &
  fi
}