
#!/bin/bash 
size=$1


for i in 1 2 3;
do
   name="c$i"
#   echo 25 > /sys/fs/cgroup/memory/lxc/$name/hcache_weight   #For DDECKER
#   echo 1000 > /sys/fs/cgroup/memory/lxc/$name/hcache_weight #FOR GLOBAL SSD
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.soft_limit_in_bytes
   echo 1000000000 > /sys/fs/cgroup/memory/lxc/$name/memory.limit_in_bytes

   echo 125 > /sys/fs/cgroup/blkio/lxc/$name/blkio.weight
#   cpu=`echo "($i - 1) * 2" | bc`
 #  echo $cpu >  /sys/fs/cgroup/cpuset/lxc/$name/cpuset.cpus

   echo "========== Container $i Memory STATS ==============" > /root/ddecker/Final_Results/app_perf/setup4/${name}_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/Final_Results/app_perf/setup4/${name}_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/Final_Results/app_perf/setup4/${name}_${1}.out
done


sleep 1


ssh ubuntu@10.0.3.49 /home/ubuntu/ycsb/bin/ycsb run mongodb -s -P /home/ubuntu/ycsb/workloads/workload1 -p mongodb.url=mongodb://10.0.3.220:27017/ycsb?w=0 -p "maxexecutiontime=600" >> /root/ddecker/Final_Results/app_perf/setup4/mongo_${1}.out 2>&1 &

ssh ubuntu@10.0.3.47 /home/ubuntu/filebench-1.4.9.1/filebench -f /home/ubuntu/filebench-1.4.9.1/workloads/webserver.f >> /root/ddecker/Final_Results/app_perf/setup4/webserver_${1}.out 2>&1 &

ssh ubuntu@10.0.3.218 /home/ubuntu/ycsb/bin/ycsb run jdbc -cp /usr/share/java/mysql-connector-java.jar -p db.url=jdbc:mysql://10.0.3.36/ycsb -p db.user='root' -p db.password='root'  -P /home/ubuntu/ycsb/workloads/workload1  -p "maxexecutiontime=600" >> /root/ddecker/Final_Results/app_perf/setup4/mysql_${1}.out 2>&1 &



sleep 10

op=`pgrep filebench || pgrep java`
while [ "$op" != "" ];
do
   sleep 10
   
        op=`pgrep filebench || pgrep java`
done


for i in 1 2 3;
do
   name="c$i"
   echo "========== Container $i Memory STATS AT END ==============" >> /root/ddecker/Final_Results/app_perf/setup4/${name}_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/Final_Results/app_perf/setup4/${name}_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/Final_Results/app_perf/setup4/${name}_${1}.out
done

echo "done"
