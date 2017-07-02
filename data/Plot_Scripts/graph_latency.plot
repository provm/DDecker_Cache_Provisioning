set terminal png size 600,500 enhanced font "Helvetica,10"

set output "redis_mem_lat.png"
set xlabel "Cache Size(MB)" 
set ylabel "Latency(us)" 
set xtics 256
set yrange[0:12000]
set xrange[0:1024]
plot "redis.dat" using 1:7 title "Latency Variation Curve" with lines lw 2 lc 1
