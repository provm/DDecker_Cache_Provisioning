
#!/bin/bash 
size=$1



for i in 1 5 7;
do
   name="c$i"
#   echo 25 > /sys/fs/cgroup/memory/lxc/$name/hcache_weight   #For DDECKER
#   echo 1000 > /sys/fs/cgroup/memory/lxc/$name/hcache_weight #FOR GLOBAL SSD
   #echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.soft_limit_in_bytes
   #echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.limit_in_bytes

   echo 125 > /sys/fs/cgroup/blkio/lxc/$name/blkio.weight
   #cpu=`echo "($i - 1) * 2" | bc`
   #echo $cpu >  /sys/fs/cgroup/cpuset/lxc/$name/cpuset.cpus

   echo "========== Container $i Memory STATS ==============" > /root/ddecker/Final_Results/app_perf/setup3/${name}_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/Final_Results/app_perf/setup3/${name}_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/Final_Results/app_perf/setup3/${name}_${1}.out
done

#echo 48 > /sys/fs/cgroup/memory/lxc/c5/hcache_weight
#echo 52 > /sys/fs/cgroup/memory/lxc/c7/hcache_weight
#echo 27 > /sys/fs/cgroup/memory/lxc/c6/hcache_weight

#echo 1100 > /sys/fs/cgroup/memory/lxc/c1/hcache_weight

#sleep 1


ssh ubuntu@10.0.3.48 /home/ubuntu/ycsb/bin/ycsb run mongodb -s -P /home/ubuntu/ycsb/workloads/workload1 -p mongodb.url=mongodb://10.0.3.144:27017/ycsb?w=0 -p "maxexecutiontime=600" >> /root/ddecker/Final_Results/app_perf/setup3/mongom_${1}.out 2>&1 &

ssh ubuntu@10.0.3.49 /home/ubuntu/ycsb/bin/ycsb run mongodb -s -P /home/ubuntu/ycsb/workloads/workload1 -p mongodb.url=mongodb://10.0.3.220:27017/ycsb?w=0 -p "maxexecutiontime=600" >> /root/ddecker/Final_Results/app_perf/setup3/mongol_${1}.out 2>&1 &

ssh ubuntu@10.0.3.176 /home/ubuntu/ycsb/bin/ycsb run mongodb -s -P /home/ubuntu/ycsb/workloads/workload1 -p mongodb.url=mongodb://10.0.3.221:27017/ycsb?w=0 -p "maxexecutiontime=600" >> /root/ddecker/Final_Results/app_perf/setup3/mongoh_${1}.out 2>&1 &


sleep 10

op=`pgrep filebench || pgrep java`
while [ "$op" != "" ];
do
   sleep 10
   
        op=`pgrep filebench || pgrep java`
done


for i in 1 5 7;
do
   name="c$i"
   echo "========== Container $i Memory STATS AT END ==============" >> /root/ddecker/Final_Results/app_perf/setup3/${name}_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/Final_Results/app_perf/setup3/${name}_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/Final_Results/app_perf/setup3/${name}_${1}.out
done

echo "done"
