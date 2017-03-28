#!/bin/bash

## Duyet xem co bao nhieu IP truy cap
#FILE="/var/log/nginx/access*"

FILE="/var/log/apache2/access.log.1"
list=`cat $FILE | awk {'print $1'} | awk '!a[$0]++'`

# Dem IP

for IP in $list
    do
        if [ "$IP" = "127.0.0.1" ] || [ "$IP" = "::1" ] || [ "$IP" = "\"" ]
        then
            continue;
        else
            c=`cat $FILE | grep -w "$IP" | wc -l`
            if [ $c -gt 1000 ]
            then
                 echo "$IP: $c" >> /tmp/ip.txt
            fi
        fi 
    done 
    
if [ -f /tmp/ip.txt ]
    then
    echo -e "Bam Dai ca,
Chi trong vong 10p, co mot so thang spam hon 1000 request.
Cu the nhu sau: 
$(cat /tmp/ip.txt)
Script by HoangDH @ MDT JSC,.
" | mail -u "Mr. Monitoring" -s "V.v Canh bao truy cap Website" daohuyhoang87@gmail.com
    rm -rf /tmp/ip.txt
fi