# Sử dụng giao diện web của Nagios

#### 1. Giao diện tổng quan của Nagios dashboard
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

#### 2. Current status
<img src="http://i.imgur.com/tH2p8S2.png">
- Tactical Monitoring Overview: Thể hiện 1 cách tổng quan về các trạng thái giám sát
<ul>
<li>Mục 1: Thể hiện Network Outages (tình trạng mạng gián đoạn)</li>
<li>Mục 2: Thể hiện tình trạng các host được giám sát</li>
<li>Mục 3: Thể hiện tình trạng các service trên các host</li>
<li>Mục 4: Thể hiện các tính năng giám sát như flap detecting, Notifications...</li>
<li>Mục 5: Hiệu suất giám sát như thời gian thực hiện check, tình trạng host, service</li>
<li>Mục 6: Đánh giá sức khỏe của hệ thống</li>
</ul>

- Map (Legacy): Mô tả các host được giám sát trong hệ thống
<img src="http://i.imgur.com/Grmt0f2.png">

- Host: Các host được giám sát
<img src="http://i.imgur.com/6xLEZTk.png">
<ul>
<li>Mục 1: Bảng tổng quan về trạng thái các host và các service đang được giám sát. Khi click vào bất cứ thông số nào như Up, Down, Unreachable, Pending sẽ hiện ra thông tin các host đang trong trạng thái trên</li>
<li>Mục 2: Thông tin chi tiết về các host đang giám sát</li>
<ul>

- Service: Thông tin về các dịch vụ đang được giám sát trên các host
<img src="http://i.imgur.com/eG07E6V.png">
<ul>
<li>Bảng thông tin chi tiết các dịch vụ đang được giám sát như tên dịch vụ, trạng thái dịch vụ, dịch vụ thuộc host nào...</li>
</ul>







