#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/

# 当域名发生变化时执行nginx重启 若无变化则休眠5分钟后再次检测
# 使用文本储存需要检测的域名 脚本执行时先检测文本内域名得到的ip 同时与上一个保存的ip进行匹配
# 若相同则执行supersord restart nginx 并将ip保存到文本中替换原有ip
# 若不相同 休眠

#实现读取文件

#将文件路径储存到file变量中
file='/root/keepalivedomain/domain.txt'
config_file='/app/lazy_balancer/service/supervisord.conf'
#转发记录格式:域名1+域名2+IP缓存
#例子:
#abc.com abcd.com 11.22.33.44 11.22.33.44

check_txt(){
    if [ -f ${file} ]; then
    #如果存在则休眠
    echo -e "域名文件存在,程序继续执行"
    sleep 1
    else
    #不存在 输出错误日志
    echo -e "域名文件不存在，即将退出脚本..."
    exit 1
    fi
}

#读取文件
run_record(){
    #根据文件行数执行while循环
    while read -r line || [[ -n $line ]];do
    #第一个与第二个字段为域名 读取当前行的第某个字段
    domain1=$(echo $line | awk '!/#/{printf$1"\n"}')
    domain2=$(echo $line | awk '!/#/{printf$2"\n"}')
    #第三个字段为缓存IP
    ip1_old=$(echo $line | awk '!/#/{printf$3"\n"}')
    #读取nslookup域名1结果的第二个字段
    ip1_new=$(nslookup ${domain1}|grep Add |awk '!/#/{printf$2"\n"}')
    #第四个字段为缓存IP
    ip2_old=$(echo $line | awk '!/#/{printf$4"\n"}')
    #读取nslookup域名2结果的第二个字段
    ip2_new=$(nslookup ${domain2}|grep Add |awk '!/#/{printf$2"\n"}')
    echo "domian1 old ip: ${ip1_old}"
    echo "domain1 new ip: ${ip1_new}"
    echo "domian2 old ip: ${ip2_old}"
    echo "domain2 new ip: ${ip2_new}"
    done < ${file}
    check_domain
}

#将旧IP与新IP进行比较
check_domain(){
    #检查ip1
        if [ "${ip1_new}" = "${ip1_old}" ]
        then
                echo "domain1未发生变化"
        else #如果域名ip与缓存ip不匹配则执行某些动作
                echo "domain1发生变化"
                supervisorctl -c ${config_file} restart nginx
                sleep 60
                #用新解析IP替换旧的记录
                sed -i 's/'"${ip1_old}"'/'"${ip1_new}"'/g' ${file}
                exit 1
        fi
        #检查ip2
        if [ "${ip2_new}" = "${ip2_old}" ]
        then
                echo "domain2未发生变化"
        else #如果域名ip与缓存ip不匹配则执行某些动作
                echo "domain2发生变化"
                supervisorctl -c ${config_file} restart nginx
                sleep 60
                #用新解析IP替换旧的记录
                sed -i 's/'"${ip2_old}"'/'"${ip2_new}"'/g' ${file}
                exit 1
        fi
}

check_txt
run_record