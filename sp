#!/bin/bash

# ARG_OPTIONAL_SINGLE([hostname],[],[The default hostname of your server],[])
# ARG_OPTIONAL_BOOLEAN([prune],[p],[Prune docker networks])
# ARG_OPTIONAL_BOOLEAN([clean],[c],[Start from a clean StreamPipes session])
# ARG_POSITIONAL_MULTI([operation],[The StreamPipes operation (start|stop|restart|clean|add|remove|cleanstart|update|list) (service-name)],[2],[nil],[nil])
# ARG_DEFAULTS_POS()
# ARG_HELP([This script provides advanced features to run StreamPipes on your server])
# ARG_VERSION([echo This is the StreamPipes dev installer v0.1])
# ARGBASH_SET_INDENT([  ])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.7.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
  local _ret=$2
  test -n "$_ret" || _ret=1
  test "$_PRINT_HELP" = yes && print_help >&2
  echo "$1" >&2
  exit ${_ret}
}


begins_with_short_option()
{
  local first_option all_short_options='pchv'
  first_option="${1:0:1}"
  test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_operation=("nil" "nil")
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_hostname=
_arg_prune="off"
_arg_clean="off"


print_help()
{
  printf '%s\n' "This script provides advanced features to run StreamPipes on your server"
  printf 'Usage: %s [--hostname <arg>] [-p|--(no-)prune] [-c|--(no-)clean] [-h|--help] [-v|--version] [<operation-1>] [<operation-2>]\n' "$0"
  printf '\t%s\n' "<operation>: The StreamPipes operation (start|stop|restart|clean|add|remove|cleanstart|update|list) (service-name) (defaults for <operation-1> to <operation-2> respectively: 'nil' and 'nil')"
  printf '\t%s\n' "--hostname: The default hostname of your server (no default)"
  printf '\t%s\n' "-p, --prune, --no-prune: Prune docker networks (off by default)"
  printf '\t%s\n' "-c, --clean, --no-clean: Start from a clean StreamPipes session (off by default)"
  printf '\t%s\n' "-h, --help: Prints help"
  printf '\t%s\n' "-v, --version: Prints version"
}


parse_commandline()
{
  _positionals_count=0
  while test $# -gt 0
  do
    _key="$1"
    case "$_key" in
      --hostname)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_hostname="$2"
        shift
        ;;
      --hostname=*)
        _arg_hostname="${_key##--hostname=}"
        ;;
      -p|--no-prune|--prune)
        _arg_prune="on"
        test "${1:0:5}" = "--no-" && _arg_prune="off"
        ;;
      -p*)
        _arg_prune="on"
        _next="${_key##-p}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          begins_with_short_option "$_next" && shift && set -- "-p" "-${_next}" "$@" || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -c|--no-clean|--clean)
        _arg_clean="on"
        test "${1:0:5}" = "--no-" && _arg_clean="off"
        ;;
      -c*)
        _arg_clean="on"
        _next="${_key##-c}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          begins_with_short_option "$_next" && shift && set -- "-c" "-${_next}" "$@" || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -h|--help)
        print_help
        exit 0
        ;;
      -h*)
        print_help
        exit 0
        ;;
      -v|--version)
        echo This is the StreamPipes dev installer v0.1
        exit 0
        ;;
      -v*)
        echo This is the StreamPipes dev installer v0.1
        exit 0
        ;;
      *)
        _last_positional="$1"
        _positionals+=("$_last_positional")
        _positionals_count=$((_positionals_count + 1))
        ;;
    esac
    shift
  done
}


handle_passed_args_count()
{
  test "${_positionals_count}" -le 2 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 0 and 2, but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
  local _positional_name _shift_for=$1
  _positional_names="_arg_operation[0] _arg_operation[1] "

  shift "$_shift_for"
  for _positional_name in ${_positional_names}
  do
    test $# -gt 0 || break
    eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
    shift
  done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


getIp() {
	rawip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

	rawip=`echo $rawip | sed 's/(%s)*\n/ /g'`
	IFS=' ' declare -a 'allips=($rawip)'

	allips+=( 'Enter IP manually' )

	# if default selected do not show promt

	if [ $_arg_hostname ] ;
	then
		ip=$_arg_hostname
		echo 'Default IP was selected: '${ip}
	else
		echo ''
		echo 'Please select your IP address or add one manually: '
		PS3='Select option: '
		select opt in "${allips[@]}"
		do
			if [ -z "${opt}" ];
			then
				echo "Wrong input, select one of the options";
			else
				ip="$opt"

				if [ "$opt" == "Enter IP manually" ];
				then
					read -p "Enter Ip: " ip
				fi
				break
			fi
		done
	fi

}


getCommand() {
	command="docker-compose -f docker-compose.yml"
	while IFS='' read -r line || [[ -n "$line" ]]; do
		command="$command -f ./services/$line/docker-compose.yml"
	done < "./system"
}

startStreamPipes() {
	docker stop $(docker ps -a -q)
	docker network prune -f
	getIp
	sed "s/##IP##/${ip}/g" ./tmpl_env > .env
	getCommand
	$command up -d
}

updateStreamPipes() {
	getCommand
	$command up -d
}

stopStreamPipes() {
	getCommand
	$command down
}

cleanStreamPipes() {
	stopStreamPipes
	rm -r ./config
    echo 'StreamPipes clean'
}

listServices() {
cd services
for dir in */ ; do
  echo $dir | sed "s/\///g"
done
cd ..
}

removeService() {
	sed -i "" /${_arg_operation[1]}/d ./system
}

addService() {
	echo ${_arg_operation[1]} >> ./system
	updateStreamPipes
}

if [ "$_arg_operation" = "start" ];
then
	startStreamPipes
	echo 'StreamPipes sucessfully started'
fi

if [ "$_arg_operation" = "stop" ];
then
	stopStreamPipes
	echo 'StreamPipes sucessfully stopped'

fi

if [ "$_arg_operation" = "restart" ];
then
	stopStreamPipes
	startStreamPipes
	echo 'StreamPipes sucessfully restarted'

fi

if [ "$_arg_operation" = "clean" ];
then
	cleanStreamPipes
	echo All configurations of StreamPipes are deleted
fi

if [ "$_arg_operation" = "add" ];
then
	addService
	echo Add Service ${_arg_operation[1]}
fi

if [ "$_arg_operation" = "remove" ];
then
	removeService
	echo Remove service ${_arg_operation[1]}
fi

if [ "$_arg_operation" = "cleanstart" ];
then
	cleanStreamPipes
	startStreamPipes

	echo 'All configurations of StreamPipes are deleted and StreamPipes is restarted'
fi

if [ "$_arg_operation" = "list" ];
then
	listServices
fi

if [ "$_arg_operation" = "nil" ];
then
	print_help
fi

# ] <-- needed because of Argbash
