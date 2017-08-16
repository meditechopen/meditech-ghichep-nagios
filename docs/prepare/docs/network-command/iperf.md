# I. Tìm hiểu iperf.

 Sử dụng Iperf để kiểm tra lưu lượng mạng.

- Iperf là một công cụ hữu hiệu giúp chúng ta tính toán băng thông của mạng.

### 2.1. Cài đặt.

- Trên Ubuntu :

```sh
apt-get update
apt-get install iperf
```

- Trên CentOS 7 :

```sh
yum install epel-release -y
yum install iperf -y
```

### 2.2. Các thông số cơ bản của iperf.

|Tham số|Tác dụng|
|-------|--------|
|-c|chỉ ra địa chỉ IP của server để iperf kết nối đến|
|-f, --format|Chỉ ra định dạng của kết quả hiển thị. 'b' = bps, 'B' = Bps, 'k' = Kbps, 'K' = KBps,...|
|-i, --interval|Thời gian lấy mẫu để hiển thị kết quả tại thời điểm đó ra màn hình|
|-p, --port|Định ra cổng để nghe, mặc định nếu không sử dụng tham số này là cổng 5001|
|-u, --udp|Sử dụng giao thức UDP, mặc định iperf sử dụng TCP|
|-P, --parallel|Chỉ ra số kết nối song song được tạo, nếu là Server mode thì đây là giới hạn số kết nối mà server chấp nhận|
|-b|Định ra băng thông tối ta có thể truyền, chỉ sử dụng với UDP, client mode|
|-t|Tổng thời gian của kết nối, tính bằng giây|
|-M|Max segment size|
|-l|Buffer size|
|-w, --window|Trường Windows size của TCP|

### 2.3. Sử dụng iperf để kiểm tra lưu lượng mạng của hệ thống.

- Cài đặt iperf, cần 2 host. 1 là client và 1 là server. Trên cả 2 host cài iperl :

```sh
yum install epel-release -y
yum install iperf -y
```

- Mở port trên serrver :

```sh
firewall-cmd --permanent --add-port=5001/tcp
firewall-cmd --reload
```

### Thực hiện kiểm tra lưu lượng mạng từ client (10.10.10.130) đến server (10.10.10.129)

- Trên server thực hiện lệnh sau :

```sh
iperf -s
```

- Trên client thực hiện lệnh sau :

```sh
iperf -c 10.10.10.129
```

- Đợi khoảng 10s chúng ta sẽ thấy được kết quả trả về như sau:

```sh
[root@localhost ~]# iperf -c 10.10.10.129
------------------------------------------------------------
Client connecting to 10.10.10.129, TCP port 5001
TCP window size:  144 KByte (default)
------------------------------------------------------------
[  3] local 10.10.10.130 port 45758 connected with 10.10.10.129 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.37 GBytes  1.18 Gbits/sec
```

- Kết quả mà chúng ta thu được như sau : TCP window size mặc định là 144KByte. Trong thời gian 10s gửi được tổng số dữ liệu là 1,37GB. 
Lưu lượng trung bình là 1.18 Gbits/sec.



### Thực hiện bài test kiểm tra lưu lượng mạng TCP với Buffer size: 16 MB, Window Size: 60 Mbps, Max segment size 5 trong thời gian 5 phút, kết quả hiển thị dưới dạng mbps


Thực hiện lệnh sau trên server :

    ```sh
    iperf -s -P 0 -i 1 -p 5001 -w 60.0m -l 16.0M -f m
    ```

Thực hiện lệnh sau trên client :

    ```sh
    iperf -c 10.10.10.130 -i 1 -p 5001 -w 60.0m -M 1.0K -l 16.0M -f m -t 300

    # trong đó 10.10.10.130 là địa chỉ của server.
    ```

- Kết quả mà ta tìm được là ;

