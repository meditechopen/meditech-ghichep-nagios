# I. bwctl là gì.

- BWCTL là một công cụ dòng lệnh sử dụng một loạt các công cụ đo lường network như Iperf, Iperf3, Nuttcp, Ping, Traceroute, Tracepath, và OWAMP để đo băng thông TCP tối đa với một loạt các tùy chọn điều chỉnh khác nhau như sự trễ, tỉ lệ mất gói tin,... Mặc định, bwctl sẽ dùng iperf.

- Bwctl client sẽ liên lạc với một máy chủ để thực hiện bài test. bwctl server sẽ quản lí và sắp xếp các tài nguyên trên host mà nó chạy.

- Một số tính năng :
  - Hỗ trợ Iperf, Iperf3 và Nuttcp tests.
  - Hỗ trợ ping tests
  - Hỗ trợ OWAMP (One-Way Latency) tests.
  - Hỗ trợ Traceroute và Tracepath tests.
  - Hỗ trợ ipv6 mà không cần thêm tùy chọn nào.
  - Dữ liệu từ cả hai phía được trả lại vì thế có thể so sánh kết quả giữa hai phía.
  - Không yêu cầu local BWCTL server, BWCTL client sẽ kiểm tra xem có local BWCTL server hay không và sử dụng nó nếu có.
  - Port ranges cho kết nối có thể được chỉ định.
  -  Giới hạn số lượng test có thể chạy.

# II. Cài đặt và sử dụng.

## 1. Cài đặt.

Cài đặt EPEL RPM :
```sh
rpm -hUv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

Cài đặt Internet2-repo RPM :

```sh
rpm -hUv http://software.internet2.edu/rpms/el7/x86_64/main/RPMS/Internet2-repo-0.7-1.noarch.rpm
```

Refresh yum’s cache :

```sh
yum clean all
```

Cài đặt bwctl :

```sh
yum install bwctl -y
```

Cài đặt ntp :

```sh
yum install ntp -y
```

CHỉnh sửa lại file cấu hình `/etc/ntp.conf` ntp như sau :

```sh
#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst

server vn.pool.ntp.org iburst

```

Khởi động lại dịch vụ ntp :

```sh
systemctl restart ntpd
```

## 2. Một số tùy chọn với bwctl.

| Tùy chọn | Ý nghĩa |
|---------|--------------|
| -4, --ipv4 | Chỉ dùng ipv4 |
| -6, --ipv6 | Chỉ dùng ipv6 |
| -c, --receiver | Chỉ định host chạy Iperf, Iperf3 or Nuttcp server |
| -s, --sender | Chỉ định host chạy Iperf, Iperf3 or Nuttcp client |
| -T, --tool | Chỉ định tool sử dụng ( iperf, iperf3, nuttcp) |
| -b, --bandwidth  | Giới hạn bandwidth với UDP |
| -l, --buffer_length | độ dài của read/write buffers (bytes). Mặc định 8 KB TCP, 1470 bytes UDP |
| -t,--test_duration | Thời gian cho bài test, mặc định là 10 giây |
| -u, --udp | Dùng UDP test, vì mặc định là dùng TCP |
| -p, --print | In kết quả ra file |

## 3. Một số lệnh thường được dùng với bwctl.

|Lệnh|Ý nghĩa|
|----|-------|
|bwctl -c somehost.example.com|Chạy test mặc định với TCP trong vòng 10 giây, máy chạy câu lệnh chính là sender còn receiver là somehost|
|bwctl -x -c somehost.example.com|Kết quả gần giống với câu lệnh phía trên nhưng nó sẽ có thêm phần kết quả của phía sender|
|bwctl -x -c somehost.example.com -s otherhost.example.com|Giống câu lệnh trên nhưng otherhost.example.com mới là sender chứ không phải receiver|
|bwctl -t 30 -T iperf -s somehost.example.com|30 giây TCP iperf test với somehost.example.com là sender còn local là receiver|
|bwctl -I 3600 -R 10 -t 10 -u -b 10m -s somehost.example.com|10 giây UDP test với sender rate là 10 Mbits/sec từ some-host.example.com tới server|


# Tham Khảo.

- https://software.internet2.edu/bwctl/
