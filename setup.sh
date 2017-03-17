#!/bin/bash

apt-get update -y
sudo apt-get install -y autoconf gcc libc6 build-essential bc gawk dc gettext libmcrypt-dev libssl-dev make unzip apache2 apache2-utils php libgd2-xpm-dev wget

## Create new user nagios

useradd -m -s /bin/bash nagios

groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagcmd www-data

## Download Nagios and plugin
mkdir ~/downloads
cd ~/downloads
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.2.4.tar.gz
wget https://nagios-plugins.org/download/nagios-plugins-2.2.0.tar.gz

## Compile and install

cd ~/downloads
tar xzf nagios-4.2.4.tar.gz
cd nagios-4.2.4

./configure --with-command-group=nagcmd --with-httpd-conf=/etc/apache2/sites-enabled
make all
make install
make install-init
make install-config
make install-commandmode
update-rc.d nagios defaults

## Configure the Web UI
make install-webconf
a2enmod rewrite
a2enmod cgi
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios

## Compile the plugins

cd ~/downloads
tar xzf nagios-plugins-2.2.0.tar.gz
cd nagios-plugins-2.2.0

./tools/setup
./configure
make
make install

## Configure the ufw

check_fw=`ufw status | grep -w "active"`
if [ -n "$check_fw" ]
then
    ufw allow Apache
    ufw reload  
    echo "Firewall has been configured."
fi 
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
systemctl start nagios.service