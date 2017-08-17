#!bin/bash

function run_cmd() {
    local t=`date`
    echo "$t: $1"
    eval $1
}

function ensure_dir() {
    if [ ! -d $1 ]; then
        run_cmd "mkdir -p $1"
    fi
}

function ensure_user() {
    if [ id -u $1 >/dev/null 2>&1 ]; then
        echo "user exists"
    else
        run_cmd "useradd $1 -s /sbin/nologin"
    fi
}

