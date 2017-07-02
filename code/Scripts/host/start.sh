#!/bin/bash	
size=$1
echo 0 > /sys/kernel/mm/ksm/run
insmod cgtmem.ko
sleep 1
virsh start pp1
sleep 5

bash /home/synerg/kanika/helper_scripts/cpu_pinning.sh
bash /home/synerg/kanika/helper_scripts/fix_cpu_freq.sh
