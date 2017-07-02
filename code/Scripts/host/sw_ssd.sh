#!/bin/bash
size=$1
#echo 0 > /sys/kernel/mm/utmem/global_limit
echo 0 > /sys/kernel/mm/utmem/0/weight
echo 0 > /sys/kernel/mm/utmem/ssd_limit
echo "$size" > /sys/kernel/mm/utmem/ssd_limit
echo 100 > /sys/kernel/mm/utmem/0/weight
