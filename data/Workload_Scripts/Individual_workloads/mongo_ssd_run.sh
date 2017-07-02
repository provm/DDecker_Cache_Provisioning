#if [ "$#" -lt 1 ]; then
 # echo "ERROR: Enter Test Name !"
 # exit 1
#fi
size=$1

for i in 1;
do
   name="c1"
   echo "========== START: Container $i Memory STATS ==============" > /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
done


sleep 1
echo 1100 > /sys/fs/cgroup/memory/lxc/c1/hcache_weight

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
   echo "========== STOP: Container $i Memory STATS ==============" >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
   cat /sys/fs/cgroup/memory/lxc/$name/memory.stat >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
   echo "======== END Container STATS ======" >> /root/ddecker/SSD_Cache/mongo/mongo_${1}.out
done

echo "Done"
