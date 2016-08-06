#!/bin/bash

yum -y update
yum install -y vim
yum install -y net-tools
yum install -y wget


echo -e "\n" | ssh-keygen -t rsa -N ""

wget http://apt.sw.be/redhat/el7/en/x86_64/rpmforge/RPMS/sshpass-1.05-1.el7.rf.x86_64.rpm

rpm -Uvh sshpass-1.05-1.el7.rf.x86_64.rpm

sshpass -p "rkaalswo123" ssh-copy-id -o StrictHostKeyChecking=no root@39.117.232.201

sshpass -p "rkaalswo123" ssh-copy-id -o StrictHostKeyChecking=no root@123.111.148.151



cat > /etc/yum.repos.d/docker.repo << '__EOF__'

[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
__EOF__

cat > /etc/modules-load.d/overlay.conf << '__EOF__'
overlay
__EOF__

yum install -y docker-engine-1.11.2
sed -i '12s/$/ --storage-driver=overlay/' /lib/systemd/system/docker.service

yum install -y yum-versionlock
yum versionlock docker-engine

yum clean all

systemctl daemon-reload
systemctl start docker
systemctl enable docker
yum -y update

yum install -y tar xz unzip curl ipset nfs-utils
yum clean all

groupadd nogroup
yum -y update



yum install -y ntp

sed -i '21,24d' /etc/ntp.conf

sed -i '21s/$/server 0.kr.pool.ntp.org\n/' /etc/ntp.conf
sed -i '22s/$/server 1.asia.pool.ntp.org\n/' /etc/ntp.conf
sed -i '23s/$/server 3.asia.pool.ntp.org\n/' /etc/ntp.conf

systemctl start ntpd
systemctl enable ntpd


mkdir /dcos
chmod 777 /dcos
cd /dcos
mkdir -p genconf
curl -O https://downloads.dcos.io/dcos/EarlyAccess/commit/14509fe1e7899f439527fb39867194c7a425c771/dcos_generate_config.sh

cp /root/.ssh/id_rsa /dcos/genconf/ssh_key && chmod 0600 /dcos/genconf/ssh_key

cat > /dcos/genconf/config.yaml << '__EOF__'
---
agent_list:
- agent ip
bootstrap_url: 'file:///opt/dcos_install_tmp'
cluster_name: dcos
exhibitor_storage_backend: static
master_discovery: static
master_list:
- ip
resolvers:
- 8.8.4.4
- 8.8.8.8
ssh_key_path: /genconf/ssh_key
ssh_port: 22
ssh_user: root
__EOF__

cat > /dcos/genconf/ip-detect << '__EOF__'

#!/bin/bash
set -o nounset -o errexit
export PATH=/usr/sbin:/usr/bin:$PATH
echo $(ip addr show enp0s3 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
__EOF__



#bash dcos_generate_config.sh --genconf
#bash dcos_generate_config.sh --install-prereqs
#bash dcos_generate_config.sh --preflight
#bash dcos_generate_config.sh --deploy
#bash dcos_generate_config.sh --postflight








