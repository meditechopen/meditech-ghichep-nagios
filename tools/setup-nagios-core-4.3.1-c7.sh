#!/bin/bash

setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

yum install gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel xinetd unzip httpd php php-fpm curl wget -y

systemctl start httpd
systemctl enable httpd

useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -G nagcmd apache

mkdir ~/nagios
cd ~/nagios
# wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.3.1.tar.gz
# wget https://nagios-plugins.org/download/nagios-plugins-2.2.0.tar.gz
# curl -L -O http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz
tar xf nagios-plugins-2.2.0.tar.gz
tar xf nagios-4.3.1.tar.gz

cd ~/nagios/nagios-4.3.1
./configure --with-command-group=nagcmd 
make all
make install
make install-commandmode
make install-init
make install-config
make install-webconf

cd ~/nagios/nagios-plugins-2.2.0
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make
make install

cd ~/nagios/
tar xvf nrpe-*.tar.gz
cd ~/nagios/nrpe-*
./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu


make all
make install
make install-xinetd
make install-daemon-config

ip_addr=` ip addr | grep 'state UP' -A2 | tail -n1 | awk -F'[/ ]+' '{print $3}'`
sed -i "s/127.0.0.1/127.0.0.1 $ip_addr/g" /etc/xinetd.d/nrpe
systemctl restart xinetd.service

sed -e '/#cfg_dir=\/usr\/local\/nagios\/etc\/servers/ s/^#*//' -i /usr/local/nagios/etc/nagios.cfg
mkdir /usr/local/nagios/etc/servers

echo "define command{
        command_name check_nrpe
        command_line \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c \$ARG1\$
}" >> /usr/local/nagios/etc/objects/commands.cfg
clear
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin admin

service nagios restart
chkconfig nagios on
systemctl restart httpd.service


    echo -e "Access to Web UI: http://$ip_addr/nagios
             Username: nagiosadmin
             Password: admin"