#!/bin/bash

SLEEP=3

WORK_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PID_FILE="$WORK_DIR/bash_daemon.pid"

#Try get lock for pidfile or exit
exec 100>>"$PID_FILE"
flock -xn 100 || { echo "Already running. Exit"; exit 114;}

PID=$$
#write PID to pidfile
echo "$PID" >&100


#write all to log
exec 1>>"$WORK_DIR/bash_daemon.log" 2>&1
#close stdin
exec 0<&-

write_log() {
    echo "$(date '+%d.%m.%Y %H:%M:%S') - $1"
}

cleanup() {
    write_log "EXIT pid=$PID"
    return_value=$?
    rm -rf "$PID_FILE"
    exit $return_value
}


trap "cleanup" EXIT
#ignore SIGHUP when terminal closes
trap "write_log 'GET SIGHUP'" SIGHUP


write_log "START pid=$PID"

while true;
do
    #YOUR COMMAND
    sleep $SLEEP	
done;


