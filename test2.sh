#!/bin/bash

index=0
echo -n "input network interface: "
read interfaceVar
array[$index]=$interfaceVar
((index+=1))

echo -n "input master ip:"
read masterip
array[$index]=$masterip
((index+=1))

echo -n "input each password:"
read password
array[$index]=$password
((index+=1))


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

for(( i=3; i<$arrlen; i++)) 
do
 echo ${array[$i]}
done

yum -y update
yum install -y vim
yum install -y net-tools
yum install -y wget

echo -e "\n" | ssh-keygen -t rsa -N ""
wget http://apt.sw.be/redhat/el7/en/x86_64/rpmforge/RPMS/sshpass-1.05-1.el7.rf.x86_64.rpm

rpm -Uvh sshpass-1.05-1.el7.rf.x86_64.rpm

echo hihi
echo "hihi"


echo "---" >> aa.yaml

for(( i=3; i<$arrlen; i++))
do
echo "- ${array[$i]}" >> aa.yaml
done

cat >> aa.yaml << "EOF"
bootstrap_url: 'file:///opt/dcos_install_tmp'
cluster_name: dcos
exhibitor_storage_backend: static
master_discovery: static
master_list:
EOF

echo "- ${array[1]}" >> aa.yaml

cat >> aa.yaml << "EOF"
resolvers:
- 8.8.4.4
- 8.8.8.8
ssh_key_path: /genconf/ssh_key
ssh_port: 22
ssh_user: root
oauth_enabled: 'false'
EOF

echo "#!/bin/bash" >> ip-detect
echo "set -o nounset -o errexit" >> ip-detect
echo "export PATH=/usr/sbin:/usr/bin:\$PATH" >> ip-detect
echo "echo \$(ip addr show ${array[0]} | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)" >> ip-detect






