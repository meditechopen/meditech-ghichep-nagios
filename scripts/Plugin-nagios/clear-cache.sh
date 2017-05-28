#!/bin/bash

TOTAL=`grep MemTotal /proc/meminfo | awk '{print $2}'`
CACHE=`grep -w Cached /proc/meminfo | awk '{print $2}'`

HALF=`expr $TOTAL / 2`

if [ $CACHE -gt $HALF ]
then
	sync; echo 3 > /proc/sys/vm/drop_caches
fi