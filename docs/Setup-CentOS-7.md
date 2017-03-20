## Hướng dẫn cài đặt Nagios Core trên CentOS 7

### Table of contents

- [ 1. Chuẩn bị ](#1)
    -   [1.1 Chuẩn bị môi trường cài đặt](#1.1)
    -   [1.2 Tạo user cho Nagios](#1.2)
- [ 2. Cài đặt Nagios ](#2)
    - [2.1 Cài đặt Nagios Core và Plugin](#2.1)
    - [2.2 Cấu hình giám sát host Linux](#2.2)
- [3. Tham khảo](#3)


<a name="1.1"></a>
#### 1.1 Chuẩn bị môi trường cài đặt

Để có thể cài đặt và sử dụng được Nagios Core, chúng ta phải cài đặt một số thư viện và các gói dịch vụ đi kèm.

```
yum install gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel xinetd unzip httpd php php-fpm curl wget -y
```

<a name="1.2"></a>
#### 1.2 Tạo user cho Nagios

Tạo user `nagios` và thiết lập password cho nó

```sh
useradd -m -s /bin/bash nagios
```

- `-m`: Tạo thư mục home cho user
- `-s`: User sử dụng Bash Shell mặc định

Tạo group `nagcmd` cho phép sử dụng thư mục Web UI, thêm nagios và www-data (user của apache):

```sh
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagcmd apache
```

<a name="2"></a>
### 2. Cài đặt Nagios

Chúng ta tải Nagios Core và Plugin của nó về server. Để tải bản mới nhất, vui lòng bấm vào [đây](https://www.nagios.org/download/).

```sh
mkdir ~/nagios
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.2.4.tar.gz
wget https://nagios-plugins.org/download/nagios-plugins-2.1.4.tar.gz
curl -L -O http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz
```


<a name="2.1"></a>
#### 2.1 Cài đặt Nagios Core và Plugin

Sau khi tải xong, chúng ta cùng giải nén và bắt đầu phần biên dịch Nagios Core và Plugin.

```
cd ~/nagios/nagios-4.2.4

./configure --with-command-group=nagcmd 
make all
make install
make install-commandmode
make install-init
make install-config
make install-webconf
```

Cho phép nagios khởi động cùng với hệ thống:

```sh
chkconfig nagios on
```

Cài đặt password cho `nagiosadmin`, khi đăng nhập Web:

```sh
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
```

Biên dịch các plugin

```sh
cd ~/nagios
tar xzf nagios-plugins-2.1.4.tar.gz
cd ~/nagios/nagios-plugins-2.1.4

cd ~/nagios/nagios-plugins-2.1.4
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make
make install
```

Khởi động lại Apache và chạy `nagios`:

```sh
systemctl restart apache2
service nagios start
```

Để kiểm tra, hãy truy cập vào giao diện Web và đăng nhập bằng `nagiosadmin` và Password vừa tạo ở địa chỉ:

```
http://địa-chỉ-ip/nagios
```

<img src="../images/nagios1.png" />