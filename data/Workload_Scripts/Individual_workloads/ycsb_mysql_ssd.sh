#!/bin/bash
size=$1
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 3 > /proc/sys/vm/drop_caches
echo 0 > /proc/sys/kernel/randomize_va_space

lxc-start -n mysql

sleep 5

lxc-start -n client4

sleep 5

for i in 1;
do
   name="mysql"
   echo "========== START: Container mysql Memory STATS ==============" > /root/ddecker/SSD_Cache/mysql/mysql_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/SSD_Cache/mysql/mysql_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/SSD_Cache/mysql/mysql_${1}.out
   
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.soft_limit_in_bytes
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.limit_in_bytes
#   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.memsw.limit_in_bytes
  
   echo 125 > /sys/fs/cgroup/blkio/lxc/$name/blkio.weight
   cpu=`echo "($i - 1) * 2" | bc`
   echo $cpu >  /sys/fs/cgroup/cpuset/lxc/$name/cpuset.cpus
done

echo 1100 > /sys/fs/cgroup/memory/lxc/mysql/hcache_weight

sleep 1

ssh ubuntu@10.0.3.217 /home/ubuntu/ycsb/bin/ycsb run jdbc -cp /usr/share/java/mysql-connector-java.jar -p db.url=jdbc:mysql://10.0.3.35/ycsb -p db.user='root' -p db.password='root'  -P /home/ubuntu/ycsb/workloads/workload1  -p "maxexecutiontime=1200" >> /root/ddecker/SSD_Cache/mysql/mysql_${1}.out 2>&1 &

sleep 10

op=`pgrep java`
while [ "$op" != "" ];
do
   sleep 10
   op=`pgrep java` 
done


for i in 1;
do
   name="mysql"
   echo "========== STOP: Container mysql Memory STATS ==============" >> /root/ddecker/SSD_Cache/mysql/mysql_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/SSD_Cache/mysql/mysql_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/SSD_Cache/mysql/mysql_${1}.out
done

echo "Done"

