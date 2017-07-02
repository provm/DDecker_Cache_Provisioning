set terminal png size 600,500 enhanced font "Helvetica,10"

set output "throughput_mem.png"
set xlabel "Cache Size(MB)" 
set ylabel "Throughput(ops/sec)" 
set xtics 256
set yrange[0:]
set xrange[0:3072]
plot "webserver_memory_new.dat" using 1:9 title "webserver" with lines lc rgb '#8b1a0e' pt 1 ps 1 lt 1 lw 2, \
     "webproxy_memory.dat"  using 1:9 title "webproxy" with lines lc rgb '#0000FF' pt 1 ps 1 lt 1 lw 2, \
    
