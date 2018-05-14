set terminal canvas jsdir ""
set output "/home/arash/asmReview/EVAL/sim25M.SGAL/contigs_reports/nucmer_output/sim25M-SGAL.html"
set ytics ( \
 "0" 0, \
 "3000000" 3000000, \
 "6000000" 6000000, \
 "9000000" 9000000, \
 "12000000" 12000000, \
 "15000000" 15000000, \
 "18000000" 18000000, \
 "21000000" 21000000, \
 "" 23298318 \
)
set size 1,1
set grid
set key outside bottom right
set border 0
set tics scale 0
set xlabel "Reference" noenhanced
set ylabel "Assembly" noenhanced
set format "%.0f"
set xrange [1:*]
set yrange [1:23298318]
set linestyle 1  lt 1 lc rgb "red" lw 3 pt 7 ps 0.5
set linestyle 2  lt 3 lc rgb "blue" lw 3 pt 7 ps 0.5
set linestyle 3  lt 2 lc rgb "yellow" lw 3 pt 7 ps 0.5
plot \
 "/home/arash/asmReview/EVAL/sim25M.SGAL/contigs_reports/nucmer_output/sim25M-SGAL.fplot" title "FWD" w lp ls 1, \
 "/home/arash/asmReview/EVAL/sim25M.SGAL/contigs_reports/nucmer_output/sim25M-SGAL.rplot" title "REV" w lp ls 2
