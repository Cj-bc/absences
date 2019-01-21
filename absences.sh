#!/usr/bin/env bash
#
# absences -- manage your absences
#
# Copyright 2019 (c) Cj-bc a.k.a Cj.bc_sd
# This software is released under MIT License
#
# @(#) version 0.0.1

EX_DATAERR=65
EX_SUCCESS=0
ABSENCES_DATAFILE="$HOME/.config/absences/data"
ABSENCES_CONFIGFILE="$HOME/.config/absences/config"
ABSENCES_SELFDIR="${BASH_SOURCE[0]%/*}"

# functions {{{

# absences.version: show version info from source code {{{
function absences.version()
{
  local self="${ABSENCES_SELFDIR}/absences.sh"
  local versionline
  versionline="$(grep "# @(#) version" < "$self" | head -n 1)"
  echo "${versionline/\# @(\#)/absences:}"
  return $EX_SUCCESS
}
# }}}

# readConfig: read config file {{{2
# @param <string key>
# @return <string value>
function readConfig()
{
  local key=$0
  local value
  value=$(shyaml get-value alert_line.default "$key" < "$ABSENCES_CONFIGFILE" 2>/dev/null) || return $EX_DATAERR
  echo "$value"
  return $EX_SUCCESS
}
# }}}

# resolveDate: resolve date format {{{2
# @param <string data>
# @return <string resolved_data>

function resolveDate()
{
  case "$1" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ) echo "$1";;
    -[0-9]* ) echo "$(($(date +%Y%m%d) - ${1#-}))";;
    "today") date +%Y%m%d;;
    "yesterday") echo "$(($(date +%Y%m%d) -1))";;
    * ) return $EX_DATAERR;;
  esac
  return $EX_SUCCESS
}
# }}}

# highlight: add hightlight to the output {{{2
function highlight()
{
  # TODO: I' do this later
  if [ -p /dev/stdin ];then
    input=$(cat -)
    echo "$input"
  fi
  return $EX_SUCCESS
}
# }}}

# writeData: Write data to raw-data file {{{2
# @param <string category> <string data>
# @return 0 success
# @return 65 parameter error
function writeData()
{
  local category="$1"
  local datenumber
  datenumber="$(resolveDate "$2")"

  {
    grep "$category" "$ABSENCES_DATAFILE" 2>/dev/null &&
    [[ $datenumber =~ [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]]
  } || return $EX_DATAERR

  local temp; temp="$(mktemp)"
  sed "s/\(${category}: .*$\)/\1 $datenumber/" "$ABSENCES_DATAFILE" > "$temp"
  cat "$temp" > "$ABSENCES_DATAFILE" && rm "$temp"

  return $EX_SUCCESS
}
# }}}

# writeConfig: Write config file {{{2
# @param <string category> <string limit>
# @return 0 success
function writeData.addCategory()
{
  if [ "$#" -eq 1 ];then
    echo "${1}:" >> "$ABSENCES_DATAFILE"
  else
    echo "${1}: ${2}:" >> "$ABSENCES_DATAFILE"
  fi
  return $EX_SUCCESS
}
# }}}

# alert: echo list of alearted categories {{{2
function alert()
{
  local regex_limit="[^:]*:"
  local alerted_list=()
  local alert_line=5 # TODO: pull this from config
  local category limit data absences remain
  while read -r category limit data;do
    [[ "$limit" =~ $regex_limit ]] || continue
    category=${category%:}
    absences=${#data[@]}
    remain=$((limit - absences))

    if [[ $remain -lt $alert_line ]]; then
      alerted_list+=("$category: $remain")
    fi
  done < "$ABSENCES_DATAFILE"

  echo "${alerted_list[@]}" | highlight
}
# }}}

# }}}


# main loop {{{
main() {
for obj in "$@";do
  case "$obj" in
    "add")
      shift
      case "$1" in
        "category" )shift; writeData.addCategory "$@";;
        "absent" )shift; writeData "$@";;
        * )shift; writeData "$@";;
      esac
      break
      ;;
    "alreat") alert; break;;
    "--help"|"-h"|"help" ) absence.help; break;;
    "-v"|"--version"|"version") absences.version; break;;
  esac
done
}
# }}}

main "$@"
