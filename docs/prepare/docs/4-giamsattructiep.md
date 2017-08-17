# Note về cơ chế goám sát trực tiếp trong Nagios.

## 1. Giám sát qua SNMP.

Các thiết bị mạng chủ yếu được giám sát (và điều khiển trong trường hợp cần thiết) thông qua giao thức quản trị mạng SNMP 
(Simple Network Management Protocol). Nagios cũng hoạt động theo cơ chế này, cũng thông qua chuỗi SNMP community string để 
lấy dữ liệu của các router/switch và thực hiện giám sát. Thực tế Nagios (cùng rất nhiều các phần mềm giám sát có hỗ trợ giám 
sát thông qua SNMP) cũng có thể giám sát các máy tính, máy chủ, … hoặc bất kỳ thứ gì có bật sẵn giao thức SNMP .

![](/docs/prepare/images/nrpe.png)
Đối với giám sát qua SNMP thì các trường hợp thường được áp dụng hiện nay như : Giám sát các thiết bị mạng (router, switch) 
để có được tình trạng hiện tại của các thiết bị mạng , nó cho ta biết đc các port hiện tại có mở hay không, tình trạng uptime 
như thế nào.

Để có thể giám sát qua SNMP nagios cần có một plugin tra dịch vụ qua giao thức snmp, nagios server sẽ sử dụng plugin check_snmp hoặc check_mrtgtraf
để kiểm tra các dịch vụ trên client có hỗ trợ giao thức SNMP.

Sử dụng SSH để có thể lấy được các thông tin hệ thống.

## 2. Giám sát qua NRPE.

NRPE là một addon cho Nagios giúp thực thi các plugin khác để monitor/check các resources (CPU load, memory usage, swap usage, disk usage, logged in users, running processes, v.v..) 
và services (http, ftp, v.v..) trên các máy Linux/Unix ở xa.

![](/docs/prepare/images/snmp.png)

NRPE addon bao gồm 2 thành phần:
 <ul>
  <li>Plugin check_nrpe: nằm trên máy Nagios (là monitoring server)</li>
  <li>Daemon NRPE: chạy trên máy Linux/Unix (remote host) cần monitor</li>
 </ul>

Khi máy Nagios cần check các resources/services trên máy Linux/Unix ở xa:
 <ul>
  <li>Nagios sẽ thực thi plugin check_nrpe và cho biết resource/service nào cần check</li>
  <li>Plugin check_nrpe sẽ liên lạc với daemon NRPE trên remote host. Kênh liên lạc có thể được bảo vệ bằng SSL</li>
  <li>Daemon NRPE sẽ chạy các plugin thích hợp (như check_disk, check_load, check_http, v.v..) để check các resource/service được yêu cầu</li>
  <li>NRPE daemon truyền kết quả cho check_nrpe, sau đó plugin này trả kết quả lại cho Nagios process</li>
 </ul>

Phải sử dụng SSH để lấy được các thông tin về tài nguyên và thông tin các dịch vụ đang chạy


Đối với giám sát qua NRPE thường được áp dụng để theo dõi tình trạng tài nguyên hoặc dịch vụ trên máy chủ để người quản trị 
có thể đưa ra những ứng phó kịp thời khi xảy ra những sự cố.