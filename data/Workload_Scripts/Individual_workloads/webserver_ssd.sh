#!/bin/bash
size=$1 
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 3 > /proc/sys/vm/drop_caches
echo 0 > /proc/sys/kernel/randomize_va_space


lxc-start -n c2
sleep 3

for i in 1;
do
   name="c2"
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.soft_limit_in_bytes
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.limit_in_bytes
   #echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.memsw.limit_in_bytes
   echo 125 > /sys/fs/cgroup/blkio/lxc/$name/blkio.weight
   cpu=`echo "(1 - $i) * 2" | bc`
   echo $cpu >  /sys/fs/cgroup/cpuset/lxc/$name/cpuset.cpus

   echo "========== Container c2 Memory STATS ==============" > /root/ddecker/SSD_Cache/webserver/webserver_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/SSD_Cache/webserver/webserver_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/SSD_Cache/webserver/webserver_${1}.out
done
echo 1100 > /sys/fs/cgroup/memory/lxc/c2/hcache_weight


sleep 1


ssh ubuntu@10.0.3.47 /home/ubuntu/filebench-1.4.9.1/filebench -f /home/ubuntu/filebench-1.4.9.1/workloads/webserver.f >> /root/ddecker/SSD_Cache/webserver/webserver_${1}.out 2>&1 &

sleep 10

op=`pgrep filebench`
while [ "$op" != "" ];
do
   sleep 10
   op=`pgrep filebench`
done



name="c2"
echo "========== Container c2 Memory STATS AT END ==============" >> /root/ddecker/SSD_Cache/webserver/webserver_${1}.out
cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/SSD_Cache/webserver/webserver_${1}.out
echo "======== END Container STATS ======" >> /root/ddecker/SSD_Cache/webserver/webserver_${1}.out
echo "done"

scp /root/ddecker/SSD_Cache/webserver/webserver_${1}.out kanika@10.129.26.66:/home/kanika/experiments/SSD_Cache/webserver
sleep 3
