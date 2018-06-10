#!/bin/bash

#2018/06/10 ShowNet DropCheck Tool ShellScript
#

function ext_pingv4() {
    echo -e "\e[1;37m+ IPv4 External Ping Check(8.8.8.8)\e[m"
    ping -D -s 1472 -c 3 8.8.8.8
    echo "+-------------------------------------------------------------------------------------------+"
}

function ext_pingv6() {
    echo -e "\e[1;37m+ IPv6 External Ping Check(2001:4860:4860::8888)\e[m"
    ping -D -s 1232 -c 3 2001:4860:4860::8888
    echo "+-------------------------------------------------------------------------------------------+"
}

function pingv4() {
    pingv4_addr=$gateway4
    echo -e "\e[1;37m+ IPv4 Gateway Ping Check\e[m"
    ping -D -s 1472 -c 3 $pingv4_addr
    echo "+-------------------------------------------------------------------------------------------+"
}

function pingv6() {
    pingv6_addr=$gateway6
    echo -e "\e[1;37m+ IPv6 Gateway Ping Check\e[m"
    ping -D -s 1232 -c 3 $pingv6_addr
    echo "+-------------------------------------------------------------------------------------------+"
}

function digv4() {
    echo -e "\e[1;37m+ DNS A Check\e[m"
    dns_a=`dig +short ipv4.google.com A | awk 'NR>1'`
    if [ "$dns_a" != "" ] ; then
        echo "+ DNS A Recode = ${dns_a}"
        echo -e "+ DNS A Check : \e[32mOK!\e[m"
    else
        echo -e "+ DNS A Check : \e[31mNG!\e[m"
    fi
    echo "+------------------------------------------------------------------+"
}

function digv6() {
    echo -e "\e[1;37m+ DNS AAAA Check\e[m"
    dns_aaaa=`dig +short ipv6.google.com AAAA |  awk 'NR>1'`
    if [ "$dns_aaaa" != "" ] ; then
        echo "+ DNS AAAA Recode = ${dns_aaaa}"
        echo -e "+ DNS AAAA Check : \e[32mOK!\e[m"
    else
        echo -e "+ DNS AAAA Check : \e[31mNG!\e[m"
    fi
    echo "+------------------------------------------------------------------+"
}

function http_check(){
    /opt/google/chrome/google-chrome http://ipv4.google.com http://ipv6.google.com --incognito
}

function addr_check() {
    addr4=`/sbin/ip -f inet -o addr show ${INTERFACE_NAME} | awk '{print $4}' `
    addr6=`/sbin/ip -f inet -o -6 addr show ${INTERFACE_NAME} | awk '($6 == "global"){print $4}'`
    prefix=`/sbin/ip -f inet -o -6 addr show ${INTERFACE_NAME} | awk '($6 == "global"){print $4}' | cut -d: -f1-4`
    gateway4=`ipcalc -nb $addr4 | awk '($1 == "HostMin:"){print $2}'`
    gateway6="${prefix}::1"
    echo "+------------------------------------------------------------------+"
    echo -e "+ Interface IPv4 Address = \e[35m${addr4}\e[m"
    echo "+ IPv4 Gateway Address = ${gateway4}"
    echo "+ Interface IPv6 Address = ${addr6}"
    echo -e "+ IPv6 Prefix = \e[35m${prefix}::/64\e[m"
    echo "+ IPv6 Gateway Address = ${gateway6}"
    echo "+------------------------------------------------------------------+"
}