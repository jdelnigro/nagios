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


# colors
RED='\e[31m'
LT_RED='\e[91m'
ORANGE='\e[38;5;208m'
YELLOW='\e[33m'
LT_GREEN='\e[92m'
GREEN='\e[32m'
RESET='\e[0m'

EXTERNAL_IP=8.8.8.8
# EXTERNAL_IP=google.com

check_ping() {
  GOOD_PING=0
  for count in {1..5}; do
    [[ $(ping -c1 ${EXTERNAL_IP}) ]] && ((GOOD_PING++))
  done
  return $(( 100 - $((${GOOD_PING} * 20))  ))
}

PUB_IP=$(curl -4 icanhazip.com 2>/dev/null)

check_ping
RESULT=$?

case $RESULT in
  100) COLOR=$RED
       STATUS='CRITICAL'
       EXIT_STATUS=2
       ;;
  80) COLOR=$LT_RED
      STATUS='CRITICAL'
      EXIT_STATUS=2
      ;;
  60) COLOR=$ORANGE
      STATUS='WARNING'
      EXIT_STATUS=1
      ;;
  40) COLOR=$YELLOW
      STATUS='WARNING'
      EXIT_STATUS=1
      ;;
  20) COLOR=$LT_GREEN
      STATUS='OK'
      EXIT_STATUS=0
      ;;
  0) COLOR=$GREEN
     STATUS='OK'
     EXIT_STATUS=0;;
esac

# printf "Internet ${STATUS} - ${COLOR}${RESULT}${RESET}%% packet loss. IP Address is ${PUB_IP}\n"
# Adjust the previous line to work in Nagios
printf "Internet ${STATUS} - ${RESULT}%% packet loss. IP Address is ${PUB_IP}\n"
