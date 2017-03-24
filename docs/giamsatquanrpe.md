1. Cài đặt NRPE và Plugin trên Client: https://support.nagios.com/kb/article.php?id=8

2. Khai báo câu lệnh check_nrpe trên Srv

```
vi /usr/local/nagios/etc/objects/commands.cfg

define command{
        command_name check_nrpe
        command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}
```

3. Khai báo câu lệnh cần check trên client

```
vi /usr/local/nagios/etc/nrpe.cfg
...
# The following examples use hardcoded command arguments...

command[check_disk]=/usr/local/nagios/libexec/check_disk -w 70 -c 80
command[check_ssh]=/usr/local/nagios/libexec/check_ssh localhost
command[check_swap]=/usr/local/nagios/libexec/check_swap -c 60% -w 80%
...
```

Khởi động lại dịch vụ

```
systemctl restart xinetd
```

4. Khai báo host trên srv

```
vi /usr/local/nagios/etc/servers/nrpe1.cfg

define host{
use                             linux-server
host_name                       nrpe1
alias                           CentOS 7
address                         192.168.100.198
}

define service{
use                     generic-service
host_name               nrpe1
service_description     CPU Load
check_command           check_nrpe!check_load
}
define service{
use                     generic-service
host_name               nrpe1
service_description     Total Processes
check_command           check_nrpe!check_total_procs
}
define service{
use                     generic-service
host_name               nrpe1
service_description     Current Users
check_command           check_nrpe!check_users
}
define service{
use                     generic-service
host_name               nrpe1
service_description     SSH Monitoring
check_command           check_nrpe!check_ssh
}
define service{
use                     generic-service
host_name               nrpe1
service_description     SWAP Monitoring
check_command           check_nrpe!check_swap
}
define service{
use                     generic-service
host_name               nrpe1
service_description     DISK Monitoring
check_command           check_nrpe!check_disk
}

```

Khởi động lại dịch vụ

```
systemctl restart nagios
```