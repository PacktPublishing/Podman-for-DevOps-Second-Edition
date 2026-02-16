#!/bin/sh 

set -euo pipefail 

if [ $UID != 0 ]; then 
    echo "Running as user $UID" 
fi 

if [ "$1" == "httpd" ]; then 
    echo "Starting custom httpd server" 
    exec $1 -DFOREGROUND 
else 
    echo "Starting container with custom arguments" 
    exec "$@" 
fi 