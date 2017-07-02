#if [ "$#" -lt 2 ]; then
#        echo "VM-LOGGER: Enter Test Name !"
#        exit 1
#fi


#echo $1, $2, $3, $4, $5, $6

#dir refers to experiment name 
size=$1

vm="0"
c_type=$2
cont="c2"
con=`cat /sys/fs/cgroup/memory/lxc/$cont/hcache_poolid`
#mkdir $exp/$dir/cgroup


#if [ $? -ne 0 ] ; then
#        echo "VM-LOGGER: Logger stats already exist for this test exist"
#        #exit 1
#fi

echo "VM-LOGGER: Started!"

sleep 5

op=`pgrep filebench`
while [ "$op" != "" ];
do
        for i in 1;
        do
                cont="c2"

		#date >> root/ddecker/${2}_Cache/mysql/log/log_${1}.out
		echo "--------------------MEMCG-----------------------" >>   /root/ddecker/${2}_Cache/webserver/log/log_${1}.out
		echo "MEM ONLY  : $((`cat /sys/fs/cgroup/memory/lxc/$cont/memory.usage_in_bytes`/1048576)) MB" >>  /root/ddecker/${2}_Cache/webserver/log/log_${1}.out
		echo "MEM+SWAP  : $((`cat /sys/fs/cgroup/memory/lxc/$cont/memory.memsw.usage_in_bytes`/1048576)) MB" >> /root/ddecker/${2}_Cache/webserver/log/log_${1}.out
		cat /sys/fs/cgroup/memory/lxc/$cont/memory.stat >> /root/ddecker/${2}_Cache/webserver/log/log_${1}.out                
		echo "--------------------BLKIO-----------------------" >> /root/ddecker/${2}_Cache/webserver/log/log_${1}.out
		cat /sys/fs/cgroup/blkio/lxc/$cont/blkio.throttle.io_service_bytes >>  /root/ddecker/${2}_Cache/webserver/log/log_${1}.out				
		echo "--------------------CPUAC-----------------------" >> /root/ddecker/${2}_Cache/webserver/log/log_${1}.out
		cat /sys/fs/cgroup/cpuacct/lxc/$cont/cpuacct.stat >>  /root/ddecker/${2}_Cache/webserver/log/log_${1}.out

		echo " " >>  /root/ddecker/${2}_Cache/webserver/log/log_${1}.out

        done
	
	sudo -u root sshpass -p synerg ssh synerg@10.129.28.78 cat /sys/kernel/mm/utmem/0/$con/stats >> /root/ddecker/${2}_Cache/webserver/log/cache_stats/log_${1}.out
	sleep 10
        op=`pgrep filebench`
done

echo "VM-LOGGER: Terminated!"
