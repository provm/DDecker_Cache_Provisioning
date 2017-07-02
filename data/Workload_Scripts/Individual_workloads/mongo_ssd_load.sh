#!/bin/bash
size=$1
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 3 > /proc/sys/vm/drop_caches
echo 0 > /proc/sys/kernel/randomize_va_space

lxc-start -n c1

sleep 5

lxc-start -n client1

sleep 5

for i in 1;
do
   name="c1"
   echo "========== START: Container mongo Memory STATS ==============" > /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
   
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.soft_limit_in_bytes
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.limit_in_bytes
   echo 125 > /sys/fs/cgroup/blkio/lxc/$name/blkio.weight
   cpu=`echo "($i - 1) * 2" | bc`
   echo $cpu >  /sys/fs/cgroup/cpuset/lxc/$name/cpuset.cpus
done

#echo 1100 > /sys/fs/cgroup/memory/lxc/c1/hcache_weight

sleep 1

ssh ubuntu@10.0.3.48 /home/ubuntu/ycsb/bin/ycsb run mongodb -s -P /home/ubuntu/ycsb/workloads/workload1 -p mongodb.url=mongodb://10.0.3.220:27017/ycsb?w=0 -p "maxexecutiontime=600" >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out 2>&1 &

sleep 10

op=`pgrep java`
while [ "$op" != "" ];
do
   sleep 10
   op=`pgrep java` 
done


for i in 1;
do
   name="c1"
   echo "========== STOP: Container mongo Memory STATS ==============" >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
done

echo "Done"

