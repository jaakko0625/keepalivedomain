#!/bin/bash

# 当域名发生变化时执行nginx重启 若无变化则休眠5分钟后再次检测
# 使用文本储存需要检测的域名 脚本执行时先检测文本内域名得到的ip 同时与上一个保存的ip进行匹配
# 若相同则执行supersord restart nginx 并将ip保存到文本中替换原有ip
# 若不相同 休眠

#实现读取文件

#将文件路径储存到file变量中
file='/keepalivedomain/domain.txt'

check_txt(){
    if[ -f ${file}]; then
    #如果存在则休眠
    sleep 1
    else
    #不存在 输出错误日志
    echo -e "域名文件不存在，即将退出脚本..."
    exit 1
    fi
}

check_txt