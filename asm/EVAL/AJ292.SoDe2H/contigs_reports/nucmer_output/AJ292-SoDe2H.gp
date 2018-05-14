set terminal canvas jsdir ""
set output "/home/arash/asmReview/EVAL/AJ292.SoDe2H/contigs_reports/nucmer_output/AJ292-SoDe2H.html"
set ytics ( \
 "0" 0, \
 "200000" 200000, \
 "400000" 400000, \
 "600000" 600000, \
 "800000" 800000, \
 "1000000" 1000000, \
 "1200000" 1200000, \
 "1400000" 1400000, \
 "1600000" 1600000, \
 "" 1744167 \
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
set yrange [1:1744167]
set linestyle 1  lt 1 lc rgb "red" lw 3 pt 7 ps 0.5
set linestyle 2  lt 3 lc rgb "blue" lw 3 pt 7 ps 0.5
set linestyle 3  lt 2 lc rgb "yellow" lw 3 pt 7 ps 0.5
plot \
 "/home/arash/asmReview/EVAL/AJ292.SoDe2H/contigs_reports/nucmer_output/AJ292-SoDe2H.fplot" title "FWD" w lp ls 1, \
 "/home/arash/asmReview/EVAL/AJ292.SoDe2H/contigs_reports/nucmer_output/AJ292-SoDe2H.rplot" title "REV" w lp ls 2
