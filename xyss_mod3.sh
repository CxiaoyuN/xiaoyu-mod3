#!/bin/bash
#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
install_lnmp1.3_mod(){
    clear
	echo
	echo "#############################################################################"
	echo "#                    安装SS-Panel-Mod3环境lnmp1.3                           #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master    #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	yum -y remove httpd
	yum install -y unzip zip
	wget -c https://raw.githubusercontent.com/CxiaoyuN/xiaoyu-mod3/master/lnmp1.3-mod.zip && unzip lnmp1.3-mod.zip && cd lnmp1.3-mod && chmod +x install.sh && ./install.sh lnmp
	rm -rf /root/lnmp1.3-mod.zip
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
	echo "################################################################################"
	echo "# lnmp1.3-mod安装成功    添加/列出/删除虚拟机lnmp vhost add/list/del           #"
	echo "# 安装域名版前端则需要添加虚拟机lnmp vhost add ；IP版则不需要                  #"
	echo "# 数据库：http://${IPAddress}/phpmyadmin                                       #"
	echo "# Author: 小羽                                                                 #"
	echo "# QQ群: 600573662                                                              #"
	echo "################################################################################"
}
install_TCP_BBR(){
    clear
	echo
	echo "#############################################################################"
	echo "#                    安装SS-Panel-Mod3环境加速器TCP-BBR                     #"
	echo "# Github: https://github.com/teddysun/across                                #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
	chmod +x bbr.sh
	./bbr.sh
	echo "################################################################################"
	echo "# SS-Panel-Mod3环境加速器TCP-BBR 安装成功                                      #"
	echo "# 输入 y 并回车后重启,输入以下命令：uname -r验证是否成功安装最新内核。         #"
	echo "# 输入以下命令：lsmod | grep bbr，返回值有 tcp_bbr 模块即说明bbr已启动。       #"
	echo "# Author: 小羽                                                                 #"
	echo "# QQ群: 600573662                                                              #"
	echo "################################################################################"
}
install_TCP_BBR_MOD(){
    clear
	echo
	echo "#############################################################################"
	echo "#                  安装SS-Panel-Mod3环境加速器TCP-BBR魔改版                 #"
    echo "#                    仅仅支持 Debian8,Debian9,Ubuntu16.04	                  #"
	echo "# Github: https://moeclub.org/2017/06/24/278                                #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	wget --no-check-certificate -qO 'BBR_POWERED.sh' 'https://moeclub.org/attachment/LinuxShell/BBR_POWERED.sh'
	chmod a+x BBR_POWERED.sh
	bash BBR_POWERED.sh
	echo "################################################################################"
	echo "# SS-Panel-Mod3环境加速器TCP-BBR魔改版 安装成功                                #"
	echo "# 输入 y 并回车后重启,输入以下命令：uname -r验证是否成功安装最新内核。         #"
	echo "# 输入以下命令：lsmod | grep bbr，返回值有 tcp_bbr 模块即说明bbr已启动。       #"
	echo "# Author: 小羽                                                                 #"
	echo "# QQ群: 600573662                                                              #"
	echo "################################################################################"
}
install_SSL(){
    clear
	echo
	echo "#############################################################################"
	echo "#                           安装SSL证书                                     #"
	echo "#       除非你会手动自己搞，不然就按说明来 （xiaoyu.com改成自己的）         #"
	echo "#例如ss-panel-mod3的前端面板，站点地址例如www.xiaoyu.com 站点目录public     #"
	echo "#例如ss-panel-mod3的问答系统，站点地址例如help.xiaoyu.com 站点目录Wecenter  #"
	echo "#例如Whmcs，站点地址例如whmcs.xiaoyu.com  站点目录whmcs                     #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	key='yes';
	echo "设置站点地址" 
    echo "输入站点地址:"
    read -p "(默认: www.xiaoyu.com):" yuming
    [ -z "$yuming" ] && yuming="www.xiaoyu.com"
	echo
	echo "设置站点目录" 
    echo "输入站点目录:"
    read -p "(默认: public):" mulu
    [ -z "$mulu" ] && mulu="public"
	echo
	echo -e "\033[0;1;35m创建SSL证书目录\033[0m"
	mkdir /etc/ssl/web
	echo -e "\033[0;1;35m设置nginx文件\033[0m"
	rm -rf /usr/local/nginx/conf/vhost/$yuming.conf
	wget -O /usr/local/nginx/conf/vhost/$yuming.conf https://raw.githubusercontent.com/CxiaoyuN/eg-save-mod/new_master/www.xiaoyu.com.conf
	sed -i "s#yuming#$yuming#" /usr/local/nginx/conf/vhost/$yuming.conf
	sed -i "s#mulu#$mulu#" /usr/local/nginx/conf/vhost/$yuming.conf
	echo -e "\033[0;1;35m设置完成\033[0m"
	cd
	echo -n -e "赶紧上传证书到/etc/ssl/web中，你上传成功了吗？成功就输yes [\033[32m $key \033[0m] ："
	read PASSWD
	readkey=$PASSWD
	if [[ ${readkey%%\ *} == $key ]]
	then
	echo
	echo -e '\033[32m你上传成功了吗！\033[0m即将重启nginx...'
	sleep 1
	service nginx restart
	echo -e "\033[0;1;35mnginx重启成功\033[0m"
	else
	echo
	echo -e '\033[31m上传都不会，那你仔细看看下面的！\033[0m'
	sleep 1
	echo
	exit
	echo "#######################################################################################"
	echo "# 将你的证书名称重命名改成对应的域名名称。并将证书一个crt和key文件放入/etc/ssl/web中  #"
	echo "# 然后输入 service nginx restart ，你的网址为httpS://$yuming                          #"
	echo "# 成功就不用看，失败就仔细看！成功就不用看，失败就仔细看！成功就不用看，失败就仔细看！#"
	echo "# Author: 小羽                                                                        #"
	echo "# QQ群: 600573662                                                                     #"
	echo "#######################################################################################"
	fi

}
install_ss_panel_mod_v3_old(){
    clear
	echo
	echo "#############################################################################"
	echo "#                    安装SS-Panel-Mod3前端面板IP版                          #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master    #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	echo -e "\033[0;1;35m数据设置\033[0m"
	echo "-------------------------------------------"
	echo "设置数据库密码lnmp是面板设置的" 
    echo "输入lnmp设置的数据库密码:"
    read -p "(默认: root):" lnmppasswd
    [ -z "$lnmppasswd" ] && lnmppasswd="root"
	echo "-------------------------------------------"
	echo "设置站点名称" 
    echo "输入站点名称:"
    read -p "(默认: 小羽SSR云控):" WZName
    [ -z "$WZName" ] && WZName="小羽SSR云控"
	echo
	echo "设置站点地址" 
    echo "输入站点地址:"
    read -p "(默认: www.xiaoyu.com):" yuming
    [ -z "$yuming" ] && yuming="www.xiaoyu.com"
	echo
	echo "设置对接密匙" 
    echo "输入对接密匙:"
    read -p "(默认: xiaoyu):" QHKEY
    [ -z "$QHKEY" ] && QHKEY="xiaoyu"
	echo
	echo "设置邮箱（默认的QQ邮箱）" 
    echo "输入QQ邮箱:"
    read -p "(默认: xiaoyu@qq.com):" useremail
    [ -z "$useremail" ] && useremail="xiaoyu@qq.com"
	echo
	echo "设置邮箱密码（邮箱stpm密码）" 
    echo "输入邮箱stmp密码:"
    read -p "(默认: xiaoyu007):" stmpmm
    [ -z "$stmpmm" ] && stmpmm="xiaoyu007"
	echo
	echo "设置备份邮箱" 
    echo "输入备份邮箱:"
    read -p "(默认: xiaoyubeifen@qq.com):" beifenemail
    [ -z "$beifenemail" ] && beifenemail="xiaoyubeifen@qq.com"
	echo
	echo "设置备份文件密码" 
    echo "输入备份文件密码:"
    read -p "(默认: xiaoyu007):" zippassword
    [ -z "$zippassword" ] && zippassword="xiaoyu007"
    echo "-------------------------------------------"
	mkdir /home/wwwroot/backups
	cd /home/wwwroot/default/
	yum install git -y
	rm -rf index.html
	wget https://raw.githubusercontent.com/CxiaoyuN/xiaoyu-mod3/master/ss.panel_mod.zip && unzip -q ss.panel_mod.zip
	wget -O /home/wwwroot/default/public/ssr-download/Shadowrocket-2.1.10.ipa https://github.com/CxiaoyuN/xiaoyu-mod3/raw/master/Shadowrocket-2.1.10.ipa
	wget -O /home/wwwroot/default/public/ssr-download/ShadowsocksR-Android.zip https://github.com/CxiaoyuN/xiaoyu-mod3/raw/master/ShadowsocksR-Android.zip
	wget -O /home/wwwroot/default/public/ssr-download/ShadowsocksR-win.zip https://github.com/CxiaoyuN/xiaoyu-mod3/raw/master/ShadowsocksR-win.zip
	wget -O /home/wwwroot/default/public/ssr-download/ShadowsocksX-NG-R8.dmg https://github.com/CxiaoyuN/xiaoyu-mod3/raw/master/ShadowsocksX-NG-R8.dmg
	chattr -i .user.ini
	mv .user.ini public
	chown -R root:root *
	chmod -R 777 *
	chown -R www:www storage
	chattr +i public/.user.ini
	wget -N -P  /usr/local/nginx/conf/ https://github.com/CxiaoyuN/xiaoyu-mod3/raw/master/nginx.conf 
	service nginx restart
	yum install perl-DBI freeradius freeradius-mysql freeradius-utils -y
	mysql -uroot -p$lnmppasswd -e"CREATE USER 'radius'@'%' IDENTIFIED BY 'root';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO 'radius'@'%';" 
	mysql -uroot -p$lnmppasswd -e"create database radius;" 
	mysql -uroot -p$lnmppasswd -e"use radius;" 
	mysql -uroot -p$lnmppasswd radius < /home/wwwroot/default/sql/radius.sql
	mysql -uroot -p$lnmppasswd -e"CREATE USER 'ss-panel-radius'@'%' IDENTIFIED BY 'root';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO 'ss-panel-radius'@'%';" 
	mysql -uroot -p$lnmppasswd -e"CREATE USER 'sspanel'@'%' IDENTIFIED BY 'root';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO 'sspanel'@'%';" 
	mysql -uroot -p$lnmppasswd -e"create database sspanel;" 
	mysql -uroot -p$lnmppasswd -e"use sspanel;" 
	mysql -uroot -p$lnmppasswd sspanel < /home/wwwroot/default/sql/glzjin_all.sql
	\cp /home/wwwroot/default/sql/sql.conf /etc/raddb/sql.conf
	sed -i "s#WZName#$WZName#" /home/wwwroot/default/config/.config.php
	sed -i "s#yuming#$yuming#" /home/wwwroot/default/config/.config.php
	sed -i "s#QHKEY#$QHKEY#" /home/wwwroot/default/config/.config.php
	sed -i "s#useremail#$useremail#" /home/wwwroot/default/config/.config.php
	sed -i "s#stmpmm#$stmpmm#" /home/wwwroot/default/config/.config.php
	sed -i "s#beifenemail#$beifenemail#" /home/wwwroot/default/config/.config.php
	sed -i "s#zippassword#$zippassword#" /home/wwwroot/default/config/.config.php
	wget https://github.com/glzjin/Radius-install/raw/master/radiusd.conf -O /etc/raddb/radiusd.conf
	wget https://github.com/glzjin/Radius-install/raw/master/default -O /etc/raddb/sites-enabled/default
	wget https://github.com/glzjin/Radius-install/raw/master/dialup.conf -O /etc/raddb/sql/mysql/dialup.conf
	wget https://github.com/glzjin/Radius-install/raw/master/dictionary -O /etc/raddb/dictionary
	wget https://github.com/glzjin/Radius-install/raw/master/counter.conf -O /etc/raddb/sql/mysql/counter.conf
	service radiusd start && chkconfig radiusd on
	cd /home/wwwroot/default 
	php composer.phar install
	yum -y install vixie-cron crontabs
	rm -rf /var/spool/cron/root
	echo 'SHELL=/bin/bash' >> /var/spool/cron/root
	echo 'PATH=/sbin:/bin:/usr/sbin:/usr/bin' >> /var/spool/cron/root
	echo '*/20 * * * * /usr/sbin/ntpdate pool.ntp.org > /dev/null 2>&1' >> /var/spool/cron/root
	echo '30 22 * * * php /www/wwwroot/default/xcat sendDiaryMail' >> /var/spool/cron/root
	echo '*/1 * * * * php /www/wwwroot/default/xcat synclogin' >> /var/spool/cron/root
	echo '*/1 * * * * php /www/wwwroot/default/xcat syncvpn' >> /var/spool/cron/root
	echo '0 0 * * * php -n /www/wwwroot/default/xcat dailyjob' >> /var/spool/cron/root
	echo '*/1 * * * * php /www/wwwroot/default/xcat checkjob' >> /var/spool/cron/root
	echo '*/1 * * * * php -n /www/wwwroot/default/xcat syncnas' >> /var/spool/cron/root
	/sbin/service crond restart
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
	rm -rf /home/wwwroot/default/sspanel_mod3_old.zip
	echo "#####################################################################################"
	echo "# 安装成功，登录http://${IPAddress}，                                               #"
	echo "# 创建管理：cd /home/wwwroot/default  然后 php xcat createAdmin                     #"
	echo "# 更多网站数据：/home/wwwroot/default/config/.config.php                            #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master            #"
	echo "# 节点设置: 例如   香港 1 – Shadowsocks                                             #"
	echo "# Author: 小羽                                                                      #"
	echo "# QQ群: 600573662                                                                   #"
	echo "#####################################################################################"
}
install_ss_panel_mod_v3_new(){
    clear
	echo
	echo "#############################################################################"
	echo "#                    安装SS-Panel-Mod3前端面板IP版                          #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master    #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	echo -e "\033[0;1;35m数据设置\033[0m"
	echo "-------------------------------------------"
	echo "设置数据库密码lnmp设置的请先默认root" 
	echo "设置站点名称" 
    echo "输入站点名称:"
    read -p "(默认: 小羽SSR云控):" WZName
    [ -z "$WZName" ] && WZName="小羽SSR云控"
	echo
	echo "设置站点地址" 
    echo "输入站点地址:"
    read -p "(默认: www.xiaoyu.com):" yuming
    [ -z "$yuming" ] && yuming="www.xiaoyu.com"
	echo
	echo "设置对接密匙" 
    echo "输入对接密匙:"
    read -p "(默认: xiaoyu):" QHKEY
    [ -z "$QHKEY" ] && QHKEY="xiaoyu"
	echo
	echo "设置邮箱（默认的QQ邮箱）" 
    echo "输入QQ邮箱:"
    read -p "(默认: xiaoyu@qq.com):" useremail
    [ -z "$useremail" ] && useremail="xiaoyu@qq.com"
	echo
	echo "设置邮箱密码（邮箱stpm密码）" 
    echo "输入邮箱stmp密码:"
    read -p "(默认: xiaoyu007):" stmpmm
    [ -z "$stmpmm" ] && stmpmm="xiaoyu007"
	echo
	echo "设置备份邮箱" 
    echo "输入备份邮箱:"
    read -p "(默认: xiaoyubeifen@qq.com):" beifenemail
    [ -z "$beifenemail" ] && beifenemail="xiaoyubeifen@qq.com"
	echo
	echo "设置备份文件密码" 
    echo "输入备份文件密码:"
    read -p "(默认: xiaoyu007):" zippassword
    [ -z "$zippassword" ] && zippassword="xiaoyu007"
    echo "-------------------------------------------"
	yum -y remove httpd
	yum install -y unzip zip git
	wget -c https://raw.githubusercontent.com/CxiaoyuN/xiaoyu-mod3/master/lnmp1.3-mod.zip && unzip lnmp1.3.zip && cd lnmp1.3 && chmod +x install.sh && ./install.sh lnmp
	mkdir /home/wwwroot/backups
	cd /home/wwwroot/default/
	rm -rf index.html
	git clone https://github.com/CxiaoyuN/IPmod.git tmp && mv tmp/.git . && rm -rf tmp && git reset --hard
	cp config/.config.php.example config/.config.php
	chattr -i .user.ini
	mv .user.ini public
	chown -R root:root *
	chmod -R 777 *
	chown -R www:www storage
	chattr +i public/.user.ini
	wget -N -P  /usr/local/nginx/conf/ https://raw.githubusercontent.com/CxiaoyuN/IPmod/master/nginx.conf  
	service nginx restart
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
	sed -i "s#103.74.192.11#${IPAddress}#" /home/wwwroot/default/sql/sspanel.sql
	mysql -uroot -proot -e"create database sspanel;" 
	mysql -uroot -proot -e"use sspanel;" 
	mysql -uroot -proot sspanel < /home/wwwroot/default/sql/sspanel.sql
	sed -i "s#WZName#$WZName#" /home/wwwroot/default/config/.config.php
	sed -i "s#yuming#$yuming#" /home/wwwroot/default/config/.config.php
	sed -i "s#QHKEY#$QHKEY#" /home/wwwroot/default/config/.config.php
	sed -i "s#useremail#$useremail#" /home/wwwroot/default/config/.config.php
	sed -i "s#stmpmm#$stmpmm#" /home/wwwroot/default/config/.config.php
	sed -i "s#beifenemail#$beifenemail#" /home/wwwroot/default/config/.config.php
	sed -i "s#zippassword#$zippassword#" /home/wwwroot/default/config/.config.php
	cd /home/wwwroot/default
	php composer.phar install
	php -n xcat initdownload
	yum -y install vixie-cron crontabs
	rm -rf /var/spool/cron/root
	echo 'SHELL=/bin/bash' >> /var/spool/cron/root
	echo 'PATH=/sbin:/bin:/usr/sbin:/usr/bin' >> /var/spool/cron/root
	echo '*/20 * * * * /usr/sbin/ntpdate pool.ntp.org > /dev/null 2>&1' >> /var/spool/cron/root
	echo '30 22 * * * php /www/wwwroot/default/xcat sendDiaryMail' >> /var/spool/cron/root
	echo '*/1 * * * * php /www/wwwroot/default/xcat synclogin' >> /var/spool/cron/root
	echo '*/1 * * * * php /www/wwwroot/default/xcat syncvpn' >> /var/spool/cron/root
	echo '0 0 * * * php -n /www/wwwroot/default/xcat dailyjob' >> /var/spool/cron/root
	echo '*/1 * * * * php /www/wwwroot/default/xcat checkjob' >> /var/spool/cron/root
	echo '*/1 * * * * php -n /www/wwwroot/default/xcat syncnas' >> /var/spool/cron/root
	/sbin/service crond restart
	echo "#####################################################################################"
	echo "# 安装成功，登录http://${IPAddress}，                                               #"
	echo "# 管理：账号ss@feiyang.li密码feiyang  注意：后台更改管理员账号密码                  #"
	echo "# 更改数据库mysqladmin -u root -p'root' password '新密码'                           #"
	echo "# 更多网站数据：/home/wwwroot/default/config/.config.php                            #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master            #"
	echo "# 节点设置: 例如   香港 1 – Shadowsocks                                             #"
	echo "# Author: 小羽                                                                      #"
	echo "# QQ群: 600573662                                                                   #"
	echo "#####################################################################################"
}
install_ss_panel_mod_v3_2(){
    clear
	echo
	echo "#############################################################################"
	echo "#                    安装SS-Panel-Mod3前端面板域名版                        #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master    #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	echo -e "\033[0;1;35m数据设置\033[0m"
	echo "-------------------------------------------"
	echo "设置数据库密码lnmp是面板设置的" 
    echo "输入lnmp设置的数据库密码:"
    read -p "(默认: root):" lnmppasswd
    [ -z "$lnmppasswd" ] && lnmppasswd="root"
	echo
	echo "设置radius数据库密）" 
    echo "输入radius数据库密码:"
    read -p "(默认: root):" radiuspasswd
    [ -z "$radiuspasswd" ] && radiuspasswd="root"
	echo
	echo "设置radius数据库sspanelradius密码" 
    echo "输入sspanelradiuspasswd密码:"
    read -p "(默认: root):" sspanelradiuspasswd
    [ -z "$sspanelradiuspasswd" ] && sspanelradiuspasswd="root"
	echo
	echo "设置sspanel数据库密码" 
    echo "输入sspanel数据库密码:"
    read -p "(默认: root):" sspanelpasswd
    [ -z "$sspanelpasswd" ] && sspanelpasswd="root"
	echo -e "\033[0;1;35网站信息设置\033[0m"
	echo "-------------------------------------------"
	echo "设置站点名称" 
    echo "输入站点名称:"
    read -p "(默认: To the Flower Of Hell):" WZName
    [ -z "$WZName" ] && WZName="To the Flower Of Hell"
	echo
	echo "设置站点地址" 
    echo "输入站点地址:"
    read -p "(默认: www.xiaoyu.com):" yuming
    [ -z "$yuming" ] && yuming="www.xiaoyu.com"
	echo
	echo "设置对接密匙" 
    echo "输入对接密匙:"
    read -p "(默认: xiaoyu):" QHKEY
    [ -z "$QHKEY" ] && QHKEY="xiaoyu"
	echo
	echo "设置邮箱（默认的QQ邮箱）" 
    echo "输入QQ邮箱:"
    read -p "(默认: xiaoyu@qq.com):" useremail
    [ -z "$useremail" ] && useremail="xiaoyu@qq.com"
	echo
	echo "设置邮箱密码（邮箱stpm密码）" 
    echo "输入邮箱stmp密码:"
    read -p "(默认: xiaoyu007):" stmpmm
    [ -z "$stmpmm" ] && stmpmm="xiaoyu007"
	echo
	echo "设置备份邮箱" 
    echo "输入备份邮箱:"
    read -p "(默认: xiaoyubeifen@qq.com):" beifenemail
    [ -z "$beifenemail" ] && beifenemail="xiaoyubeifen@qq.com"
	echo
	echo "设置备份文件密码" 
    echo "输入备份文件密码:"
    read -p "(默认: xiaoyu007):" zippassword
    [ -z "$zippassword" ] && zippassword="xiaoyu007"
    echo "-------------------------------------------"
	mkdir /home/wwwroot/backups
	rm -rf /usr/local/nginx/conf/vhost/$yuming.conf
	wget -O /usr/local/nginx/conf/vhost/$yuming.conf https://raw.githubusercontent.com/CxiaoyuN/eg-save-mod/new_master/xiaoyu.com.conf
	sed -i "s#yuming#$yuming#" /usr/local/nginx/conf/vhost/$yuming.conf
	cd /home/wwwroot/$yuming
	yum install git -y
	rm -rf index.html
	git clone https://github.com/CxiaoyuN/eg-save-mod.git tmp -b new_master && mv tmp/.git . && rm -rf tmp && git reset --hard
	chattr -i .user.ini
	mv .user.ini public
	chown -R root:root *
	chmod -R 777 *
	chown -R www:www storage
	chattr +i public/.user.ini 
	service nginx restart
	yum install perl-DBI freeradius freeradius-mysql freeradius-utils -y
	mysql -uroot -p$lnmppasswd -e"CREATE USER 'radius'@'%' IDENTIFIED BY '$radiuspasswd';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO 'radius'@'%';" 
	mysql -uroot -p$lnmppasswd -e"create database radius;" 
	mysql -uroot -p$lnmppasswd -e"use radius;" 
	mysql -uroot -p$lnmppasswd radius < /home/wwwroot/$yuming/sql/radius.sql
	mysql -uroot -p$lnmppasswd -e"CREATE USER 'ss-panel-radius'@'%' IDENTIFIED BY '$sspanelradiuspasswd';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO 'ss-panel-radius'@'%';" 
	mysql -uroot -p$lnmppasswd -e"CREATE USER 'sspanel'@'%' IDENTIFIED BY '$sspanelpasswd';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO 'sspanel'@'%';" 
	mysql -uroot -p$lnmppasswd -e"create database sspanel;" 
	mysql -uroot -p$lnmppasswd -e"use sspanel;" 
	mysql -uroot -p$lnmppasswd sspanel < /home/wwwroot/$yuming/sql/glzjin_all.sql
	\cp /home/wwwroot/$yuming/sql/sql.conf /etc/raddb/sql.conf
	sed -i "s#radiuspasswd#$radiuspasswd#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#sspanelradiuspasswd#$sspanelradiuspasswd#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#sspanelpasswd#$sspanelpasswd#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#WZName#$WZName#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#yuming#$yuming#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#QHKEY#$QHKEY#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#useremail#$useremail#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#stmpmm#$stmpmm#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#beifenemail#$beifenemail#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#zippassword#$zippassword#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#radiuspasswd#$radiuspasswd#" /etc/raddb/sql.conf
	wget https://github.com/glzjin/Radius-install/raw/master/radiusd.conf -O /etc/raddb/radiusd.conf
	wget https://github.com/glzjin/Radius-install/raw/master/default -O /etc/raddb/sites-enabled/default
	wget https://github.com/glzjin/Radius-install/raw/master/dialup.conf -O /etc/raddb/sql/mysql/dialup.conf
	wget https://github.com/glzjin/Radius-install/raw/master/dictionary -O /etc/raddb/dictionary
	wget https://github.com/glzjin/Radius-install/raw/master/counter.conf -O /etc/raddb/sql/mysql/counter.conf
	service radiusd start && chkconfig radiusd on
	cd /home/wwwroot/$yuming 
	php composer.phar install
	yum -y install vixie-cron crontabs
	echo '30 22 * * * php /www/wwwroot/$yuming/xcat sendDiaryMail' >> /var/spool/cron/root
	echo '*/1 * * * * php /www/wwwroot/$yuming/xcat synclogin' >> /var/spool/cron/root
	echo '*/1 * * * * php /www/wwwroot/$yuming/xcat syncvpn' >> /var/spool/cron/root
	echo '0 0 * * * php -n /www/wwwroot/$yuming/xcat dailyjob' >> /var/spool/cron/root
	echo '*/1 * * * * php /www/wwwroot/$yuming/xcat checkjob' >> /var/spool/cron/root
	echo '*/1 * * * * php -n /www/wwwroot/$yuming/xcat syncnas' >> /var/spool/cron/root
	/sbin/service crond restart
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
	rm -rf /home/wwwroot/default/sspanel-mod3-web.zip
	echo "#######################################################################################"
	echo "# 安装成功，无SSL登录http://$yuming，有SSLhttps://$yuming登录数据库http://${IPAddress}#"
	echo "# 创建管理（必须邮箱）：cd /home/wwwroot/$yuming 然后 php xcat createAdmin            #"
	echo "# 更多网站数据：/home/wwwroot/$yuming/config/.config.php                              #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master              #"
	echo "# 节点设置: 例如   香港 1 – Shadowsocks                                               #"
	echo "# Author: 小羽                                                                        #"
	echo "# QQ群: 600573662                                                                     #"
	echo "#######################################################################################"
}
install_WeCenter(){
    clear
	echo
	echo "#############################################################################"
	echo "#                    安装SS-Panel-Mod3 问答系统WeCenter                     #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master    #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	key='yes';
	echo
	echo "设置数据库密码lnmp是面板设置的" 
    echo "输入lnmp设置的数据库密码:"
    read -p "(默认: root):" lnmppasswd
    [ -z "$lnmppasswd" ] && lnmppasswd="root"
	echo
	echo -e "\033[0;1;35m网站设置\033[0m"
	echo "设置WeCenter站点地址"
    echo "输入WeCenter站点地址:"
    read -p "(默认: help.xiaoyu.com):" wecenterym
    [ -z "$wecenterym" ] && wecenterym="help.xiaoyu.com"
	echo
	echo "设置前端站点地址"
    echo "输入前端站点地址:"
    read -p "(默认: www.xiaoyu.com):" yuming
    [ -z "$yuming" ] && yuming="www.xiaoyu.com"
	echo
	echo "设置根地址"
    echo "输入前端站点地址:"
    read -p "(默认: xiaoyu.com):" ym
    [ -z "$ym" ] && yuming="xiaoyu.com"
	echo
	echo -e "\033[0;1;35m数据设置\033[0m"
	echo "-------------------------------------------"
	echo "设置WeCenter数据库名称" 
    echo "输入WeCenter数据库名称:"
    read -p "(默认: wecenter):" wecenterdatabase
    [ -z "$wecenterdatabase" ] && wecenterdatabase="wecenter"
	echo
	echo "设置WeCenter数据库用户名）" 
    echo "输入WeCenter数据库用户名:"
    read -p "(默认: wecenter):" wecenteruser
    [ -z "$wecenteruser" ] && wecenteruser="wecenter"
	echo
	echo "设置WeCenter数据库密码" 
    echo "输入WeCenter数据库密码:"
    read -p "(默认: root):" wecenterpassword
    [ -z "$wecenterpassword" ] && wecenterpassword="root"
	echo "-------------------------------------------"
	echo
	echo -e "\033[0;1;35m创建数据库\033[0m"
	mysql -uroot -p$lnmppasswd -e"CREATE USER '$wecenteruser'@'%' IDENTIFIED BY '$wecenterpassword';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO '$wecenterdatabase'@'%';" 
	mysql -uroot -p$lnmppasswd -e"create database $wecenterdatabase;" 
	mysql -uroot -p$lnmppasswd -e"use $wecenterdatabase;" 
	echo -e "\033[0;1;35m安装必备组件\033[0m"
	cd /root/lnmp1.3-mod
	bash addons.sh install imagemagick 
	echo -e "\033[0;1;35m开启前端问答系统功能\033[0m"
	sed -i "s#wecenterym#$wecenterym#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#ym#$ym#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#wecenterdatabase#$wecenterdatabase#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#wecenteruser#$wecenteruser#" /home/wwwroot/$yuming/config/.config.php
	sed -i "s#wecenterpassword#$wecenterpassword#" /home/wwwroot/$yuming/config/.config.php
	echo -e "\033[0;1;35m获取问答系统\033[0m"
	cd /home/wwwroot/$wecenterym/
	wget https://github.com/CxiaoyuN/xiaoyu-mod3/raw/master/Wecenter.zip && unzip -q Wecenter.zip
	rm -rf Wecenter.zip
	chmod 777 /home/wwwroot/$wecenterym/Wecenter/system
	chmod -R 777 /home/wwwroot/$wecenterym/Wecenter/system/config
	mkdir /home/wwwroot/$wecenterym/Wecenter/tmp
	mkdir /home/wwwroot/$wecenterym/Wecenter/cache
	mkdir /home/wwwroot/$wecenterym/Wecenter/uploads
	chmod 777 /home/wwwroot/$wecenterym/Wecenter/tmp
	chmod 777 /home/wwwroot/$wecenterym/Wecenter/cache
	chmod 777 /home/wwwroot/$wecenterym/Wecenter/uploads
	echo -n -e "打开https://$wecenterym/install/，然后一路安装，你创建账号完成了吗？成功就输yes [\033[32m $key \033[0m] ："
	read PASSWD
	readkey=$PASSWD
	if [[ ${readkey%%\ *} == $key ]]
	then
	echo
	echo -e '\033[32m创建账号完成\033[0m即将处理后续...'
	sleep 1
	rm -rf /home/wwwroot/$wecenterym/Wecenter/install/index.php
	service nginx restart
	echo -e "\033[0;1;35mnginx重启成功\033[0m"
	echo "#####################################################################################"
	echo "# Wecenter设置成功，登录https://$wecenterym/install/进行安装。用邮箱创建账号！      #"
	echo "# 更多网站数据：/home/wwwroot/$yuming/config/.config.php最后的设置                  #"
	echo "# .config.php文件中wecenter 目录下的 system/config.inc.php这下面两行                #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master            #"
	echo "# Author: 小羽                                                                      #"
	echo "# QQ群: 600573662                                                                   #"
	echo "#####################################################################################"
	else
	echo
	echo -e '\033[31m这都不会，那你仔细看看下面的！\033[0m'
	sleep 1
	echo
	exit
	echo "#####################################################################################"
	echo "# Wecenter设置成功，登录https://$wecenterym/install/进行安装。用邮箱创建账号！      #"
	echo "# 创建完账号后执行rm -rf /home/wwwroot/$wecenterym/Wecenter/install/index.php       #"
	echo "# 更多网站数据：/home/wwwroot/$yuming/config/.config.php最后的设置                  #"
	echo "# .config.php文件中wecenter 目录下的 system/config.inc.php这下面两行                #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master            #"
	echo "# Author: 小羽                                                                      #"
	echo "# QQ群: 600573662                                                                   #"
	echo "#####################################################################################"
	fi
}
install_Whmcs(){
    clear
	echo
	echo "#############################################################################"
	echo "#                        安装小羽版Whmcs(英文版）网站                       #"
	echo "#                 安装它必须先安装SSL证书，并且比较看好手动能力             #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	key='yes';
	echo
	echo "设置数据库密码lnmp是面板设置的" 
    echo "输入lnmp设置的数据库密码:"
    read -p "(默认: root):" lnmppasswd
    [ -z "$lnmppasswd" ] && lnmppasswd="root"
	echo
	echo -e "\033[0;1;35m网站设置\033[0m"
	echo "设置Whmcs站点地址"
    echo "输入Whmcs站点地址:"
    read -p "(默认: whmcs.xiaoyu.com):" Whmcsym
    [ -z "$Whmcsym" ] && Whmcsym="whmcs.xiaoyu.com"
	echo
	echo -e "\033[0;1;35m数据设置\033[0m"
	echo "-------------------------------------------"
	echo "设置Whmcs数据库名称" 
    echo "输入Whmcs数据库名称:"
    read -p "(默认: whmcs):" whmcsdatabase
    [ -z "$whmcsdatabase" ] && whmcsdatabase="whmcs"
	echo
	echo "设置Whmcs数据库用户名）" 
    echo "输入Whmcs数据库用户名:"
    read -p "(默认: whmcs):" whmcsuser
    [ -z "$whmcsuser" ] && whmcsuser="whmcs"
	echo
	echo "设置Whmcs数据库密码" 
    echo "输入Whmcs数据库密码:"
    read -p "(默认: root):" whmcspassword
    [ -z "$whmcspassword" ] && whmcspassword="root"
	echo "-------------------------------------------"
	echo
	echo -e "\033[0;1;35m创建数据库\033[0m"
	mysql -uroot -p$lnmppasswd -e"CREATE USER '$whmcsuser'@'%' IDENTIFIED BY '$whmcspassword';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO '$whmcsdatabase'@'%';" 
	mysql -uroot -p$lnmppasswd -e"create database $whmcsdatabase;" 
	mysql -uroot -p$lnmppasswd -e"use $whmcsdatabase;" 
	echo -e "\033[0;1;35m安装必备组件\033[0m"
	cd /root/lnmp1.3-mod
	bash addons.sh install ionCube 
	echo -e "\033[0;1;35m获取whmcs\033[0m"
	cd /home/wwwroot/$Whmcsym/
	mkdir /home/wwwroot/$Whmcsym/whmcs
	cd /home/wwwroot/$Whmcsym/whmcs
	wget -O whmcs.zip https://www.xiaoyussr.top/index.php?share/fileDownload&user=1&sid=Xax5yR3D && unzip -q whmcs.zip
	rm -rf whmcs.zip
	cp /home/wwwroot/$Whmcsym/whmcs/configuration.php.new /home/wwwroot/$Whmcsym/whmcs/configuration.php
	rm -rf /home/wwwroot/$Whmcsym/whmcs/configuration.php.new
	chmod 777 /home/wwwroot/$Whmcsym/whmcs/configuration.php
	chmod 777 /home/wwwroot/$Whmcsym/whmcs/attachments
	chmod 777 /home/wwwroot/$Whmcsym/whmcs/downloads
	chmod 777 /home/wwwroot/$Whmcsym/whmcs/templates_c
	echo -n -e "打开https://$Whmcsym，然后一路安装，注册码888888你创建账号完成了吗？成功就输yes [\033[32m $key \033[0m] ："
	read PASSWD
	readkey=$PASSWD
	if [[ ${readkey%%\ *} == $key ]]
	then
	echo
	echo -e '\033[32m创建账号完成\033[0m即将处理后续...'
	sleep 1
	rm -rf /home/wwwroot/$Whmcsym/whmcs/install
	chmod 444 /home/wwwroot/$Whmcsym/whmcs/configuration.php
	php -q /home/wwwroot/$Whmcsym/whmcs/crons/cron.php
	service nginx restart
	echo -e "\033[0;1;35mnginx重启成功\033[0m"
	echo "#####################################################################################"
	echo "# Whmcs设置成功，登录https://$Whmcsym/                                              #"
	echo "# 管理界面：登录https://$Whmcsym/admin/                                             #"
	echo "# 汉化自己找文件替换                                                                #"
	echo "# Author: 小羽                                                                      #"
	echo "# QQ群: 600573662                                                                   #"
	echo "#####################################################################################"
	else
	echo
	echo -e '\033[31m上传都不会，那你仔细看看下面的！\033[0m'
	sleep 1
	echo
	exit
	echo -e "\033[0;1;35m仔细看下面安装\033[0m"
	echo "#####################################################################################"
	echo "# Whmcs设置成功，登录https://$Whmcsym/进行安装.用邮箱创建账号！                     #"
	echo "# 管理界面：登录https://$Whmcsym/admin/                                             #"
	echo "# 创建完账号后执行rm -rf /home/wwwroot/$Whmcsym/whmcs/install                       #"
	echo "# 输入 chmod 444 /home/wwwroot/$Whmcsym/whmcs/configuration.php                     #"
	echo "# 输入 php -q /home/wwwroot/$Whmcsym/whmcs/crons/cron.php                           #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master            #"
	echo "# Author: 小羽                                                                      #"
	echo "# QQ群: 600573662                                                                   #"
	echo "#####################################################################################"
	fi

}
install_centos_ssr(){
	yum -y update
	yum -y install git 
	yum -y install python-setuptools && easy_install pip 
	yum -y groupinstall "Development Tools" 
	#512M的小鸡增加1G的Swap分区
	dd if=/dev/zero of=/var/swap bs=1024 count=1048576
	mkswap /var/swap
	chmod 0644 /var/swap
	swapon /var/swap
	echo '/var/swap   swap   swap   default 0 0' >> /etc/fstab
	wget https://github.com/jedisct1/libsodium/releases/download/1.0.13/libsodium-1.0.13.tar.gz
	tar xf libsodium-1.0.13.tar.gz && cd libsodium-1.0.13
	./configure && make -j2 && make install
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	ldconfig
	yum -y install python-setuptools
	easy_install supervisor
	#clone shadowsocks
	cd /root
	git clone -b manyuser https://github.com/glzjin/shadowsocks.git "/root/shadowsocks"
	#install devel
	cd /root/shadowsocks
	yum -y install lsof lrzsz
	yum -y install python-devel
	yum -y install libffi-devel
	yum -y install openssl-devel
	yum -y install iptables
	systemctl stop firewalld.service
	systemctl disable firewalld.service
	pip install -r requirements.txt
	cp apiconfig.py userapiconfig.py
	cp config.json user-config.json
}
install_ubuntu_ssr(){
	apt-get update -y
	apt-get install supervisor lsof -y
	apt-get install build-essential wget -y
	apt-get install iptables git -y
	wget https://github.com/jedisct1/libsodium/releases/download/1.0.13/libsodium-1.0.13.tar.gz
	tar xf libsodium-1.0.13.tar.gz && cd libsodium-1.0.13
	./configure && make -j2 && make install
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	ldconfig
	apt-get install python-pip git -y
	pip install cymysql
	cd /root
	git clone -b manyuser https://github.com/glzjin/shadowsocks.git "/root/shadowsocks"
	cd shadowsocks
	pip install -r requirements.txt
	chmod +x *.sh
	# 配置程序
	cp apiconfig.py userapiconfig.py
	cp config.json user-config.json
}
install_node(){
	clear
	echo
	echo "#######################################################################"
	echo "#                    安装SS-Panel-Mod3后端节点                        #"
	echo "# Github: https://github.com/esdeathlove/shadowsocks/tree/manyuser    #"
	echo "# Author: 小羽                                                        #"
	echo "# QQ群: 600573662                                                     #"
	echo "#######################################################################"
	echo
	#Check Root
	[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
	#check OS version
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
		bit=`uname -m`
	}
	install_ssr_for_each(){
		check_sys
		if [[ ${release} = "centos" ]]; then
			install_centos_ssr
		else
			install_ubuntu_ssr
		fi
	}
	# 取消文件数量限制
	sed -i '$a * hard nofile 512000\n* soft nofile 512000' /etc/security/limits.conf
	read -p "Please input your domain(like:https://ml.xiaoyu.top or http://114.114.114.114): " Userdomain
	read -p "Please input your muKey(like:mupass): " Usermukey
	read -p "Please input your Node_ID(like:1): " UserNODE_ID
	install_ssr_for_each
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
	cd /root/shadowsocks
	echo -e "modify Config.py...\n"
	Userdomain=${Userdomain:-"http://${IPAddress}"}
	sed -i "s#https://zhaoj.in#${Userdomain}#" /root/shadowsocks/userapiconfig.py
	Usermukey=${Usermukey:-"mupass"}
	sed -i "s#glzjin#${Usermukey}#" /root/shadowsocks/userapiconfig.py
	UserNODE_ID=${UserNODE_ID:-"3"}
	sed -i '2d' /root/shadowsocks/userapiconfig.py
	sed -i "2a\NODE_ID = ${UserNODE_ID}" /root/shadowsocks/userapiconfig.py
	# 启用supervisord
	echo_supervisord_conf > /etc/supervisord.conf
    	sed -i '$a [program:ssr]\ncommand = python /root/shadowsocks/server.py\nuser = root\nautostart = true\nautorestart = true' /etc/supervisord.conf
	supervisord
	#iptables
	iptables -F
	iptables -X  
	iptables -I INPUT -p tcp -m tcp --dport 22:65535 -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 22:65535 -j ACCEPT
	iptables-save >/etc/sysconfig/iptables
	iptables-save >/etc/sysconfig/iptables
	echo 'iptables-restore /etc/sysconfig/iptables' >> /etc/rc.local
	echo "/usr/bin/supervisord -c /etc/supervisord.conf" >> /etc/rc.local
	chmod +x /etc/rc.d/rc.local
	echo "#######################################################################"
	echo "# 安装成功，登录https://${IPAddress}查看节点                          #"
	echo "# Github: https://github.com/esdeathlove/shadowsocks/tree/manyuser    #"
	echo "# Author: 小羽                                                        #"
	echo "# QQ群: 600573662                                                     #"
	echo "#######################################################################"
	reboot now
}
install_panel_and_node_v3_new(){
	install_ss_panel_mod_v3
	# 取消文件数量限制
	sed -i '$a * hard nofile 512000\n* soft nofile 512000' /etc/security/limits.conf
	install_centos_ssr
	wget -N -P  /root/shadowsocks/ https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/userapiconfig.py
	# 启用supervisord
	echo_supervisord_conf > /etc/supervisord.conf
  	sed -i '$a [program:ssr]\ncommand = python /root/shadowsocks/server.py\nuser = root\nautostart = true\nautorestart = true' /etc/supervisord.conf
	supervisord
	#iptables
	systemctl stop firewalld.service
	systemctl disable firewalld.service
	yum install iptables -y
	iptables -F
	iptables -X  
	iptables -I INPUT -p tcp -m tcp --dport 22:65535 -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 22:65535 -j ACCEPT
	iptables-save >/etc/sysconfig/iptables
	iptables-save >/etc/sysconfig/iptables
	echo 'iptables-restore /etc/sysconfig/iptables' >> /etc/rc.local
	echo "/usr/bin/supervisord -c /etc/supervisord.conf" >> /etc/rc.local
	chmod +x /etc/rc.d/rc.local
	echo "#######################################################################"
	echo "# 安装完成，登录http://${IPAddress}看看吧~                            #"
	echo "# 安装完成，节点即将重启使配置生效                                    #"
	echo "# Github: https://github.com/esdeathlove/shadowsocks/tree/manyuser    #"
	echo "# QQ群: 600573662                                                     #"
	echo "#######################################################################"
	reboot now
}
echo
echo -e "\033[36m############################################################################\033[0m"
echo -e "\033[36m#                     小羽 SS-Panel-Mod3 云控安装脚本                      #\033[0m"
echo -e "\033[36m#                        支持 Centos与Ubuntu系统                           #\033[0m"
echo -e "\033[36m# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master   #\033[0m"
echo -e "\033[36m# Author: 小羽                                                             #\033[0m"
echo -e "\033[36m# QQ群: 600573662                                                          #\033[0m"
echo -e "\033[36m#  请选择你要安装的脚本                                                    #\033[0m"
echo -e "\033[36m#  1  安装SS-Panel-Mod3环境lnmp1.3                                         #\033[0m"
echo -e "\033[36m#  2  安装SS-Panel-Mod3前端面板（IP旧版,先安装1）推荐                      #\033[0m"
echo -e "\033[36m#  3  安装SS-Panel-Mod3前端面板（IP新版,自带安装前后端）不用安装1          #\033[0m"
echo -e "\033[36m#  4  安装SS-Panel-Mod3前端面板（域名版）推荐                              #\033[0m"
echo -e "\033[36m#  5  安装SS-Panel-Mod3 问答系统                                           #\033[0m"
echo -e "\033[36m#  6  安装小羽版Whmcs网站                                                  #\033[0m"
echo -e "\033[36m#  7  安装SS-Panel-Mod3后端节点                                            #\033[0m"
echo -e "\033[36m#  8  安装TCP_BBR原版加速器                                                #\033[0m"
echo -e "\033[36m#  9  安装TCP_BBR魔改版加速器（Debian8、9和Ubuntu16）                      #\033[0m"
echo -e "\033[36m# 10  安装SSL证书 （建议腾讯的）                                           #\033[0m"
echo -e "\033[36m############################################################################\033[0m"
echo
stty erase '^H' && read -p " 请输入数字 [1-10]:" num
case "$num" in
	1)
	install_lnmp1.3_mod
	;;
	2)
	install_ss_panel_mod_v3_old
	;;
	3)
	install_panel_and_node_v3_new
	;;
	4)
	install_ss_panel_mod_v3_2
	;;
	5)
	install_WeCenter
	;;
	6)
	install_Whmcs
	;;
	7)
	install_node
	;;
	8)
	install_TCP_BBR
	;;
	9)
	install_TCP_BBR_MOD
	;;
	10)
	install_SSL
	;;
	*)
	echo "请输入正确数字 [1-10]"
	;;
esac