Trên server :

    ```sh
    [root@localhost ~]# iperf -s -P 0 -i 1 -p 5001 -w 60.0m -l 16.0M -f m
    ------------------------------------------------------------
    Server listening on TCP port 5001
    TCP window size: 0.41 MByte (WARNING: requested 60.0 MByte)
    ------------------------------------------------------------
    [  4] local 10.10.10.130 port 5001 connected with 10.10.10.129 port 39748
    [ ID] Interval       Transfer     Bandwidth
    [  4]  0.0- 1.0 sec   141 MBytes  1179 Mbits/sec
    [  4]  1.0- 2.0 sec   150 MBytes  1260 Mbits/sec
    [  4]  2.0- 3.0 sec   145 MBytes  1219 Mbits/sec
    [  4]  3.0- 4.0 sec   162 MBytes  1358 Mbits/sec
    [  4]  4.0- 5.0 sec   170 MBytes  1422 Mbits/sec
    [  4]  5.0- 6.0 sec   208 MBytes  1746 Mbits/sec
    [  4]  6.0- 7.0 sec   208 MBytes  1747 Mbits/sec
    [  4]  7.0- 8.0 sec   191 MBytes  1601 Mbits/sec
    [  4]  8.0- 9.0 sec   198 MBytes  1663 Mbits/sec
    [  4]  9.0-10.0 sec   205 MBytes  1723 Mbits/sec
    [  4] 10.0-11.0 sec   174 MBytes  1459 Mbits/sec
    [  4] 11.0-12.0 sec   192 MBytes  1612 Mbits/sec
    [  4] 12.0-13.0 sec   187 MBytes  1568 Mbits/sec
    [  4] 13.0-14.0 sec   199 MBytes  1666 Mbits/sec
    [  4] 14.0-15.0 sec   237 MBytes  1991 Mbits/sec
    [  4] 15.0-16.0 sec   213 MBytes  1789 Mbits/sec
    [  4] 16.0-17.0 sec   225 MBytes  1885 Mbits/sec
    ```

Trên client :

    ```sh
    [root@localhost ~]# iperf -c 10.10.10.130 -i 1 -p 5001 -w 60.0m -M 1.0K -l 16.0M -f m -t 300
    WARNING: attempt to set TCP maximum segment size to 1024, but got 536
    ------------------------------------------------------------
    Client connecting to 10.10.10.130, TCP port 5001
    TCP window size: 0.41 MByte (WARNING: requested 60.0 MByte)
    ------------------------------------------------------------
    [  3] local 10.10.10.129 port 39748 connected with 10.10.10.130 port 5001
    [ ID] Interval       Transfer     Bandwidth
    [  3]  0.0- 1.0 sec   144 MBytes  1208 Mbits/sec
    [  3]  1.0- 2.0 sec   160 MBytes  1342 Mbits/sec
    [  3]  2.0- 3.0 sec   144 MBytes  1208 Mbits/sec
    [  3]  3.0- 4.0 sec   160 MBytes  1342 Mbits/sec
    [  3]  4.0- 5.0 sec   160 MBytes  1342 Mbits/sec
    [  3]  5.0- 6.0 sec   208 MBytes  1745 Mbits/sec
    [  3]  6.0- 7.0 sec   208 MBytes  1745 Mbits/sec
    [  3]  7.0- 8.0 sec   192 MBytes  1611 Mbits/sec
    [  3]  8.0- 9.0 sec   208 MBytes  1745 Mbits/sec
    [  3]  9.0-10.0 sec   208 MBytes  1745 Mbits/sec
    [  3] 10.0-11.0 sec   176 MBytes  1476 Mbits/sec
    [  3] 11.0-12.0 sec   192 MBytes  1611 Mbits/sec
    [  3] 12.0-13.0 sec   176 MBytes  1476 Mbits/sec
    [  3] 13.0-14.0 sec   208 MBytes  1745 Mbits/sec
    [  3] 14.0-15.0 sec   224 MBytes  1879 Mbits/sec
    [  3] 15.0-16.0 sec   224 MBytes  1879 Mbits/sec
    [  3] 16.0-17.0 sec   224 MBytes  1879 Mbits/sec
    [  3] 17.0-18.0 sec   128 MBytes  1074 Mbits/sec
    [  3] 18.0-19.0 sec   128 MBytes  1074 Mbits/sec
    [  3] 19.0-20.0 sec   128 MBytes  1074 Mbits/sec
    [  3] 20.0-21.0 sec   160 MBytes  1342 Mbits/sec
    [  3] 21.0-22.0 sec   176 MBytes  1476 Mbits/sec
    [  3] 22.0-23.0 sec   192 MBytes  1611 Mbits/sec
    ```

