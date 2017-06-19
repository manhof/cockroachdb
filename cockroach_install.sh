#!/bin/bash
#Cockroachdb install
secure= $1
ca_dir= $2
key_dir= $3
curl -O https://binaries.cockroachdb.com/cockroach-latest.linux-amd64.tgz
tar xfz cockroach-latest.linux-amd64.tgz
cp -i cockroach-latest.linux-amd64/cockroach /usr/bin
echo "Cockroach has been Installed" >> /home/test
cockroach version >> /home/test
if [[ "$secure" = True ]]
 then
  mkdir $ca_dir
  mkdir $key_dir
  echo " Cert dirs have been created" >> /home/test
 else
  echo "Non Secure Setup" >> /home/test
 fi
