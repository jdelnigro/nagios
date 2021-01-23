#!/bin/bash

##################################################
#
#      Check internet connection with nagios
#
#      Author: James DelNigro
#
#      11 August 2020
#
#################################################


# Nagios Return codes
# 0 => OK
# 1 => WARNING
# 2 => CRITICAL
# 3 => UNKNOWN

# Variables
PROG=$(basename $0)

# nagios return values
GOOD=0
WARNING=1
CRITICAL=2
UNKNOWN=3


if [[ $(which speedtest-cli) ]]; then
  timeout 5 speedtest-cli --list &> /dev/null
  RESULT=$?
  if [[ ${RESULT} -eq 0  ]]; then
    PUB_IP=$(curl -4 icanhazip.com 2>/dev/null)
    STATUS='OK'
    EXIT_STATUS=${GOOD}
    MESSAGE="Internet connection established. IP Address is ${PUB_IP}"
  else
    STATUS='CRITICAL'
    EXIT_STATUS=${CRITICAL}
    MESSAGE="No connection to internet"
  fi
else
  STATUS='UNKNOWN'
  EXIT_STATUS=${UNKNOWN}
  MESSAGE="speedtest-cli is not installed"
fi

printf "Internet ${STATUS} - ${MESSAGE}\n"

exit ${EXIT_STATUS}
