set terminal canvas jsdir ""
set output "/home/arash/asmReview/EVAL/sim5M.MiniH.p3/contigs_reports/nucmer_output/sim5M-MiniH-p3.html"
set ytics ( \
 "0" 0, \
 "600000" 600000, \
 "1200000" 1200000, \
 "1800000" 1800000, \
 "2400000" 2400000, \
 "3000000" 3000000, \
 "3600000" 3600000, \
 "4200000" 4200000, \
 "4800000" 4800000, \
 "" 4983308 \
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
set yrange [1:4983308]
set linestyle 1  lt 1 lc rgb "red" lw 3 pt 7 ps 0.5
set linestyle 2  lt 3 lc rgb "blue" lw 3 pt 7 ps 0.5
set linestyle 3  lt 2 lc rgb "yellow" lw 3 pt 7 ps 0.5
plot \
 "/home/arash/asmReview/EVAL/sim5M.MiniH.p3/contigs_reports/nucmer_output/sim5M-MiniH-p3.fplot" title "FWD" w lp ls 1, \
 "/home/arash/asmReview/EVAL/sim5M.MiniH.p3/contigs_reports/nucmer_output/sim5M-MiniH-p3.rplot" title "REV" w lp ls 2
