#!/bin/bash
#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
install_ss_panel(){
	clear
	echo
	echo "#############################################################"
	echo "#                   安装SS-Panel-3前端面板                  #"
	echo "# Github: https://github.com/orvice/ss-panel/tree/master    #"
	echo "# Author: 小羽                                              #"
	echo "#QQ群: 600573662                                            #"
	echo "#############################################################"
	echo
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
	install_soft_for_each(){
		check_sys
		if [[ ${release} = "centos" ]]; then
			yum install -y unzip zip
			yum install git -y
		else
			sudo apt-get install zip
			apt-get update -y
			apt-get install git -y
		fi
	}
	install_soft_for_each
	wget -c https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/lnmp1.3.zip && unzip lnmp1.3.zip && cd lnmp1.3 && chmod +x install.sh && ./install.sh lnmp
	chattr -i /home/wwwroot/default/.user.ini
	rm -rf /home/wwwroot/default
	git clone https://github.com/mmmwhy/ss-panel.git "/home/wwwroot/default"
	cd /home/wwwroot/default
	curl -sS https://install.phpcomposer.com/installer | php
	chmod +x composer.phar
	php composer.phar install
	chmod -R 777 storage
	mysql -uroot -proot -e"create database ss;" 
	mysql -uroot -proot -e"use ss;" 
	mysql -uroot -proot ss < /home/wwwroot/default/db.sql
	wget -N -P  /usr/local/nginx/conf/ http://home.ustc.edu.cn/~mmmwhy/nginx.conf 
	lnmp nginx restart
}


