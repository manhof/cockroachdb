#!/bin/bash
gawk -F= '/^ID=/{print $2}' /etc/os-release > /home/id.txt
serverbuild=$(cat /home/id.txt)
echo " This is the Server Build: " $serverbuild >> /home/test
service="Cockroachdb"
title= "Cockroachdb Ports requried for Admin"
description="Cockroachdb ports required for access and administration. we use a different default http-port (80) than default"
port1="26257"
port2="80"
protocol="tcp"
echo "Firewall Configuration" >> /home/test
if [[ $serverbuild == *"ubuntu"* ]]
 then
	echo "[$service]" >> /etc/ufw/applications.d/$service
    echo "title=$title" >> /etc/ufw/applications.d/$service
    echo "description=$description" >> /etc/ufw/applications.d/$service
    echo "ports=$port1,$port2/$protocol" >> /etc/ufw/applications.d/$service
    ufw update $service
	ufw allow in OpenSSH
    ufw allow in $service
    ufw enable
    ufw status >> /home/test
elif [[ $serverbuild == *"centos"* ]]
 then
	dnf install firewalld -y
	echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" >> /etc/firewalld/services/$service.xml
	echo "<service>" >> /etc/firewalld/services/$service.xml
	echo "   <short>$title</short>" >> /etc/firewalld/services/$service.xml
	echo "   <description>$description</description>" >> /etc/firewalld/services/$service.xml
	echo "   <port protocol=\"$protocol\" port=\"$port1\"/>" >> /etc/firewalld/services/$service.xml
	echo "   <port protocol=\"$protocol\" port=\"$port2\"/>" >> /etc/firewalld/services/$service.xml
	echo "</service>" >> /etc/firewalld/services/$service.xml
	firewall-offline-cmd --zone=public --add-interface=eth0
	firewall-offline-cmd --set-default-zone=public
	firewall-offline-cmd --zone=public --add-service=ssh
	firewall-offline-cmd --zone=public --add-service=$service
	echo "Default Zone" >> /home/test
	firewall-offline-cmd --get-default-zone >> /home/test
	firewall-offline-cmd --info-zone=public >> /home/test
	systemctl start firewalld
	systemctl enable firewalld
else
	echo "Cannot determine Build Type... Exiting" >> /home/test
	exit 3
fi  
echo "END FIREWALL CONFIG" >> /home/test
