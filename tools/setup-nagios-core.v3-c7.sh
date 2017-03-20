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
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.2.4.tar.gz
wget https://nagios-plugins.org/download/nagios-plugins-2.1.4.tar.gz
curl -L -O http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz
tar xf nagios-plugins-2.1.4.tar.gz
tar xf nagios-4.2.4.tar.gz

cd ~/nagios/nagios-4.2.4
./configure --with-command-group=nagcmd 
make all
make install
make install-commandmode
make install-init
make install-config
make install-webconf

cd ~/nagios/nagios-plugins-2.1.4
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

sed -e '/#cfg_dir=\/usr\/local\/nagios\/etc\/servers/ s/^#*//' -i /usr/local/nagios/etc/nagios.cfg
mkdir /usr/local/nagios/etc/servers

echo "define command{
        command_name check_nrpe
        command_line \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c \$ARG1\$
}" >> /usr/local/nagios/etc/objects/commands.cfg

htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin admin

systemctl start nagios.service
chkconfig nagios on
systemctl restart httpd.service

ip_addr=` ip addr | grep 'state UP' -A2 | tail -n1 | awk -F'[/ ]+' '{print $3}'`
    echo -e "Access to Web UI: http://$ip_addr/nagios
             Username: nagiosadmin
             Password: admin"