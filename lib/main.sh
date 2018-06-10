#!/bin/bash

#2018/06/10 ShowNet DropCheck Tool ShellScript
#

source ../tool.conf

function ext_pingv4() {
    echo "+ IPv4 External Ping Check(8.8.8.8)"
    ping -D -s 1472 -c 3 8.8.8.8
}

function ext_pingv6() {
    echo "+ IPv6 External Ping Check(2001:4860:4860::8888)"
    ping -D -s 1232 -c 3 2001:4860:4860::8888
}

function pingv4() {
    pingv4_addr=$gateway4
    echo "+ IPv4 Gateway Ping Check"
    ping -D -s 1472 -c 3 $pingv4_addr
}

function pingv6() {
    pingv6_addr=$gateway6
    echo "+ IPv6 Gateway Ping Check"
    ping -D -s 1232 -c 3 $pingv6_addr
}

function digv4() {
    echo "+------------------------------------------------------------------+"
    echo "+ DNS A Check"
    dns_a=`dig +short ipv4.google.com A | awk 'NR>1'`
    if [ "$dns_a" != "" ] ; then
        echo "+ DNS A Recode = ${dns_a}"
        echo -e "+DNS A Check : \e[32mOK!\e[m"
    else
        echo -e "+DNS A Check : \e[31mNG!\e[m"
    fi
}

function digv6() {
    echo "+------------------------------------------------------------------+"
    echo "+ DNS AAAA Check"
    dns_aaaa=`dig +short ipv6.google.com AAAA |  awk 'NR>1'`
    if [ "$dns_aaaa" != "" ] ; then
        echo "+ DNS AAAA Recode = ${dns_aaaa}"
        echo -e "+DNS AAAA Check : \e[32mOK!\e[m"
    else
        echo -e "+DNS AAAA Check : \e[31mNG!\e[m"
    fi
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
    echo "+ Interface IPv4 Address = ${addr4}"
    echo "+ IPv4 Gateway Address = ${gateway4}"
    echo "+ Interface IPv6 Address = ${addr6}"
    echo "+ IPv6 Prefix ${prefix}::/64"
    echo "+ IPv6 Gateway Address = ${gateway6}"
    echo "+------------------------------------------------------------------+"
}