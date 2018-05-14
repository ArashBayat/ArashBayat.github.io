set terminal canvas jsdir ""
set output "/home/arash/asmReview/EVAL/AJ292.SGAH/contigs_reports/nucmer_output/AJ292-SGAH.html"
set ytics ( \
 "0" 0, \
 "700000" 700000, \
 "1400000" 1400000, \
 "2100000" 2100000, \
 "2800000" 2800000, \
 "3500000" 3500000, \
 "4200000" 4200000, \
 "4900000" 4900000, \
 "" 5453167 \
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
set yrange [1:5453167]
set linestyle 1  lt 1 lc rgb "red" lw 3 pt 7 ps 0.5
set linestyle 2  lt 3 lc rgb "blue" lw 3 pt 7 ps 0.5
set linestyle 3  lt 2 lc rgb "yellow" lw 3 pt 7 ps 0.5
plot \
 "/home/arash/asmReview/EVAL/AJ292.SGAH/contigs_reports/nucmer_output/AJ292-SGAH.fplot" title "FWD" w lp ls 1, \
 "/home/arash/asmReview/EVAL/AJ292.SGAH/contigs_reports/nucmer_output/AJ292-SGAH.rplot" title "REV" w lp ls 2
