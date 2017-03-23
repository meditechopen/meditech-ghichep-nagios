# Hướng dẫn cài đặt giám sát Nagios với NRPE

# Mục lục
- [1. Tổng quan về cơ chế NRPE](#1)
- [2. Mô hình triển khai](#2)
- [3. Cài đặt trên client](#3)
- [4. Cài đặt trên Nagios server](#4)
- [5. Cấu hình giám sát các thông số host](#5)
- [6. Tài liệu tham khảo](#6)

---------------------------------------

<a name="1"></a>
## 1. Tổng quan về cơ chế NRPE
- NRPE (Nagios Remote Plugin Executor) là một add-on đi kèm với Nagios, được cài trên các host giám sát
- Nó trợ giúp việc thực thi các plugin được cài đặt trên máy/thiết bị được giám sát
- Khi nhận được truy vấn từ Nagios server thì nó gọi các plugin cục bộ phù hợp trên host này, thực hiện kiểm tra và trả về kết quả cho Nagios server
- Nagios có thể điều khiển máy cài NRPE kiểm tra các thông số phần cứng, các tài nguyên, tình trạng hoạt động của máy đó hoặc sử dụng NRPE để thực thi các plugin 

<a name="2"></a>
## 2. Mô hình triển khai

- Server Nagios:
```sh
HĐH: Centos 7
IP: 192.168.100.152
```

- Client
```sh
HĐH: U14
IP: 192.168.100.150
```

<img src="">

<a name="3"></a>
## 3. Cài đặt trên client

- Tải gói cài đặt

```sh
apt-get install nagios-nrpe-server nagios-plugins -y
```

- Trong file `/etc/nagios/nrpe.cfg` chỉnh sửa các thông tin như sau:

```sh
allowed_hosts=127.0.0.1,<Nagios_Server_IP>
```

- Khởi động lại dịch vụ NRPE

```sh
/etc/init.d/nagios-nrpe-server restart
```

<a name="4"></a>
## 4. Cài đặt trên Nagios server
- Tải các gói cài đặt
```sh
yum install httpd php php-cli gcc glibc glibc-common gd gd-devel net-snmp openssl-devel wget unzip -y
```

- Tạo user và phần quyền
```sh
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagcmd apache
```

- Tải các gói cài đặt nagios
```sh
cd /tmp
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz
wget http://www.nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz
tar zxf nagios-4.1.1.tar.gz	
tar zxf nagios-plugins-2.1.1.tar.gz
cd nagios-4.1.1
```

- Cài đặt các gói Nagios core
```sh
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf
```

- Tạo password cho Nagios admin
```sh
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
```

- Cài đặt Nagios plugin
```sh
cd /tmp/nagios-plugins-2.1.1
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make all
make install
```

- Tải gói và cài đặt NRPE
```sh
cd /tmp
wget http://liquidtelecom.dl.sourceforge.net/project/nagios/nrpe-3.x/nrpe-3.0.tar.gz
tar xzf nrpe-3.0.tar.gz
cd nrpe-3.0
./configure
make all
make install-daemon
```

- Kiểm tra cài đặt 
```sh
cd /usr/local/nagios/libexec/
./check_nrpe -H <client_IP>
```

```
OUTPUT:
NRPE v3.0
```

#### Trong 1 vài trường hợp có output như trên, kiểm tra firewall của client, hoặc kiểm tra port 5666 của NRPE đã mở chưa
- Kiểm tra port trên client
```sh
netstat -at | grep nrpe
```
Nếu OUTPUT như sau
```sh
tcp        0      0 *:nrpe                  *:*                     LISTEN
```

Quay lại kiểm tra file cấu hình nrpe hoặc filewall, hoặc kiểm tra dịch vụ như sau:
```sh
root@ubuntu12:~# cat /etc/services | grep 5666
nrpe            5666/tcp                        # Nagios Remote Plugin Executor
```

Nếu OUTPUT không phải như trên cần khai báo dịch vụ 

<a name="5"></a>
## 5. Cấu hình giám sát các thông số host

- Để giám sát các thông số như RAM, Disk, CPU...sẽ sử dụng một số scripts có sẵn





