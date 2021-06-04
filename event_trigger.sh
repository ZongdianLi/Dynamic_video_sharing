#!/bin/bash
# IP monitor + video streaming
# author: Zongdian Li, V2X Group.
# email: lizd@mobile.ee.titech.ac.jp

# Mv2 config
Mv2_IP="10.0.0.5"
Mv2_USERNAME="autoware"
Mv2_PWD="autoware"

# OBU config
IP="10.0.0.6"
USERNAME="panasonic"
PWD="Tit_ITS@2021"

# Flag definition
activate_flag=1
deactivate_flag=0
status=0

while true
do
	ip=`ifconfig wlp2s0|grep inet|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
	if [ $ip ] && [ $status -eq $deactivate_flag ]
	then 
		subnet=`echo ${ip:0:9}`
        rsuip="$subnet.1"
		echo "Connect to RSU@$rsuip"
		echo "Start video streaming......" 
		#vlc &
		/usr/bin/expect -f port_forwarding.exp ${rsuip} ${Mv2_IP} ${Mv2_USERNAME} ${Mv2_PWD} ${IP} ${USERNAME} ${PWD} > /dev/null &
		/usr/bin/expect -f video_viewer.exp ${Mv2_IP} ${Mv2_USERNAME} ${Mv2_PWD} > /dev/null &
		#echo "Debug......"
		status=1
	else 
		if [ -z $ip ] && [ $status -eq $activate_flag ]
		then
			echo "Disconnect from RSU......"
			/usr/bin/expect -f video_turnoff.exp ${Mv2_IP} ${Mv2_USERNAME} ${Mv2_PWD} >/dev/null &
			#killall vlc
			status=0
		fi
	fi
done
		

