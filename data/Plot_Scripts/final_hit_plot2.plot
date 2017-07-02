set terminal png size 600,500 enhanced font "Helvetica,10"
set output "hit_ssd_1.png"
set xlabel "Cache Size(MB)" 
set ylabel "Hit Rate" 
set xtics 256
set yrange[0:100]
set xrange[0:2816]
set key left top
set style line 1 lc rgb '#0000FF' pt 1 ps 1 lt 1 lw 2
set style line 2 lc rgb '#FF0000' pt 6 ps 1 lt 1 lw 2 
plot "mongo_ssd.dat" using 1:6 title "mongo" with linespoints ls 2 , "mysql_ssd.dat" using 1:6 title "mysql" with linespoints ls 1

