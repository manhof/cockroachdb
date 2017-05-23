#!/bin/bash
#Cockroach startup 
masterb=$1
pub=$2
country=$3
state=$4
city=$5
region=$6
master=$7 #This value doesn't matter if this is the master node
if [[ $masterb -eq 1 ]]
 then
	echo "setting up server as Master" >> /home/test
    cockroach start --insecure --advertise-host=$pub --background --http-port=80 --store=/mnt/cockroach --locality=country=$country,state=$state,city=$city,region=$region 
else
    echo "setting up Server as slave. Connecting to Master $master" >> /home/test
    cockroach start --insecure --advertise-host=$pub --background --http-port=80 --store=/mnt/cockroach --locality=country=$country,state=$state,city=$city,region=$region --join=$master
fi
echo "Cockroachdb has been started and can be accessed at http://$pub" >> /home/test