install_ss_py_mu(){
	clear
	echo
	echo "#############################################################"
	echo "#                   安装SS-Panel-3后端节点                  #"
	echo "# Github: https://github.com/orvice/ss-panel/tree/master    #"
	echo "# Author: 小羽                                              #"
	echo "#QQ群: 600573662                                            #"
	echo "#############################################################"
	echo
	#Check Root
	[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
	read -p "Please input your domain(like:https://ss.91vps.club or http://114.114.114.114): " Userdomain
	read -p "Please input your mukey(like:mupass): " Usermukey
	read -p "Please input your Node_ID(like:1): " UserNODE_ID
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
	install_soft_for_each(){
		check_sys
		if [[ ${release} = "centos" ]]; then
			echo "Will install below software on your centos system:"
			yum install git lsof -y
			yum install python-setuptools -y 
			yum -y groupinstall "Development Tools" -y
			wget https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/libsodium-1.0.11.tar.gz
			tar xf libsodium-1.0.11.tar.gz && cd libsodium-1.0.11
			./configure && make -j2 && make install
			echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
			ldconfig
			yum install python-setuptools
			easy_install supervisor
		else
		apt-get update -y
		apt-get install supervisor -y
		apt-get install git -y
		apt-get install build-essential -y
		wget https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/libsodium-1.0.11.tar.gz
		tar xf libsodium-1.0.11.tar.gz && cd libsodium-1.0.11
		./configure && make -j2 && make install
		ldconfig
		fi
	}
	install_soft_for_each
	echo "Let's setup your ssnode/root"
	git clone https://github.com/mmmwhy/shadowsocks-py-mu.git "/root/shadowsocks-py-mu"
	#modify Config.py
	echo -e "modify Config.py...\n"
	Userdomain=${Userdomain:-"https://ss.91vps.club"}
	sed -i "s#http://domain#${Userdomain}#" /root/shadowsocks-py-mu/shadowsocks/config.py
	Usermukey=${Usermukey:-"mupass"}
	sed -i "s#mupass#${Usermukey}#" /root/shadowsocks-py-mu/shadowsocks/config.py
	UserNODE_ID=${UserNODE_ID:-"1"}
	sed -i "s#'1'#'${UserNODE_ID}'#" /root/shadowsocks-py-mu/shadowsocks/config.py
	echo_supervisord_conf > /etc/supervisord.conf
	sed -i '$a [program:ss-manyuser]\ncommand = python /root/shadowsocks-py-mu/shadowsocks/servers.py\nuser = root\nautostart = true\nautorestart = true' /etc/supervisord.conf
	supervisord
	systemctl stop firewalld.service
	systemctl disable firewalld.service
	yum install iptables-services -y
	iptables -I INPUT -p tcp -m tcp --dport 104 -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 104 -j ACCEPT
	iptables -I INPUT -p tcp -m tcp --dport 1024: -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 1024: -j ACCEPT
	iptables-save >/etc/sysconfig/iptables
	echo 'iptables-restore /etc/sysconfig/iptables' >> /etc/rc.local
	echo "/usr/bin/supervisord -c /etc/supervisord.conf" >> /etc/rc.local
	chmod +x /etc/rc.d/rc.local
	sleep 4
	cat shadowsocks.log
}

one_click_all(){
    clear
	echo
	echo "#############################################################################"
	echo "#                  安装SS-Panel-3前端面板与后端节点                         #"
	echo "# Github: https://github.com/orvice/ss-panel/tree/master                    #"
	echo "# Author: 小羽                                                              #"
	echo "# QQ群: 600573662                                                           #"
	echo "#############################################################################"
	echo
	install_ss_panel
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
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
	install_soft_for_each(){
		check_sys
		if [[ ${release} = "centos" ]]; then
			echo "Will install below software on your centos system:"
			yum install git lsof -y
			yum install python-setuptools -y 
			yum -y groupinstall "Development Tools" -y
			wget https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/libsodium-1.0.11.tar.gz
			tar xf libsodium-1.0.11.tar.gz && cd libsodium-1.0.11
			./configure && make -j2 && make install
			echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
			ldconfig
			yum install python-setuptools
			easy_install supervisor
		else
		apt-get update -y
		apt-get install supervisor -y
		apt-get install git -y
		apt-get install build-essential -y
		wget https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/libsodium-1.0.11.tar.gz
		tar xf libsodium-1.0.11.tar.gz && cd libsodium-1.0.11
		./configure && make -j2 && make install
		ldconfig
		fi
	}
	install_soft_for_each
	echo "Let's setup your ssnode/root"
	git clone https://github.com/mmmwhy/shadowsocks-py-mu.git "/root/shadowsocks-py-mu"
	#modify Config.py
	echo -e "modify Config.py...\n"
	sed -i "s#domain#${IPAddress}#" /root/shadowsocks-py-mu/shadowsocks/config.py
	echo_supervisord_conf > /etc/supervisord.conf
	sed -i '$a [program:ss-manyuser]\ncommand = python /root/shadowsocks-py-mu/shadowsocks/servers.py\nuser = root\nautostart = true\nautorestart = true' /etc/supervisord.conf
	supervisord
	systemctl stop firewalld.service
	systemctl disable firewalld.service
	yum install iptables-services -y
	iptables -I INPUT -p tcp -m tcp --dport 104 -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 104 -j ACCEPT
	iptables -I INPUT -p tcp -m tcp --dport 1024: -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 1024: -j ACCEPT
	iptables-save >/etc/sysconfig/iptables
	echo 'iptables-restore /etc/sysconfig/iptables' >> /etc/rc.local
	echo "/usr/bin/supervisord -c /etc/supervisord.conf" >> /etc/rc.local
	chmod +x /etc/rc.d/rc.local
	sleep 4
	cat shadowsocks.log
	echo ""
	echo "####################################################################"
	echo "# 安装完成，登录http://${IPAddress}默认账号ss@feiyang.li密码feiyang#"
	echo "# 默认的账号密码去管理界面的用户里更改，必须更改 必须更改！必须更改#"
	echo "# Github: https://github.com/orvice/ss-panel/tree/master           #"
	echo "# Author: 小羽                                                     #"
	echo "# Blog: QQ群: 600573662                                            #"
	echo "####################################################################"
}


echo
echo "#############################################################"
echo "#              小羽 SS-Panel-3云控脚本                      #"
echo "# Github: https://github.com/orvice/ss-panel/tree/master    #"
echo "# Author: 小羽                                              #"
echo "# QQ群: 600573662                                           #"
echo "# 请选择你要安装的脚本                                      #"
echo "# 1  安装SS-Panel-3前端面板与后端节点                       #"
echo "# 2  安装SS-Panel-3前端面板                                 #"
echo "# 3  安装SS-Panel-3后端节点                                 #"
echo "#############################################################"
echo
stty erase '^H' && read -p " 请输入数字 [1-3]:" num
case "$num" in
	1)
	one_click_all
	;;
	2)
	install_ss_panel
	;;
	3)
	install_ss_py_mu
	;;
	*)
	echo "请输入正确数字 [1-3]"
	;;
esac