- Kết quả trên cho chúng ta thấy được cứ mỗi giây sẽ gửi đi một gói tin có lưu lượng trong phần `tranfer` , và kết quả chúng ta sẽ thấy được 
lượng băng thông trung bình ở cột `Bandwidth`.

###  Kiểm tra lưu lượng tối đa trên một card mạng có thể truyển tải được.

- Chúng ta kiểm tra bằng cách gửi liên tục các gói UDP để lấy được thông tin. Bởi vì gói tin UDP ko thực hiện quá trình bắt tay 3 bước như TCP cho 
nên chúng ta có thể dễ dàng kiểm tra được bằng thông tối đa tại một card mạng là bao nhiêu.

Ví dụ : kiểm tra băng thông tối đa của card mạng eth1 trên server 10.10.10.129

- Trên server `10.10.10.129` chúng ta thực hiện như sau :

    ```sh
    iperf -c 10.10.10.129 -u -b 100m -t 100 -i 2
    iperf -c 10.10.10.129 -u -b 500m -t 100 -i 2
    iperf -c 10.10.10.129 -u -b 1g -t 100 -i 2
    iperf -c 10.10.10.129 -u -b 2g -t 100 -i 2
    ```

- Với `iperf -c 10.10.10.129 -u -b 100m -t 100 -i 2` chúng ta thu được kết quả như sau :

    ```sh
    [root@localhost ~]# iperf -c 10.10.10.129 -u -b 100m -t 100 -i 2
    ------------------------------------------------------------
    Client connecting to 10.10.10.129, UDP port 5001
    Sending 1470 byte datagrams, IPG target: 117.60 us (kalman adjust)
    UDP buffer size:  208 KByte (default)
    ------------------------------------------------------------
    [  3] local 10.10.10.129 port 39953 connected with 10.10.10.129 port 5001
    [ ID] Interval       Transfer     Bandwidth
    [  3]  0.0- 2.0 sec  23.8 MBytes   100 Mbits/sec
    [  3]  2.0- 4.0 sec  23.8 MBytes   100 Mbits/sec
    [  3]  4.0- 6.0 sec  23.8 MBytes   100 Mbits/sec
    [  3]  6.0- 8.0 sec  23.8 MBytes   100 Mbits/sec
    [  3]  8.0-10.0 sec  23.8 MBytes   100 Mbits/sec
    [  3] 10.0-12.0 sec  23.8 MBytes   100 Mbits/sec
    [  3] 12.0-14.0 sec  23.8 MBytes   100 Mbits/sec
    ```

Mỗi 2s kiểm tra 1 lần, và những lần kiểm tra thì lượng dữ liệu gửi đi cũng như Bandwidth không hề thay đổi, có nghĩa là đây chưa phải lưu lượng tối đa 
có thể truyền tải được. Chúng ta tăng lượng lưu lượng cần tryền tải lên rồi tiếp tục kiểm tra.

