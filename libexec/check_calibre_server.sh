#!/bin/bash

set -o pipefail

function usage {
    echo "Usage: check_calibre-serverstatus.sh -p twitter_username]"
    echo
    echo "Options:"
    echo "-h, --help"
    echo "   Print detailed usage information"
    echo "-H, --host"
    echo "   Hostname where calibre-server runs"
    echo "-p, --port"
    echo "   Port for calibre-server status page"
    exit
}

if [ $# = 0 ]; then
    echo "UNKNOWN - missing parameters, see -h, --help"
    exit 3
fi

while [ "$1" != "" ]; do
    case $1 in
        -p | --port )           shift
                                PORT=$1
                                ;;
        -H | --host )           shift
                                HOST=$1
                                ;;
        -h | --help )           usage
                                exit 
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

STATUS=0

BKS=$(curl -s ${HOST}:${PORT}/ajax/search?num=0 | grep total_num | tr , "\n" | awk '/total_num/ {print $NF}') || STATUS=2
if [ $((STATUS)) -eq 0 ]; then
    echo "calibre-server OK - ${BKS} books"
elif [ $((STATUS)) -eq 2 ]; then
    echo "calibre-server unreachable"
fi

exit $STATUS
