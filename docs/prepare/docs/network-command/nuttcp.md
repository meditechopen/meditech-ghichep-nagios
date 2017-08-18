# I. Tìm hiểu về nuttcp.

- Nuttcp là một công cụ đo lường hiệu năng mạng được sử dụng bởi các nhà quản lý mạng và hệ thống. Việc sử dụng cơ bản nhất của nó là xác định thông lượng mạng TCP (hoặc UDP) thô bằng cách truyền memory buffers từ một hệ thống nguồn qua mạng kết nối tới hệ thống đích, truyền dữ liệu cho một khoảng thời gian nhất định hoặc chuyển một số lượng cụ thể các bytes.

- Ngoài việc báo cáo luồng dữ liệu đạt được trong Mbps, nuttcp cũng cung cấp thêm thông tin hữu ích liên quan đến việc truyền dữ liệu như người sử dụng, hệ thống, wall-clock time, mức độ sử dụng của CPU, tỷ lệ mất mát dữ liệu (đối với UDP).

- Nuttcp dựa trên nttcp. Nttcp được nâng cấp từ ttcp.Ttcp được viết bởi Mike Muuss vào năm 1984 để so sánh hiệu năng của TCP stacks. Nuttcp có một số tính năng hữu ích ngoài các tính năng ttcp / nttcp cơ bản, chẳng hạn như chế độ máy chủ, tỷ lệ giới hạn, nhiều luồng song song và sử dụng bộ đếm thời gian. Những thay đổi gần đây bao gồm hỗ trợ IPv6, multicast IPv4 và khả năng thiết lập kích thước phân đoạn tối đa hoặc bit TOS / DSCP. Nuttcp đang tiếp tục phát triển để đáp ứng các yêu cầu mới phát sinh và để thêm các tính năng mới mong muốn. Nuttcp đã được xây dựng thành công và chạy trên nhiều hệ thống Solaris, SGI, và PPC / X86 Linux, và có thể hoạt động tốt trên hầu hết các distributions của Unix. Nó cũng đã được sử dụng thành công trên các phiên bản khác nhau của hệ điều hành Windows.

# II. Cài đặt và sử dụng.

## 1. Cài đặt.
- Cài đặt trên CentOS.

```sh
yum install nuttcp -y
```

- Cài đặt trên Ubuntu :

```sh
apt-get install nuttcp
```

## 2. Một số tùy chọn sử dụng với nuttcp.

| Tùy chọn | Ý nghĩa |
|---------|--------------|
| -t | Chỉ định máy transmitter |
| -r | Chỉ định máy receiver |
| -S | Chỉ định máy server |
| -1 | Giống với '-S' |
| -b | Định dạng output theo kiểu one-line |
| -B | Buộc receiver phải đọc toàn bộ buffer |
| -u | Sử dụng UDP (mặc định là TCP) |
| -v | Cung cấp thêm thông tin |
| -w | kích thước cửa sổ trượt |
| -p | port sử dụng để kết nối dữ liệu, mặc định là 5001 |
| -P | với mode client-server, đây là port để kiểm soát kết nối, mặc định là 5000 |

## 3. Các kịch bản thường được dùng với nuttcp.

### 3.1. Kịch bản dùng giá trị mặc định để chuyển 1 gói TCP trong 10s.

Chúng ta sẽ dùng 1 máy làm server và 1 máy là client để kiểm tra các thông số mạng.

- Tại server :

```sh
nuttcp -S
```

- Kiểm tra tại server có tiến trình đang chạy không :

    ```sh
    [root@localhost ~]# nuttcp -S
    [root@localhost ~]# ps aux | grep nuttcp
    root       2320  0.0  0.0   6508   196 ?        Ss   10:09   0:00 nuttcp -S
    root       2327  0.0  0.0 112648   968 pts/0    R+   10:10   0:00 grep --color=auto nuttcp
    [root@localhost ~]#
    ```

- Tại client :

```sh
nuttcp 
```

Đơi khoảng 10s chúng ta sẽ có kết quả trả về như sau :

```sh
[root@localhost ~]# nuttcp 10.10.10.130
 2370.9762 MB /  10.01 sec = 1986.6556 Mbps 8 %TX 27 %RX 0 retrans 0.65 msRTT
[root@localhost ~]#
```

- %TX và %RX là mức độ sử dụng CPU trên máy gửi và máy nhận.

### 3.2. Kịch bản tương tự như trên nhưng có kích cỡ window size lớn hơn rất nhiều.

- Trên client  :

    ```sh
    nuttcp -w6m <host>
    ```

- Kết quả chúng ta thu được như sau :

    ```sh
    [root@localhost ~]# nuttcp -w6m 10.10.10.130
    nuttcp-t: Warning: send window size 212992 < requested window size 6291456
    nuttcp-r: Warning: receive window size 212992 < requested window size 6291456
    1533.5176 MB /  10.00 sec = 1286.1180 Mbps 7 %TX 37 %RX 0 retrans 0.98 msRTT
    [root@localhost ~]#
    ```

### 3.3. Kịch bản dùng để kiểm tra lượng gói tin bị mất trong quá trình truyền tải.

- Trên client

    ```sh
    nuttcp -u -i -Ri50m <serverhost>
    ```

- Kết quả thu được.

    ```sh
    [root@localhost ~]# nuttcp -u -i -Ri50m 10.10.10.130
        5.3682 MB /   1.00 sec =   45.0241 Mbps    40 /  5537 ~drop/pkt  0.72 ~%loss
        5.7549 MB /   1.00 sec =   48.2740 Mbps     0 /  5893 ~drop/pkt  0.00 ~%loss
        5.8447 MB /   1.00 sec =   49.0280 Mbps     0 /  5985 ~drop/pkt  0.00 ~%loss
        5.8447 MB /   1.00 sec =   49.0306 Mbps     0 /  5985 ~drop/pkt  0.00 ~%loss
        5.8105 MB /   1.00 sec =   48.7481 Mbps     0 /  5950 ~drop/pkt  0.00 ~%loss
        5.8818 MB /   1.00 sec =   49.3324 Mbps     0 /  6023 ~drop/pkt  0.00 ~%loss
        5.8691 MB /   1.00 sec =   49.2372 Mbps     0 /  6010 ~drop/pkt  0.00 ~%loss
        5.8789 MB /   1.00 sec =   49.3153 Mbps     0 /  6020 ~drop/pkt  0.00 ~%loss
        5.8701 MB /   1.00 sec =   49.2476 Mbps     0 /  6011 ~drop/pkt  0.00 ~%loss
        5.8496 MB /   1.00 sec =   49.0664 Mbps     0 /  5990 ~drop/pkt  0.00 ~%loss

    57.9736 MB /  10.00 sec =   48.6306 Mbps 99 %TX 5 %RX 40 / 59405 drop/pkt 0.06740 %loss
    [root@localhost ~]#
    ```

### 3.4. Kịch bản dùng để test tốc độ bên trong host.

- Trên client :

    ```sh
    nuttcp -w1m 127.0.0.1
    ```

- Kết quả :

    ```sh
    [root@localhost ~]# nuttcp -w1m 127.0.0.1
    nuttcp-t: Warning: send window size 212992 < requested window size 1048576
    nuttcp-r: Warning: receive window size 212992 < requested window size 1048576
    21980.6875 MB /  10.00 sec = 18437.3359 Mbps 43 %TX 56 %RX 0 retrans 0.17 msRTT
    [root@localhost ~]#
    ```

# Tham Khảo.

- http://nuttcp.net/nuttcp/nuttcp-8.1.4/examples.txt
