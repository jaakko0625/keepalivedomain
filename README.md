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
debian && ubuntu 通过apt安装依赖
apt install dnsutils

下载脚本
git clone https://github.com/jaakko0625/keepalivedomain
进入脚本目录 授予可执行权限
cd ./keepalivedomain/ && chmod +x ./keepalivedomain.sh
执行脚本
./keepalivedomain.sh

# 脚本定时运行
crontab -e
每隔一分钟运行一次
*/1 * * * * /bin/bash /root/keepalivedomain/keepalivedomain.sh > /root/keepalivedomain/log.log 2>&1

每天早上六点执行一次
00 */6 * * *  bash /root/ddns.sh >> /root/ddns.log 2>&1