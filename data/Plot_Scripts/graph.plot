set terminal png size 600,500 enhanced font "Helvetica,10"

set output "redis_mem.png"
set xlabel "Cache Size(MB)" 
set ylabel "Throughput(ops/sec)" 
set xtics 256
set yrange[0:120]
set xrange[0:1024]
plot "redis.dat" using 1:8 title "Throughput Variation Curve" with lines lw 2 lc 1
