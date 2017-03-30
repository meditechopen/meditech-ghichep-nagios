#!/bin/bash
apt-get -y install postfix mailutils
read -p "Enter your gmail: " mail
read -p "Password: " pass
# sed -i 's/nagios@localhost/daohuyhoang87@gmail.com/g'  /usr/local/nagios/etc/objects/contacts.cfg
echo "[smtp.gmail.com]:587    $mail:$pass" > /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd
echo "relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_security_options =
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" > /etc/postfix/main.cf
postmap /etc/postfix/sasl_passwd
systemctl restart postfix.service
clear
echo "Finish!!!" | mail -s "V.v Cai dat xong mail canh bao" daohuyhoang87@gmail.com