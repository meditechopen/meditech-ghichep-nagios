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
allowed_hosts=127.0.0.1, <Nagios_Server_IP>
```

- Khởi động lại dịch vụ NRPE

```sh
/etc/init.d/nagios-nrpe-server restart
```



