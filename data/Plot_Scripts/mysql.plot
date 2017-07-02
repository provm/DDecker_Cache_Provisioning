set terminal png size 600,500 enhanced font "Helvetica,10"
set output "mysql.png"
set xlabel "Time(secs)" 
set ylabel "Hit Rate" 
plot "mysql.dat" using 1:2 title "Hit Rate Curve" with lines
