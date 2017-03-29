# Sử dụng giao diện web của Nagios

# Mục lục:
- [1. Giao diện tổng quan của Nagios dashboard](#1)
- [2. Current status](#2)
	- [2.1 Tactical Monitoring Overview: ](#21)
	- [2.2 Map (Legacy)](#22)
	- [2.3 Hosts](#22)
		- [2.3.1 Thông tin cụ thể của host](#231)
		- [2.3.2 Host command](#232)
	- [2.4 Services](#24)
		-[2.4.1 Thông tin chi tiết của 1 service](#241)
	- [2.5 Host group](#25)
- [3. Reports](#3)
- [4. System](#4)


------------------------------------------------------

<a name="1"></a>
## 1. Giao diện tổng quan của Nagios dashboard
<img src="http://i.imgur.com/aqpOOjn.png">

- Mục 1:
<ul>
<li>Tên sản phẩm Nagios là Nagios Core</li>
<li>Tiến trình daemon đang chạy với PID</li>
<li>Phiên bản Nagios Core</li>
</ul>

- Mục 2: Các sản phẩm Nagios khác

- Mục 3: General: giới thiệu chung về sản phẩm Nagios và tài liệu docs của Nagios

- Mục 4: Current status: Trạng thái gần đây của Nagios, sẽ hiển thị thông tin giám sát tại đây

- Mục 5: Report: Báo cáo về các trạng thái đang diễn ra trên hệ thống

- Mục 6: System


<a name="2"></a>
## 2. Current status
<img src="http://i.imgur.com/tH2p8S2.png">


<a name="21"></a>
### 2.1 Tactical Monitoring Overview: 
Thể hiện 1 cách tổng quan về các trạng thái giám sát
<ul>
<li>Mục 1: Thể hiện Network Outages (tình trạng mạng gián đoạn)</li>
<li>Mục 2: Thể hiện tình trạng các host được giám sát</li>
<li>Mục 3: Thể hiện tình trạng các service trên các host</li>
<li>Mục 4: Thể hiện các tính năng giám sát như flap detecting, Notifications...</li>
<li>Mục 5: Hiệu suất giám sát như thời gian thực hiện check, tình trạng host, service</li>
<li>Mục 6: Đánh giá sức khỏe của hệ thống</li>
</ul>


<a name="22"></a>
### 2.2 Map (Legacy): Mô tả các host được giám sát trong hệ thống
<img src="http://i.imgur.com/Grmt0f2.png">

- Các host được giám sát

- Host local

<a name="23"></a>
### 2.3 Host: Các host được giám sát
<img src="http://i.imgur.com/6xLEZTk.png">
<ul>
<li>Mục 1: Bảng tổng quan về trạng thái các host và các service đang được giám sát. Khi click vào bất cứ thông số nào như Up, Down, Unreachable, Pending sẽ hiện ra thông tin các host đang trong trạng thái trên</li>
<li>Mục 2: Thông tin chi tiết về các host đang giám sát như lần check cuối cùng, trạng thái host, thời gian host được giám sát, thông tin</li>
<ul>

#### 2.3.1 Thông tin cụ thể của host
<img src="http://i.imgur.com/0ChV11k.png">

<ul>
<li>Mục 1: Tên của host</li>
<li>Mục 2: Tên hostgroup mà host thuộc về</li>
<li>Mục 3: Địa chỉ IP của host</li>
<li>Mục 4: Các thông tin cụ thể của host như trạng thái, thời gian check...</li>
<li>Mục 5: Host command là các command cụ thể để thực thi ngay 1 lệnh đến host như disable active check, gửi cảnh báo...</li>
</ul>


<a name="232"></a>
#### 2.3.2 Host command
Các host command thực thi 1 lệnh đến host 
<ul>
<li>Locate host on map: command này sẽ dẫn đến map của hệ thống giám sát</li>
<li>Disable active checks of this host: command này sẽ disable ngay lập tức active check host</li>
<li>Re-schedule the next check of this host: Thay đổi lịch trình lần check tiếp theo của host</li>
<li>Submit passive check result for this host: Lệnh này gửi kết quả check passive cho 1 máu chủ cụ thể</li>
<li>Stop accepting passive checks for this host: Ngừng chấp nhận check passive cho máy chủ này</li>
<li>Stop obsessing over this host</li>
<li>Disable notifications for this host: Tắt thông báo của host</li>
<li>Send custom host notification: Gửi ngay lập tức thông tin cụ thể của host mail</li>
<li>Schedule downtime for this host: Lệnh này sẽ lên kế hoạch cho thời gian downtime của host, trong thời gian này nagios sẽ ko gửi cảnh báo</li>
<li>Schedule downtime for all services on this host: Lệnh này sẽ lên kế hoạch cho thời gian downtime của service</li>
<li>Disable notification for all services on this host: Tắt thông báo cho tất cả dịch vụ trên host</li>
<li>Enable notification for all services on this host: Bật thông báo cho tất cả dịch vụ trên host</li>
<li>Schedule a check of all services on this host: Lên lịch kiểm tra cho tất cả dịch vụ trên host</li>
<li>Disable checks of all services on this host: Tắt thông báo cho tất cả dịch vụ trên host</li>
<li>Enable checks of all services on this host: Bật thông báo cho tất cả dịch vụ trên host</li>
<li>Disable event handler for this host</li>
<li>Disable flap detection for this host: Ngắt phát hiện trạng thái flap của host</li>
</ul>


<a name="24"></a>
### 2.4 Service: Thông tin về các dịch vụ đang được giám sát trên các host
<img src="http://i.imgur.com/eG07E6V.png">
<ul>
<li>Bảng thông tin chi tiết các dịch vụ đang được giám sát như tên dịch vụ, trạng thái dịch vụ, dịch vụ thuộc host nào...</li>
</ul>

#### 2.4.1 Thông tin chi tiết của 1 service
<img src="http://i.imgur.com/vmCApid.png">

<ul>
<li>Mục 1: Tên của service</li>
<li>Mục 2: Tên của host mà service đang được đặt trên đó</li>
<li>Mục 3: Tên servicegroup nơi service nằm trong đó</li>
<li>Mục 4: IP của host mà service nằm trên đó</li>
<li>Mục 5: Thông tin cụ thể của service như trạng thái, thời gian check...</li>
<li>Mục 6: Service command là những command thực thi 1 lệnh đến service như gửi mail cảnh báo, disable service...</li>
</ul>