- Đối với `iperf -c 10.10.10.129 -u -b 500m -t 100 -i 2`

    ```sh
    [root@localhost ~]# iperf -c 10.10.10.129 -u -b 500m -t 100 -i 2
    ------------------------------------------------------------
    Client connecting to 10.10.10.129, UDP port 5001
    Sending 1470 byte datagrams, IPG target: 23.52 us (kalman adjust)
    UDP buffer size:  208 KByte (default)
    ------------------------------------------------------------
    [  3] local 10.10.10.129 port 60022 connected with 10.10.10.129 port 5001
    [ ID] Interval       Transfer     Bandwidth
    [  3]  0.0- 2.0 sec  82.8 MBytes   347 Mbits/sec
    [  3]  2.0- 4.0 sec  86.5 MBytes   363 Mbits/sec
    [  3]  4.0- 6.0 sec  91.9 MBytes   385 Mbits/sec
    [  3]  6.0- 8.0 sec  90.9 MBytes   381 Mbits/sec
    [  3]  8.0-10.0 sec  84.5 MBytes   354 Mbits/sec
    [  3] 10.0-12.0 sec  92.9 MBytes   390 Mbits/sec
    [  3] 12.0-14.0 sec   127 MBytes   535 Mbits/sec
    [  3] 14.0-16.0 sec   129 MBytes   540 Mbits/sec
    [  3] 16.0-18.0 sec   129 MBytes   541 Mbits/sec
    [  3] 18.0-20.0 sec   130 MBytes   543 Mbits/sec
    [  3] 20.0-22.0 sec   129 MBytes   542 Mbits/sec
    [  3] 22.0-24.0 sec   129 MBytes   540 Mbits/sec
    [  3] 24.0-26.0 sec   129 MBytes   540 Mbits/sec
    [  3] 26.0-28.0 sec   128 MBytes   537 Mbits/sec
    [  3] 28.0-30.0 sec   128 MBytes   535 Mbits/sec
    [  3] 30.0-32.0 sec   126 MBytes   530 Mbits/sec
    [  3] 32.0-34.0 sec   124 MBytes   521 Mbits/sec
    [  3] 34.0-36.0 sec   128 MBytes   535 Mbits/sec
    [  3] 36.0-38.0 sec   128 MBytes   537 Mbits/sec
    [  3] 38.0-40.0 sec   143 MBytes   599 Mbits/sec
    [  3] 40.0-42.0 sec   144 MBytes   606 Mbits/sec
    [  3] 42.0-44.0 sec   139 MBytes   583 Mbits/sec
    [  3] 44.0-46.0 sec   123 MBytes   515 Mbits/sec
    [  3] 46.0-48.0 sec   119 MBytes   500 Mbits/sec
    [  3] 48.0-50.0 sec   119 MBytes   500 Mbits/sec
    ```
Tại trường hợp này lượng băng thông đã thay đổi liên tục với khoảng cách không quá lớn từ 530 đến 600 Mbits/s. chúng ta thực hiện kiểm 
tra với 1 trường hợp khác với lượng lưu lượng cần truyền tải lớn hơn trước khi đưa kết luận.

- Đối với  `iperf -c 10.10.10.129 -u -b 1g -t 100 -i 2`

    ```sh
    [  3] Sent 8058386 datagrams
    [root@localhost ~]# iperf -c 10.10.10.129 -u -b 1g -t 100 -i 2
    ------------------------------------------------------------
    Client connecting to 10.10.10.129, UDP port 5001
    Sending 1470 byte datagrams, IPG target: 11.76 us (kalman adjust)
    UDP buffer size:  208 KByte (default)
    ------------------------------------------------------------
    [  3] local 10.10.10.129 port 50006 connected with 10.10.10.129 port 5001
    [ ID] Interval       Transfer     Bandwidth
    [  3]  0.0- 2.0 sec  79.2 MBytes   332 Mbits/sec
    [  3]  2.0- 4.0 sec  76.9 MBytes   322 Mbits/sec
    [  3]  4.0- 6.0 sec  90.4 MBytes   379 Mbits/sec
    [  3]  6.0- 8.0 sec   104 MBytes   438 Mbits/sec
    [  3]  8.0-10.0 sec   126 MBytes   527 Mbits/sec
    [  3] 10.0-12.0 sec   126 MBytes   528 Mbits/sec
    [  3] 12.0-14.0 sec   130 MBytes   545 Mbits/sec
    [  3] 14.0-16.0 sec   143 MBytes   600 Mbits/sec
    [  3] 16.0-18.0 sec   143 MBytes   598 Mbits/sec
    [  3] 18.0-20.0 sec   141 MBytes   592 Mbits/sec
    [  3] 20.0-22.0 sec   141 MBytes   593 Mbits/sec
    [  3] 22.0-24.0 sec   143 MBytes   602 Mbits/sec
    [  3] 24.0-26.0 sec   138 MBytes   579 Mbits/sec
    [  3] 26.0-28.0 sec   141 MBytes   590 Mbits/sec
    [  3] 28.0-30.0 sec   174 MBytes   729 Mbits/sec
    [  3] 30.0-32.0 sec   176 MBytes   739 Mbits/sec
    [  3] 32.0-34.0 sec   178 MBytes   747 Mbits/sec
    [  3] 34.0-36.0 sec   176 MBytes   738 Mbits/sec
    ```

