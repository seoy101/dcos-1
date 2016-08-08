#!/bin/bash

index=0
echo -n "input network interface: "
read interfaceVar
array[$index]=$interfaceVar
((index+=1))

echo $index
echo ${array[0]}

echo -n "input master ip:"
read masterip
array[$index]=masterip
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

echo ${array[@]}

arrlen=${#array[@]}
echo "$arrlen"

for(( i=2; i<$arrlen; i++)) 
do
 echo ${array[$i]}
done
