# Tìm hiểu về Nagvis.

## 1. Navis là gì?

Nagvis là một addon trực quan giúp cho chúng ta có thể thấy được hệ thống quản lý mạng Nagios.

Nagvis có thể cho chúng ta thấy được dữ liệu từ Nagios (ví dụ như hiển thị các IT process như là một mail system hoặc một cơ sở hạ tầng mạng). Sử dụng dữ liệu được cung cấp bởi backend nó sẽ cập nhật vị trí của các đối tượng trên map trong khoảng thời gian nhất định để phản ánh tình trạng hiện tại . Các maps cho phép chúng ta thay đổi các đối tượng để có thể hiển thị chúng trên các layouts khác nhau : 

- Physical : tất cả các host trong một rack/room/department.

- Logical : Tất cả các application servers.

- Geographical : Tất cả các hosts trong một khu vực.

- Business processes : Tất cả các host và services liên quan tới một processs.

## 2. Nagvis làm việc như thế nào.

Nói chung Nagvis là công cụ phục vụ cho việc hiển thị các các thông tin được thu thập bởi Nagios và chuyển giao thông qua các backends.

Nó hỗ trợ các backends :

- Mklivestatus : mặc định từ bản Nagvis 1.5.

- NDoutils/IDoutils (yêu cầu Mysql).

- Merlin (yêu cầu Mysql).

Backend sẽ lấy thông tin từ Nagios process (mklivestatus) hoặc từ một cơ sở dữ liệu (NDoutils, IDoutils,merlin).

Chúng ta có thể đặt tất cả các đối tượng từ Nagios (Host, Services, Hostgroups, Servicegroups) trên một thứ được gọi là maps. Một map cần được cấu hình thông qua một file cấu hình .CHúng ta có thể chinh sửa file cấu hình này bằng một trình sửa văn bản như `vi` hoặc có thể chỉnh sửa thông qua web. Hơn nữa chúng ta có thể thêm một vài những đối tượng đặc biệt trên Nagvis . Những đối tượng đó là  shapes, textboxes và tham khảo các đối tượng từ các maps khác.

Mỗi đối tượng trên maps của chúng ta đều có thể được cấu hình đúng như những gì chúng ta cần . Ví dụ chúng ta có những liên kết đến giao diện Nagios đến mỗi đối tượng đại diện cho Nagios. Chúng ta có thể tùy chỉnh cho các liên kết này. 

## 3. Cài đặt.

Tải file cài đặt từ git :

```sh
cd /opt
git clone https://github.com/NagVis/nagvis.git
```

Cài đặt gói `graphviz` . Khi cài đặt hệ thống không thể tự động tìm được các gói `graphviz` cho lên chúng ta cài đặt trước gói này :

```sh
yum install graphviz -y
```

Phân quyền và cài đặt :

```sh
cd nagvis
chmod +x install.sh
./install.sh
```

Cài đặt theo hướng dẫn có sẵn . Sau khi cài đặt xong chúng ta check file log :

```sh
cat install.log
```

Kiểm tra lại file log :