Kết quả cho ta thấy lưu lượng tối đa của card mạng này có thể đạt được là 550-600 Mbits/sec

### Đổi port để kiểm tra.

Tại server :

    ```sh
    [root@localhost ~]# iperf -s -p 5002
    ------------------------------------------------------------
    Server listening on TCP port 5002
    TCP window size: 85.3 KByte (default)
    ```

Tại client :

    ```sh
    [root@localhost ~]# iperf -c 10.10.10.130 -p 5002
    ------------------------------------------------------------
    Client connecting to 10.10.10.130, TCP port 5002
    TCP window size: 93.5 KByte (default)
    ------------------------------------------------------------
    [  3] local 10.10.10.129 port 43356 connected with 10.10.10.130 port 5002
    [ ID] Interval       Transfer     Bandwidth
    [  3]  0.0-10.0 sec  2.60 GBytes  2.23 Gbits/sec
    [root@localhost ~]#
    ```

### Test nhiều máy tới một máy .

- CHúng ta cũng test thử trường hợp nhiều máy gửi dữ liệu đến một máy với thiết lập như sau : Đẩy gói tin UDP ,  speed 100MBps, trong vòng 5 phút.

TRên server thực hiện như sau :

    ```sh
    iperf -s -P 0 -i 1 -p 5001 -w 60.0m -l 16.0M -f m
    ```

- Câu lệnh trên sẽ cho chúng ta kết quả hiển thị dưới dạng mbps

Trên các client thực hiện lệnh :

```sh
iperf -c 10.10.10.130 -i 1 -p 5001 -l 100.0M -f m -t 300
```

Mình test trên 2 máy đây là kết quả của máy thứ nhất khi mà chỉ có 1 mình nó truyền dữ liệu trên đường truyền 

    ```sh
    [  3] 134.0-135.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 135.0-136.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 136.0-137.0 sec   400 MBytes  3355 Mbits/sec
    [  3] 137.0-138.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 138.0-139.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 139.0-140.0 sec   400 MBytes  3355 Mbits/sec
    [  3] 140.0-141.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 141.0-142.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 142.0-143.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 143.0-144.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 144.0-145.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 145.0-146.0 sec   200 MBytes  1678 Mbits/sec
    [  3] 146.0-147.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 147.0-148.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 148.0-149.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 149.0-150.0 sec   200 MBytes  1678 Mbits/sec
    [  3] 150.0-151.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 151.0-152.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 152.0-153.0 sec   400 MBytes  3355 Mbits/sec
    [  3] 153.0-154.0 sec   200 MBytes  1678 Mbits/sec
    [  3] 154.0-155.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 155.0-156.0 sec   400 MBytes  3355 Mbits/sec
    [  3] 156.0-157.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 157.0-158.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 158.0-159.0 sec   300 MBytes  2517 Mbits/sec
    [  3] 159.0-160.0 sec   400 MBytes  3355 Mbits/sec
    ```

Khi mình cho 2 máy cùng truyền dữ liệu trên đường truyền thì kết quả thu được như sau :

