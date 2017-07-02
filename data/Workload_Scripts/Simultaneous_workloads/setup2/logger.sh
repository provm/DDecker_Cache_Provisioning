#if [ "$#" -lt 2 ]; then
#        echo "VM-LOGGER: Enter Test Name !"
#        exit 1
#fi


#echo $1, $2, $3, $4, $5, $6

#dir refers to experiment name 
size=$1

vm="0"
#c_type=$2
#mkdir $exp/$dir/cgroup


#if [ $? -ne 0 ] ; then
#        echo "VM-LOGGER: Logger stats already exist for this test exist"
#        #exit 1
#fi

echo "VM-LOGGER: Started!"

sleep 5

op=`pgrep filebench || pgrep java`
while [ "$op" != "" ];
do
        for i in 1 2 3;
        do
                cont="c$i"

		echo "--------------------MEMCG-----------------------" >>  /root/ddecker/Final_Results/final_log/setup2/${cont}_${1}.out
		echo "MEM ONLY  : $((`cat /sys/fs/cgroup/memory/lxc/$cont/memory.usage_in_bytes`/1048576)) MB" >> /root/ddecker/Final_Results/final_log/setup2/${cont}_${1}.out
		echo "MEM+SWAP  : $((`cat /sys/fs/cgroup/memory/lxc/$cont/memory.memsw.usage_in_bytes`/1048576)) MB" >> /root/ddecker/Final_Results/final_log/setup2/${cont}_${1}.out
		cat /sys/fs/cgroup/memory/lxc/$cont/memory.stat >>  /root/ddecker/Final_Results/final_log/setup2/${cont}_${1}.out              
		echo "--------------------BLKIO-----------------------" >>  /root/ddecker/Final_Results/final_log/setup2/${cont}_${1}.out

		cat /sys/fs/cgroup/blkio/lxc/$cont/blkio.throttle.io_service_bytes >>  /root/ddecker/Final_Results/final_log/setup2/${cont}_${1}.out

				
		echo "--------------------CPUAC-----------------------" >>  /root/ddecker/Final_Results/final_log/setup2/${cont}_${1}.out
		cat /sys/fs/cgroup/cpuacct/lxc/$cont/cpuacct.stat >>  /root/ddecker/Final_Results/final_log/setup2/${cont}_${1}.out
		
	
        done
	sleep 20
	op=`pgrep filebench || pgrep java`
	
done

       for i in 1 2 3;
       do
	 	cont="c$i"
		con=`cat /sys/fs/cgroup/memory/lxc/$cont/hcache_poolid`
		sudo -u root sshpass -p synerg ssh synerg@10.129.28.78 cat /sys/kernel/mm/utmem/0/$con/stats >> /root/ddecker/Final_Results/cache_stats/setup2/${cont}_${1}.out
		sudo -u root sshpass -p synerg ssh synerg@10.129.28.78 cat /sys/kernel/mm/utmem/0/$con/ssd_used >> /root/ddecker/Final_Results/cache_stats/setup2/${cont}_${1}.out	
		sudo -u root sshpass -p synerg ssh synerg@10.129.28.78 cat /sys/kernel/mm/utmem/0/$con/mem_used >> /root/ddecker/Final_Results/cache_stats/setup2/${cont}_${1}.out
      done

echo "VM-LOGGER: Terminated!"
