#!/bin/bash
#Cockroach startup 
masterb=$1
echo $masterb >> /home/mast
pub=$2
country=$3
state=$4
city=$5
region=$6
store=$7
master=$8 #This value doesn't matter if this is the master node
secure=$9
ca_dir=$10
key_dir=$11
ca_crt=$12
crt_crt=$13
key_key=$14
echo $master >> /home/test
echo " This is the location for file: $ca_dir"
echo " location 2: $key_dir"
if [[ "$masterb" =  True ]]
then
 if [[ "$secure" = True ]]
 then
  echo "creating CA key pair" >> /home/test
  cockroach cert create-ca --certs-dir=$ca_dir --ca-key=$key_dir/ca.key
  echo "Creating a client key pair for the root user" >> /home/test
  cockroach cert create-client root --certs-dir=$ca_dir --ca-key=$key_dir/ca.key
  echo "setting up server as Master in Secure Mode" >> /home/test
  cockroach start --certs-dir=$ca_dir --advertise-host=$pub --background --http-port=443 --store=$store --locality=country=$country,state="$state",city="$city",region=$region
  echo "Cockroachdb has been started and can be accessed at https://$pub" >> /home/test
 else
  echo "setting up server as Master in Insecure Mode" >> /home/test
  cockroach start --insecure --advertise-host=$pub --background --http-port=80 --store=$store --locality=country=$country,state="$state",city="$city",region=$region 
  echo "Cockroachdb has been started and can be accessed at http://$pub" >> /home/test
 fi 
else
 if [["$secure" = True ]]
 then
  echo "uploading CA key pair" >> /home/test
  echo $ca_crt >> $ca_dir/ca.crt
  echo "uploading node crt pair" >> /home/test
  echo $crt_crt >> $ca_dir/node.crt
  echo $key_key >> $ca_dir/node.key
  echo "setting up server as Slave in Secure Mode" >> /home/test
  cockroach start --certs-dir=$ca_dir --advertise-host=$pub --background --http-port=443 --store=$store --locality=country=$country,state="$state",city="$city",region=$region --join=$master
  echo "Cockroachdb has been started and can be accessed at https://$pub" >> /home/test
 else
  echo "setting up Server as slave (insecure). Connecting to Master $master" >> /home/test
  echo "cockroach start --insecure --advertise-host=$pub --background --http-port=80 --store=$store --locality=country=$country,state=$state,city=$city,region=$region --join=$master" >> /home/test
  cockroach start --insecure --advertise-host=$pub --background --http-port=80 --store=$store --locality=country=$country,state="$state",city="$city",region=$region --join=$master  --logtostderr 
  echo "Cockroachdb has been started and can be accessed at http://$pub" >> /home/test
 fi
fi