```sh
[  3] 181.0-182.0 sec   185 MBytes  1552 Mbits/sec
[  3] 182.0-183.0 sec   135 MBytes  1133 Mbits/sec
[  3] 183.0-184.0 sec   144 MBytes  1206 Mbits/sec
[  3] 184.0-185.0 sec   119 MBytes   997 Mbits/sec
[  3] 185.0-186.0 sec  56.5 MBytes   474 Mbits/sec
[  3] 186.0-187.0 sec   141 MBytes  1184 Mbits/sec
[  3] 187.0-188.0 sec   145 MBytes  1215 Mbits/sec
[  3] 188.0-189.0 sec  81.7 MBytes   685 Mbits/sec
[  3] 189.0-190.0 sec   144 MBytes  1211 Mbits/sec
[  3] 190.0-191.0 sec   113 MBytes   950 Mbits/sec
[  3] 191.0-192.0 sec   250 MBytes  2100 Mbits/sec
[  3] 192.0-193.0 sec  54.2 MBytes   455 Mbits/sec
[  3] 193.0-194.0 sec  96.7 MBytes   811 Mbits/sec
[  3] 194.0-195.0 sec   162 MBytes  1355 Mbits/sec
[  3] 195.0-196.0 sec   119 MBytes   999 Mbits/sec
[  3] 196.0-197.0 sec  65.1 MBytes   546 Mbits/sec
[  3] 197.0-198.0 sec   122 MBytes  1022 Mbits/sec
[  3] 198.0-199.0 sec  80.0 MBytes   671 Mbits/sec
[  3] 199.0-200.0 sec   114 MBytes   958 Mbits/sec
[  3] 200.0-201.0 sec   176 MBytes  1478 Mbits/sec
[  3] 201.0-202.0 sec   181 MBytes  1520 Mbits/sec
[  3] 202.0-203.0 sec   152 MBytes  1278 Mbits/sec
[  3] 203.0-204.0 sec  96.6 MBytes   811 Mbits/sec
[  3] 204.0-205.0 sec   108 MBytes   904 Mbits/sec
[  3] 181.0-182.0 sec   185 MBytes  1552 Mbits/sec
[  3] 182.0-183.0 sec   135 MBytes  1133 Mbits/sec
[  3] 183.0-184.0 sec   144 MBytes  1206 Mbits/sec
[  3] 184.0-185.0 sec   119 MBytes   997 Mbits/sec
[  3] 185.0-186.0 sec  56.5 MBytes   474 Mbits/sec
[  3] 186.0-187.0 sec   141 MBytes  1184 Mbits/sec
[  3] 187.0-188.0 sec   145 MBytes  1215 Mbits/sec
[  3] 188.0-189.0 sec  81.7 MBytes   685 Mbits/sec
[  3] 189.0-190.0 sec   144 MBytes  1211 Mbits/sec
[  3] 190.0-191.0 sec   113 MBytes   950 Mbits/sec
[  3] 191.0-192.0 sec   250 MBytes  2100 Mbits/sec
[  3] 192.0-193.0 sec  54.2 MBytes   455 Mbits/sec
[  3] 193.0-194.0 sec  96.7 MBytes   811 Mbits/sec
[  3] 194.0-195.0 sec   162 MBytes  1355 Mbits/sec
[  3] 195.0-196.0 sec   119 MBytes   999 Mbits/sec
[  3] 196.0-197.0 sec  65.1 MBytes   546 Mbits/sec
[  3] 197.0-198.0 sec   122 MBytes  1022 Mbits/sec
[  3] 198.0-199.0 sec  80.0 MBytes   671 Mbits/sec
[  3] 199.0-200.0 sec   114 MBytes   958 Mbits/sec
[  3] 200.0-201.0 sec   176 MBytes  1478 Mbits/sec
[  3] 201.0-202.0 sec   181 MBytes  1520 Mbits/sec
[  3] 202.0-203.0 sec   152 MBytes  1278 Mbits/sec
[  3] 203.0-204.0 sec  96.6 MBytes   811 Mbits/sec
[  3] 204.0-205.0 sec   108 MBytes   904 Mbits/sec
```

- Từ kết quả trên chúng ta có thể thấy được rằng nếu như có nhiều máy cùng truyền dữ liệu trên đường truyền thì lưu lượng sẽ 
được san sẻ ra các máy với nhau.