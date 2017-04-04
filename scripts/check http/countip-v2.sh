#!/bin/bash
APACHE="/etc/apache2/apache2.conf22"
NGINX="/etc/nginx/nginx.conf"

if [ -f $APACHE ]
    then
    FILE=$APACHE
elif [ -f $NGINX ]
    then
    FILE="/var/log/nginx/access*"
fi

# Duyet xem co bao nhieu IP truy cap

for x in $FILE
    do
        cp $x $x.h2
        rm -rf $x
        touch $x
        nginx -s reload
        cat $x.h2 | awk {'print $1'} >> /tmp/all.h2
        cat /tmp/all.h2 | awk '!a[$0]++' >> /tmp/list.h2
        list=`cat /tmp/list.h2`
        rm -rf $x.h2
    done
# Dem IP

for IP in $list
    do
        if [ "$IP" = "127.0.0.1" ] || [ "$IP" = "::1" ] || [ "$IP" = "\"" ]
        then
            continue;
        else
            c=`cat /tmp/all.h2 | grep -w "$IP" | wc -l`
            if [ $c -gt 1000 ]
            then
                 echo "$IP: $c" >> /tmp/ip.txt
            fi
        fi 
    done 
rm -rf /tmp/*.h2
if [ -f /tmp/ip.txt ]
    then
    count=`cat /tmp/ip.txt| wc -l`
    echo -e "Bam Dai ca,
Chi trong vong 10p, co $count thang spam hon 1000 request.
Cu the nhu sau: 
$(cat /tmp/ip.txt)
Script by HoangDH @ MDT JSC,.
" | mail -u "Mr. Monitoring" -s "V.v Canh bao truy cap Website" daohuyhoang87@gmail.com
    rm -rf /tmp/ip.txt
fi
