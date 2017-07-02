#!/bin/bash
size=$1
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 3 > /proc/sys/vm/drop_caches
echo 0 > /proc/sys/kernel/randomize_va_space

lxc-start -n c3

sleep 5

lxc-start -n client3

sleep 5

for i in 1;
do
   name="c3"
   echo "========== START: Container mongo Memory STATS ==============" > /root/ddecker/Memory_Cache/redis/redis_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/Memory_Cache/redis/redis_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/Memory_Cache/redis/redis_${1}.out
   
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.soft_limit_in_bytes
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.limit_in_bytes
   echo 125 > /sys/fs/cgroup/blkio/lxc/$name/blkio.weight
   cpu=`echo "($i - 1) * 2" | bc`
   echo $cpu >  /sys/fs/cgroup/cpuset/lxc/$name/cpuset.cpus
done

echo 100 > /sys/fs/cgroup/memory/lxc/c3/hcache_weight

sleep 1

ssh ubuntu@10.0.3.25 /home/ubuntu/ycsb/bin/ycsb run redis -s -P /home/ubuntu/ycsb/workloads/workload1 -p "redis.host=10.0.3.168" -p "redis.port=6379" -p "operationcount=100000000" -p "maxexecutiontime=600">> /root/ddecker/Memory_Cache/redis/redis_${1}.out 2>&1 &

sleep 10

op=`pgrep java`
while [ "$op" != "" ];
do
   sleep 10
   op=`pgrep java` 
done


for i in 1;
do
   name="c3"
   echo "========== STOP: Container mongo Memory STATS ==============" >> /root/ddecker/Memory_Cache/redis/redis_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/Memory_Cache/redis/redis_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/Memory_Cache/redis/redis_${1}.out
done

echo "Done"

