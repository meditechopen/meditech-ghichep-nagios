## Monitor RabbitMQ trong nagios

### Nội dung

- [ 1. Thông tin host ](#1)
- [ 2. Chuẩn bị và cài đặt Plugin ](#2)
    - [ 2.1. Chuẩn bị ](#2.1)
    - [ 2.2. Cài đặt Plugin](#2.2)
    - [ 2.3. Thêm thông tin host và giám sát ](#2.3)
<a name="1"></a>
### 1. Thông tin host RabbitMQ

```
OS: Ubuntu 16.04
IP: 192.168.100.136
Hostname: node1
Service: RabbitMQ
```
<a name="2"></a>
### 2. Chuẩn bị và cài đặt Plugin

#### 2.1 Chuẩn bị

#### Cài đặt perl và gói `Monitoring::Plugins`

```sh
curl -L http://cpanmin.us | perl - --sudo App::cpanminus
perl -MCPAN -e 'install Monitoring::Plugin'
perl -MCPAN -e 'install Config::Tiny'
perl -MCPAN -e 'install JSON'
perl -MCPAN -e 'install Math::Calc::Units'
```

Lưu ý: Khi lần đầu chạy lệnh trên, CPAN sẽ yêu cầu một số thiết lập, bấm Enter để nhập mặc định.

#### 2.2 Cài đặt Plugin

#### Tải gói plugin từ `git` và copy chúng vào thư mục plugins

```
git clone https://github.com/nagios-plugins-rabbitmq/nagios-plugins-rabbitmq.git

mkdir /usr/local/nagios/libexec/rabbitmq/
cp nagios-plugins-rabbitmq/scripts/* /usr/local/nagios/libexec/rabbitmq/

chown -R nagios. /usr/local/nagios/libexec/rabbitmq/
```

#### 2.3. Thêm thông tin host và giám sát

Đầu tiên, chúng ta phải tạo một user có chức năng `monitoring` trên RabbitMQ.

```
rabbitmqctl add_user mon 1
rabbitmqctl set_user_tags mon monitoring
rabbitmqctl set_permissions -p / mon ".*" ".*" ".*" 
```

Quay trở lại Nagios server, chúng ta sẽ thêm phần thông tin của RabbitMQ vào `/etc/hosts`

```
vi /etc/hosts
```

```
...
192.168.100.136 node1
```

Kiểm tra plugin, bằng lệnh sau:

```
cd /usr/local/nagios/libexec/rabbitmq/
./check_rabbitmq_server -H "node1" -u mon -p 1
```

<img src="../images/plugin-rabbitmq1.png" />

#### Thêm câu lệnh kiểm tra trong Nagios:

```
vi /usr/local/nagios/etc/objects/commands.cfg
```

```
...
# Check RabbitMQ

define command {
 command_name check_rabbitmq_aliveness
 command_line $USER1$/rabbitmq/check_rabbitmq_aliveness -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}
define command {
 command_name check_rabbitmq_cluster 
 command_line $USER1$/rabbitmq/check_rabbitmq_cluster -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$ -w 1 -c 2
}
define command {
 command_name check_rabbitmq_connections
 command_line $USER1$/rabbitmq/check_rabbitmq_connections -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}
define command {
 command_name check_rabbitmq_exchange
 command_line $USER1$/rabbitmq/check_rabbitmq_exchange -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}

define command {
 command_name check_rabbitmq_objects
 command_line $USER1$/rabbitmq/check_rabbitmq_objects -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}


define command {
 command_name check_rabbitmq_overview
 command_line $USER1$/rabbitmq/check_rabbitmq_overview -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}

define command {
 command_name check_rabbitmq_partition
 command_line $USER1$/rabbitmq/check_rabbitmq_partition -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}

define command {
 command_name check_rabbitmq_queue
 command_line $USER1$/rabbitmq/check_rabbitmq_queue -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}

define command {
 command_name check_rabbitmq_server
 command_line $USER1$/rabbitmq/check_rabbitmq_server -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}

define command {
 command_name check_rabbitmq_shovels
 command_line $USER1$/rabbitmq/check_rabbitmq_shovels -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}

define command {
 command_name check_rabbitmq_watermark
 command_line $USER1$/rabbitmq/check_rabbitmq_watermark -H $ARG1$ --port=$ARG2$ -u $ARG3$ -p $ARG4$
}
...
```

Lưu ý: các lệnh trên chưa đặt ngưỡng cảnh báo.

Tiếp theo, chúng ta tạo một `host` mới

```
vi /usr/local/nagios/etc/servers/rabbitmq01.cfg
```

```
define host{
use                             linux-server
host_name                       rabbitmq01
alias                           RabbitMQ Server
address                         node1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ aliveness
    check_command           check_rabbitmq_aliveness!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ cluster
    check_command           check_rabbitmq_cluster!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ connections
    check_command           check_rabbitmq_connections!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ exchange
    check_command           check_rabbitmq_exchange!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ objects 
    check_command           check_rabbitmq_objects!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ overview  
    check_command           check_rabbitmq_overview!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ partition 
    check_command           check_rabbitmq_partition!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ queue
    check_command           check_rabbitmq_queue!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ server 
    check_command           check_rabbitmq_server!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ shovels 
    check_command           check_rabbitmq_shovels!node1!15672!mon!1
}
define service {
    use                     generic-service
    host_name               rabbitmq01
    service_description     RabbitMQ watermark
    check_command           check_rabbitmq_watermark!node1!15672!mon!1
}
```

Lưu lại file và khởi động lại nagios

```
systemctl restart nagios
```

Kiểm tra trên Web UI:

<img src="../images/plugin-rabbitmq2.png">