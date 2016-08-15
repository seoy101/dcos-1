#!/bin/bash

index=0
echo -n "input network interface: "
read interfaceVar
array[$index]=$interfaceVar
((index+=1))

echo -n "input each password:"
read password
array[$index]=$password
((index+=1))

echo -n "input ssh port:"
read portNum
array[$index]=$portNum
((index+=1))

masterIpNum=0

while true; do
echo -n "input master ip (press q to quit):"
read masterip


if [ "$masterip" == "q" ]; then
 break
else
 array[$index]=$masterip
 ((masterIpNum+=1))
 ((index+=1))
fi

done


while true; do
echo -n "input worker ip(press q to quit):"
read value

if [ "$value" == "q" ]; then
 break
else
 array[$index]=$value
 ((index+=1))
fi

done

arrlen=${#array[@]}


rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y python-pip

pip install virtualenv

cd /dcos/
mkdir dcosclidir && cd dcosclidir

curl -O https://downloads.dcos.io/dcos-cli/install.sh
echo "yes" | bash install.sh . http://${array[3]}
source /dcos/dcosclidir/bin/env-setup
dcos auth login
echo "yes" | dcos package install chronos

sleep 1m

TEMP=$(dcos marathon task list --json | grep -n "port" | grep -Eo '[0-9]{1,2}')

PORT_LINE=$(($TEMP+1))
ENDPOINT_PORT=$(dcos marathon task list --json | sed "$PORT_LINE,$PORT_LINE!d" | sed 's/ //g')
ENDPOINT_IP=$(dcos service | grep chronos | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)


ssh -T root@$masterip << EOSSH
git clone http://github.com/seoy101/devTest
cd devTest
sed -i "34s/^/curl -L -H 'Content-Type: application\/json' -X POST -d @docker.json $ENDPOINT_IP:$ENDPOINT_PORT/" launch.sh
sed -i "35s/^/curl -L -X PUT $ENDPOINT_IP:$ENDPOINT_PORT/" launch.sh
modprobe nfs
modprobe nfsd
service rpcbind stop
docker build --tag ichthys .
./start.sh
EOSSH

for(( i=3+$masterIpNum; i<$index; i++))
do
ssh root@${array[$i]} "mkdir -p /nfsdir && chmod 777 /nfsdir && yum install -y nfs-utils && mount -t nfs $masterip:/nfsdir /nfsdir && exit"
done

echo "################################"
echo "all finished"
echo "################################"















