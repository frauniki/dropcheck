#!/bin/bash

source lib/main.sh
source ./tool.conf

addr_check
pingv4
pingv6
ext_pingv4
ext_pingv6