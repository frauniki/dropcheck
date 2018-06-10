#!/bin/bash

source lib/main.sh

if [ "$1" == "" ] ; then
    http_check
elif [ "$1" == "--kame" ] ; then
    kame_check
else
    echo "Error:option is (None) or --kame."
fi