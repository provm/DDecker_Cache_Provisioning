set terminal png size 600,500 enhanced font "Helvetica,10"
set output "mongo.png"
set xlabel "Time(secs)" 
set ylabel "Hit Rate" 
set yrange[0:1]
plot "mongo.dat" using 1:2 title "Hit Rate Curve" with lines
