ndex=0
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

for(( i=3+$masterIpNum; i<$arrlen; i++))
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

for((i=3+$masterIpNum;i<$arrlen; i++))
do
sshpass -p "{$array[1]}" ssh-copy-id -o StrictHostKeyChecking=no root@{$array[$i]}
done

















