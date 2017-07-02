set terminal png size 600,500 enhanced font "Helvetica,10"

set output "webproxy_mem.png"
set xlabel "Cache Size(MB)" 
set ylabel "Throughput(mb/sec)" 
set xtics 256
set xrange[0:3072]
plot "webproxy_memory.dat" using 1:9 title "Throughput Variation Curve" with lines lw 2 lc 1
