set terminal png size 600,500 enhanced font "Helvetica,10"
set output "webserver_ssd.png"
set xlabel "Time(secs)" 
set ylabel "Hit Rate" 
plot "webserver.dat" using 1:2 title "Hit Rate Curve" with lines
