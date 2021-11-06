# keepalivedomain

当域名发生变化时执行nginx重启
若无变化则休眠5分钟后再次检测

使用文本储存需要检测的域名
脚本执行时先检测文本内域名得到的ip
同时与上一个保存的ip进行匹配

若相同则执行supersord restart nginx
并将ip保存到文本中替换原有ip

若不相同 休眠

# 安装
centos通过dnf安装依赖
dnf install bind-utils
debian通过apt安装依赖
apt install dnsutils


# 脚本定时运行
crontab -e
每隔一分钟运行一次
*/1 * * * * /root/keepalivedomian/keepdomain.sh