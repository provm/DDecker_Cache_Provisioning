set terminal png size 600,500 enhanced font "Helvetica,10"
set output "redis_mem_hit.png"
set xlabel "Cache Size(MB)" 
set ylabel "Hit Rate" 
set xtics 256
set yrange[0:100]
set xrange[0:1024]
set key left top
plot "redis.dat" using 1:5 with lines lw 2 lc 1 title "Hit Rate Curve"
