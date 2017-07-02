set terminal png size 600,500 enhanced font "Helvetica,10"

set output "throughput_ssd.png"
set xlabel "Cache Size(MB)" 
set ylabel "Throughput(mbps)" 
set xtics 256

set yrange[0:100]
set xrange[0:2304]
set style line 1 lc rgb '#0000FF' pt 1 ps 1 lt 1 lw 2
set style line 2 lc rgb '#FF0000' pt 6 ps 1 lt 1 lw 2 
plot "webserver_ssd_new.dat" using 1:9 title "webserver" with linespoints ls 2 , "webproxy_SSD.dat" using 1:9 title "webproxy" with linespoints ls 1


    
