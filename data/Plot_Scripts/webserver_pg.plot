set terminal png size 600,500 enhanced font "Helvetica,10"
set output "webserver_pg.png"
set xlabel "Time(secs)" 
set ylabel "Cache Operations" 
set yrange[0:10000000]
plot "webserver_g.dat" using 1:2 title "Gets" with lines, "webserver_p.dat" using 1:2 title "Puts" with lines,"webserver_sg.dat" using 1:2 title "Sgets"
