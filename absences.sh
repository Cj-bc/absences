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
ABSENCE_DATAFILE="$HOME/.config/absences/data"
ABSENCE_CONFIGFILE="$HOME/.config/absences/config"

# utility functions {{{

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
    grep "$category" "$ABSENCE_DATAFILE" 2>/dev/null &&
    [[ $datenumber =~ [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]]
  } || return $EX_DATAERR

  local temp; temp="$(mktemp)"
  sed "s/\(${category}: .*$\)/\1 $datenumber/" "$ABSENCE_DATAFILE" > "$temp"
  cat "$temp" > "$ABSENCE_DATAFILE" && rm "$temp"

  return $EX_SUCCESS
}
# }}}

# writeConfig: Write config file {{{2
# @param <string category> <string limit>
# @return 0 success
function writeData.addCategory()
{
  if [ "$#" -eq 1 ];then
    echo "${1}:" >> $ABSENCE_DATAFILE
  else
    echo "${1}: ${2}:" >> $ABSENCE_DATAFILE
  fi
  return $EX_SUCCESS
}
# }}}

}
# }}}

# }}}


# main loop {{{
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
    "alreat") aleart; break;;
    "--help"|"-h"|"help" ) absence.help; break;;
  esac
done
# }}}
