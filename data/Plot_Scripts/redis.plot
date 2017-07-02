set terminal png size 600,500 enhanced font "Helvetica,10"
set output "redis.png"
set style fill solid 1.0 noborder
set xlabel "Time(secs)" 
set ylabel "Hit Rate" 
set yrange[0:1]
plot "redis.dat" using 1:2 title "Hit Rate Curve" with lines
