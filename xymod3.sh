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
    echo "#                        Debian8,Debian9,Ubuntu16.04	                      #"
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
install_ss_panel_mod_v3(){
    clear
	echo
	echo "#############################################################################"
	echo "#                    安装SS-Panel-Mod3前端面板                              #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master    #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	echo -e "\033[0;1;35m数据设置\033[0m"
	echo "-------------------------------------------"
	echo "设置数据库密码lnmp是面板设置的）" 
    echo "输入lnmp设置的数据库密码:"
    read -p "(默认: root):" lnmppasswd
    [ -z "$lnmppasswd" ] && emailhost="root"
    echo "-------------------------------------------"
	cd /home/wwwroot/default/
	yum install git -y
	rm -rf index.html
	wget https://raw.githubusercontent.com/CxiaoyuN/xiaoyu-mod3/master/sspanel-mod3-web.zip && unzip sspanel-mod3-web.zip
	chattr -i .user.ini
	mv .user.ini public
	chown -R root:root *
	chmod -R 777 *
	chown -R www:www storage
	chattr +i public/.user.ini
	wget -N -P  /usr/local/nginx/conf/ https://github.com/CxiaoyuN/xiaoyu-mod3/raw/master/nginx.conf 
	service nginx restart
	yum install perl-DBI freeradius freeradius-mysql freeradius-utils -y
	mysql -uroot -p$lnmppasswd -e"CREATE USER 'radius'@'%' IDENTIFIED BY 'xiaoyu01';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO 'radius'@'%';" 
	mysql -uroot -p$lnmppasswd -e"create database radius;" 
	mysql -uroot -p$lnmppasswd -e"use radius;" 
	mysql -uroot -p$lnmppasswd radius < /home/wwwroot/default/sql/radius.sql
	mysql -uroot -p$lnmppasswd -e"CREATE USER 'ss-panel-radius'@'%' IDENTIFIED BY 'xiaoyu01';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO 'ss-panel-radius'@'%';" 
	mysql -uroot -p$lnmppasswd -e"CREATE USER 'sspanel'@'%' IDENTIFIED BY 'xiaoyu01';" 
	mysql -uroot -p$lnmppasswd -e"GRANT ALL ON *.* TO 'sspanel'@'%';" 
	mysql -uroot -p$lnmppasswd -e"create database sspanel;" 
	mysql -uroot -p$lnmppasswd -e"use sspanel;" 
	mysql -uroot -p$lnmppasswd sspanel < /home/wwwroot/default/sql/sspanel.sql
	\cp /home/wwwroot/default/sql/sql.conf /etc/raddb/sql.conf
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
	\cp /home/wwwroot/default/sql/root /var/spool/cron/root
	/sbin/service crond restart
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
	rm -rf /home/wwwroot/default/sspanel-mod3-web.zip
	echo "#####################################################################################"
	echo "# 安装成功，登录http://${IPAddress}，数据库：http://${IPAddress}/phpmyadmin         #"
	echo "# 默认管理：2464787478@qq.com    密码xiaoyu1994                                     #"
	echo "# 编辑网站数据：vi /home/wwwroot/default/ss.panel/config/.config.php                #"
	echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master            #"
	echo "# Author: 小羽                                                                      #"
	echo "# QQ群: 600573662                                                                   #"
	echo "#####################################################################################"
}
install_centos_ssr(){
	yum -y remove httpd
	yum -y update
	yum -y install git -y
	yum -y install python-setuptools && easy_install pip -y
	yum -y groupinstall "Development Tools" -y
	#512M的小鸡增加1G的Swap分区
	dd if=/dev/zero of=/var/swap bs=1024 count=1048576
	mkswap /var/swap
	chmod 0644 /var/swap
	swapon /var/swap
	echo '/var/swap   swap   swap   default 0 0' >> /etc/fstab
	wget https://raw.githubusercontent.com/CxiaoyuN/xiaoyu-mod3/master/libsodium-1.0.12.tar.gz
	tar xf libsodium-1.0.12.tar.gz && cd libsodium-1.0.12
	./configure && make -j2 && make install
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	ldconfig
	#clone shadowsocks
	cd /root
	git clone -b manyuser https://github.com/glzjin/shadowsocks.git "/root/shadowsocks"
	#install devel
	cd /root/shadowsocks
	yum -y install python-devel
	yum -y install libffi-devel
	yum -y install openssl-devel
	pip install -r requirements.txt
	cp apiconfig.py userapiconfig.py
	cp config.json user-config.json
	#iptables
	iptables -I INPUT -p tcp -m tcp --dport 104 -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 104 -j ACCEPT
	iptables -I INPUT -p tcp -m tcp --dport 1024: -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 1024: -j ACCEPT
	iptables-save >/etc/sysconfig/iptables
	echo 'iptables-restore /etc/sysconfig/iptables' >> /etc/rc.local
	echo '/root/shadowsocks/./logrun.sh ' >> /etc/rc.local
	chmod +x /etc/rc.d/rc.local
}
install_ubuntu_ssr(){
	apt-get install build-essential wget -y
	apt-get install iptables -y
	wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
	tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
	./configure && make -j2 && make install
	ldconfig
	apt-get install python-pip git -y
	pip install cymysql
	cd /root
	git clone -b manyuser https://github.com/glzjin/shadowsocks.git
	cd shadowsocks
	pip install -r requirements.txt
	chmod +x *.sh
	# 配置程序
	cp apiconfig.py userapiconfig.py
	cp config.json user-config.json
	#iptables
	iptables -I INPUT -p tcp -m tcp --dport 104 -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 104 -j ACCEPT
	iptables -I INPUT -p tcp -m tcp --dport 1024: -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 1024: -j ACCEPT
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
	read -p "Please input your domain(like:https://www.xiaoyussr.top or http://114.114.114.114): " Userdomain
	read -p "Please input your muKey(like:xiaoyu): " Usermukey
	read -p "Please input your Node_ID(like:3): " UserNODE_ID
	install_ssr_for_each
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
	cd /root/shadowsocks
	echo -e "modify Config.py...\n"
	Userdomain=${Userdomain:-"http://${IPAddress}"}
	sed -i "s#https://zhaoj.in#${Userdomain}#" /root/shadowsocks/userapiconfig.py
	Usermukey=${Usermukey:-"xiaoyu"}
	sed -i "s#glzjin#${Usermukey}#" /root/shadowsocks/userapiconfig.py
	UserNODE_ID=${UserNODE_ID:-"3"}
	sed -i '2d' /root/shadowsocks/userapiconfig.py
	sed -i "2a\NODE_ID = ${UserNODE_ID}" /root/shadowsocks/userapiconfig.py
	cd /root/shadowsocks
	./logrun.sh
	echo "#######################################################################"
	echo "# 安装成功，登录http://${IPAddress}查看节点                           #"
	echo "# Github: https://github.com/esdeathlove/shadowsocks/tree/manyuser    #"
	echo "# Author: 小羽                                                        #"
	echo "# QQ群: 600573662                                                     #"
	echo "#######################################################################"
}
echo
echo "############################################################################"
echo "#                     小羽 SS-Panel-Mod3 云控安装脚本                      #"
echo "#                        支持 Centos与Ubuntu系统                           #"
echo "# Github: https://github.com/esdeathlove/ss-panel-v3-mod/tree/new_master   #"
echo "# Author: 小羽                                                             #"
echo "# QQ群: 600573662                                                          #"
echo "# 请选择你要安装的脚本                                                     #"
echo "# 0  安装SS-Panel-Mod3环境lnmp1.3                                          #"
echo "# 1  安装SS-Panel-Mod3前端面板                                             #"
echo "# 2  安装SS-Panel-Mod3后端节点                                             #"
echo "# 3  安装TCP_BBR原版加速器                                                 #"
echo "# 4  安装TCP_BBR魔改版加速器（Debian8、9和Ubuntu16）                       #"
echo "############################################################################"
echo
stty erase '^H' && read -p " 请输入数字 [0-4]:" num
case "$num" in
	0)
	install_lnmp1.3_mod
	;;
	1)
	install_ss_panel_mod_v3
	;;
	2)
	install_node
	;;
	3)
	install_TCP_BBR
	;;
	4)
	install_TCP_BBR
	;;
	*)
	echo "请输入正确数字 [0-4]"
	;;
esac
