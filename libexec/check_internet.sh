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
EXTERNAL_IP=8.8.8.8

# nagios return values
GOOD=0
WARNING=1
CRITICAL=2
UNKNOWN=3

check_ping() {
  GOOD_PING=0
  for count in {1..5}; do
    [[ $(ping -c1 ${EXTERNAL_IP}) ]] && ((GOOD_PING++))
  done
  return $(( 100 - $((${GOOD_PING} * 20))  ))
}

get_pub_ip() {
  PUB_IP=$(curl -4 icanhazip.com 2>/dev/null)
}

check_internet_ping() {

  check_ping
  PING_RESULT=$?

  case $PING_RESULT in
    100|80) 
         STATUS='CRITICAL'
         EXIT_STATUS=${CRITICAL}
         MESSAGE="Connection has ${PING_RESULT}% packet loss"
         ;;
    60|40) 
        STATUS='WARNING'
        EXIT_STATUS=${WARNING}
        MESSAGE="Connection has ${PING_RESULT}% packet loss"
        ;;
    20|0) 
        STATUS='OK'
        EXIT_STATUS=${GOOD}
        get_pub_ip
        MESSAGE="Connection established with ${PING_RESULT}% packet loss. IP Address is ${PUB_IP}"
        ;;
  esac

}

if [[ $(which speedtest-cli) ]]; then
  timeout 5 speedtest-cli --list --secure &> /dev/null
  RESULT=$?
  if [[ ${RESULT} -eq 0  ]]; then
    get_pub_ip
    STATUS='OK'
    EXIT_STATUS=${GOOD}
    MESSAGE="Connection established. IP Address is ${PUB_IP}"
  else
    check_internet_ping
  fi
else
  # speedtest-cli is not installed
  check_internet_ping
fi

echo "Internet ${STATUS} - ${MESSAGE}"

exit ${EXIT_STATUS}
