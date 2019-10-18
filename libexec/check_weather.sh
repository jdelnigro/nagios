#!/bin/bash

###################################
#
# Weather report in Nagios
# James DelNigro
# 10 December 2018
#
##################################

# Nagios Return codes
# 0 => OK
# 1 => WARNING
# 2 => CRITICAL
# 3 => UNKNOWN

# Variables
PROG=$(basename $0)
LOCATION="Winchester,VA"
# LOCATION="McMurdo,Antarctica"
SNOW_VAL=0

# nagios return values
GOOD=0
WARNING=1
CRITICAL=2
UNKNOWN=3

usage() {

cat <<EOF
Usage: ${PROG} [OPTIONS]

Checks weather for a specified location

Options:

  -l <location>   Set the location to check the weather
  -w              Set a warning if snowing
  -h              print help messege

EOF
exit 0
}

# parse options
while getopts "l:wh" OPT; do
  case $OPT in
    l) LOCATION=${OPTARG} ;;
    w) SNOW_VAL=1 ;;
    h) usage ;;
    \?) echo "ERROR: Invallid option"; usage ;; 
  esac
done

curl -sSIf wttr.in &>/dev/null
CONNECTION_STATUS=$?

case ${CONNECTION_STATUS} in
  0)
    WEATHER=$(curl -sSf http://wttr.in/${LOCATION}?format="%c+(%C)+%t+%w+%h")
    echo "${LOCATION}: ${WEATHER} humidity"
    grep -i 'snow' <<< ${WEATHER} >/dev/null && \
      RETVAL=${SNOW_VAL} || \
      RETVAL=${GOOD}
    ;;
  1|3|5|6)
    printf "Connection error.\n"
    RETVAL=${CRITICAL}
    ;;
  *)
    printf "Unknown error.\n"
    RETVAL=${UNKNOWN}
    ;;
esac

exit ${RETVAL}
