#!/bin/bash
#第一次写shell脚本 好紧张

#首先当然是要安装nslookup检测工具啦
#centos====dnf install bind-utils debian&ubuntu apt install dnsutils

# 检查系统
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
}

check_soft(){
    if dpkg -l | grep dnsutils != null; then
    exit
}
#安装检测工具
install(){
    if [[ "${release}" == "centos" ]]; then
        result = dpkg -l | grep dnsutils
        exit 0
        else
        dnf install bind-utils -y
    fi
    if [[ "${release}" == "ubuntu" || "${release}" == "debian" ]]; then
        if [[]]
    fi
}




check_sys
install
