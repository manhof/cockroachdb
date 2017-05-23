#!/bin/bash
#Cockroachdb install
curl -O https://binaries.cockroachdb.com/cockroach-latest.linux-amd64.tgz
tar xfz cockroach-latest.linux-amd64.tgz
cp -i cockroach-latest.linux-amd64/cockroach /usr/bin
echo "Cockroach has been Installed" >> /home/test
cockroach version >> /home/test