```sh
[root@nagios-core nagvis]# cat install.log
+------------------------------------------------------------------------------+
| Welcome to NagVis Installer 1.9.4                                            |
+------------------------------------------------------------------------------+
| This script is built to facilitate the NagVis installation and update        |
| procedure for you. The installer has been tested on the following systems:   |
| - Debian, since Etch (4.0)                                                   |
| - Ubuntu, since Hardy (8.04)                                                 |
| - SuSE Linux Enterprise Server 10 and 11                                     |
|                                                                              |
| Similar distributions to the ones mentioned above should work as well.       |
| That (hopefully) includes RedHat, Fedora, CentOS, OpenSuSE                   |
|                                                                              |
| If you experience any problems using these or other distributions, please    |
| report that to the NagVis team.                                              |
+------------------------------------------------------------------------------+
| Do you want to proceed? [y]: +------------------------------------------------------------------------------+
| Starting installation of NagVis 1.9.4                                        |
+------------------------------------------------------------------------------+
|                                                                              |
+--- Checking for tools -------------------------------------------------------+
| Using packet manager /usr/bin/rpm                                      found |
|                                                                              |
+--- Checking paths -----------------------------------------------------------+
| Please enter the path to the nagios base directory [/usr/local/nagios]: |   nagios path /usr/local/nagios                                        found |
| Please enter the path to NagVis base [/usr/local/nagvis]: |                                                                              |
+--- Checking prerequisites ---------------------------------------------------+
| PHP 5.4                                                                found |
|   PHP Module: gd                                                     MISSING |
|   PHP Module: mbstring                                               MISSING |
|   PHP Module: gettext compiled_in                                      found |
|   PHP Module: session compiled_in                                      found |
|   PHP Module: xml compiled_in                                          found |
|   PHP Module: pdo php                                                  found |
|   Apache mod_php                                                       found |
| Do you want to update the backend configuration? [n]: | Graphviz 2.30                                                          found |
|   Graphviz Module dot 2.30.1                                           found |
|   Graphviz Module neato 2.30.1                                         found |
|   Graphviz Module twopi 2.30.1                                         found |
|   Graphviz Module circo 2.30.1                                         found |
|   Graphviz Module fdp 2.30.1                                           found |
| SQLite 3.7                                                             found |
|                                                                              |
+--- Trying to detect Apache settings -----------------------------------------+
| Please enter the web path to NagVis [/nagvis]: | Please enter the name of the web-server user [apache]: | Please enter the name of the web-server group [apache]: | create Apache config file [y]: |                                                                              |
+--- Checking for existing NagVis ---------------------------------------------+
| NagVis 1.9.4                                                           found |
| Do you want the installer to update your config files when possible? [y]: | Remove backup directory after successful installation? [n]: |                                                                              |
+------------------------------------------------------------------------------+
| Summary                                                                      |
+------------------------------------------------------------------------------+
| NagVis home will be:           /usr/local/nagvis                             |
| Owner of NagVis files will be: apache                                        |
| Group of NagVis files will be: apache                                        |
| Path to Apache config dir is:  /etc/httpd/conf.d                             |
| Apache config will be created: yes                                           |
|                                                                              |
| Installation mode:             update                                        |
| Old version:                   1.9.4                                         |
| New version:                   1.9.4                                         |
| Backup directory:              /usr/local/nagvis.old-2017-10-05_03:54:38     |
|                                                                              |
| Note: The current NagVis directory will be moved to the backup directory.    |
|       The backup directory will be NOT removed after successful installation |
|       Your configuration files will be copied.                               |
|       The configuration files will be updated if possible.                   |
|                                                                              |
| Do you really want to continue? [y]: +------------------------------------------------------------------------------+
| Starting installation                                                        |
+------------------------------------------------------------------------------+
| Moving old NagVis to /usr/local/nagvis.old-2017-10-05_03:54:38..       done  |
| Creating directory /usr/local/nagvis...                                done  |
| Creating directory /usr/local/nagvis/var...                            done  |
| Creating directory /usr/local/nagvis/var/tmpl/cache...                 done  |
| Creating directory /usr/local/nagvis/var/tmpl/compile...               done  |
| Creating directory /usr/local/nagvis/share/var...                      done  |
| Copying files to /usr/local/nagvis...                                  done  |
| Creating directory /usr/local/nagvis/etc/profiles...                   done  |
| Creating main configuration file...                                    done  |
|   Adding webserver group to file_group...                              done  |
| *** /etc/httpd/conf.d/nagvis.conf will NOT be overwritten !                  |
| *** creating /etc/httpd/conf.d/nagvis.conf.2017-10-05_03:54:38 instead (comm |
| Creating web configuration file...                                     done  |
| Setting permissions for web configuration file...                      done  |
|                                                                              |
| Restoring main configuration file(s)...                                done  |
| Restoring custom map configuration files...                            done  |
| Restoring custom geomap source files...                                done  |
| Restoring user configuration files...                                  done  |
| Restoring conf.d/ configuration files...                               done  |
| Restoring custom map images...                                         done  |
| Restoring custom gadget images...                                      done  |
| Restoring custom iconsets...                                           done  |
| Restoring custom shapes...                                             done  |
| Restoring custom templates...                                          done  |
| Restoring custom template images...                                    done  |
| Restoring custom gadgets...                                            done  |
| Restoring custom scripts...                                            done  |
| Restoring custom stylesheets...                                        done  |
|                                                                              |
+------------------------------------------------------------------------------+
| Handling changed/removed options                                             |
+------------------------------------------------------------------------------+
| Removing allowedforconfig option from main config...                   done  |
| Removing autoupdatefreq option from main config...                     done  |
| Removing htmlwuijs option from main config...                          done  |
| Removing wuijs option from main config...                              done  |
| Removing showautomaps option from main config...                       done  |
| Removing usegdlibs option from main config...                          done  |
| Removing displayheader option from main config...                      done  |
| Removing hovertimeout option from main config...                       done  |
| Removing requestmaxparams option from main config...                   done  |
| Removing requestmaxlength option from main config...                   done  |
| Removing allowed_for_config option from map configs...                 done  |
| Removing allowed_user from map configs...                              done  |
| Removing hover_timeout from map configs...                             done  |
| Removing usegdlibs from map configs...                                 done  |
| Removing gadget_type from map configs...                               done  |
+------------------------------------------------------------------------------+
| HINT: Please check the changelog or the documentation for changes which      |
|       affect your configuration files                                        |
|                                                                              |
+--- Setting permissions... ---------------------------------------------------+
| /usr/local/nagvis/etc/nagvis.ini.php-sample                            done  |
| /usr/local/nagvis/etc                                                  done  |
| /usr/local/nagvis/etc/maps                                             done  |
| /usr/local/nagvis/etc/maps/*                                           done  |
| /usr/local/nagvis/etc/geomap                                           done  |
| /usr/local/nagvis/etc/geomap/*                                         done  |
| /usr/local/nagvis/etc/profiles                                         done  |
| /usr/local/nagvis/share/userfiles/images/maps                          done  |
| /usr/local/nagvis/share/userfiles/images/maps/*                        done  |
| /usr/local/nagvis/share/userfiles/images/shapes                        done  |
| /usr/local/nagvis/share/userfiles/images/shapes/*                      done  |
| /usr/local/nagvis/var                                                  done  |
| /usr/local/nagvis/var/*                                                done  |
| /usr/local/nagvis/var/tmpl                                             done  |
| /usr/local/nagvis/var/tmpl/cache                                       done  |
| /usr/local/nagvis/var/tmpl/compile                                     done  |
| /usr/local/nagvis/share/var                                            done  |
|                                                                              |
+------------------------------------------------------------------------------+
| Installation complete                                                        |
|                                                                              |
| You can safely remove this source directory.                                 |
|                                                                              |
| For later update/upgrade you may use this command to have a faster update:   |
| ./install.sh -n /usr/local/nagios -p /usr/local/nagvis -u apache -g apache -w /etc/httpd/conf.d -a y
|                                                                              |
| What to do next?                                                             |
| - Read the documentation                                                     |
| - Maybe you want to edit the main configuration file?                        |
|   Its location is: /usr/local/nagvis/etc/nagvis.ini.php                      |
| - Configure NagVis via browser                                               |
|   <http://localhost/nagvis/config.php>                                       |
| - Initial admin credentials:                                                 |
|     Username: admin                                                          |
|     Password: admin                                                          |
+------------------------------------------------------------------------------+

```


Ở đây chúng ta nhận thấy có 2 gói bị miss đó là :

```sh
|   PHP Module: gd                                                     MISSING |
|   PHP Module: mbstring                                               MISSING |
```

Chúng ta tiến hành cài đặt 2 gói không được tìm thấy này :

```sh
yum install php-gd -y
yum install php-mbstring -y
```

Restart `httpd` :

```sh
systemctl restart httpd
```

Đăng nhập vào web để kiểm tra :

![scr1](/docs/prepare/images/scr1.png)