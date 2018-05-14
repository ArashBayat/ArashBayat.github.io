#!/bin/bash


GENOME=$1  # AJ055

#all
LIST="EVAL/$GENOME.CanuH/report.tsv	EVAL/$GENOME.CanuL/report.tsv	EVAL/$GENOME.MiniCH/report.tsv	EVAL/$GENOME.MiniCL/report.tsv	EVAL/$GENOME.MiniH/report.tsv	EVAL/$GENOME.MiniL/report.tsv	EVAL/$GENOME.SGAH/report.tsv	EVAL/$GENOME.SGAL/report.tsv	EVAL/$GENOME.SoDe2H/report.tsv	EVAL/$GENOME.SoDe2L/report.tsv	EVAL/$GENOME.SpadesH/report.tsv	EVAL/$GENOME.SpadesL/report.tsv	EVAL/$GENOME.SpadesLRL/report.tsv	EVAL/$GENOME.Colormap/report.tsv	EVAL/$GENOME.CanuH.p1/report.tsv	EVAL/$GENOME.MiniH.p1/report.tsv	EVAL/$GENOME.MiniH.p2/report.tsv	EVAL/$GENOME.MiniH.p3/report.tsv	EVAL/$GENOME.Metasm/report.tsv	EVAL/$GENOME.CanuH.cr/report.tsv	EVAL/$GENOME.CanuL.cr/report.tsv	EVAL/$GENOME.MiniCH.cr/report.tsv	EVAL/$GENOME.MiniCL.cr/report.tsv	EVAL/$GENOME.Colormap.cr/report.tsv"
LIST2="EVAL/$GENOME.CanuH/report.tsv.fix	EVAL/$GENOME.CanuL/report.tsv.fix	EVAL/$GENOME.MiniCH/report.tsv.fix	EVAL/$GENOME.MiniCL/report.tsv.fix	EVAL/$GENOME.MiniH/report.tsv.fix	EVAL/$GENOME.MiniL/report.tsv.fix	EVAL/$GENOME.SGAH/report.tsv.fix	EVAL/$GENOME.SGAL/report.tsv.fix	EVAL/$GENOME.SoDe2H/report.tsv.fix	EVAL/$GENOME.SoDe2L/report.tsv.fix	EVAL/$GENOME.SpadesH/report.tsv.fix	EVAL/$GENOME.SpadesL/report.tsv.fix	EVAL/$GENOME.SpadesLRL/report.tsv.fix	EVAL/$GENOME.Colormap/report.tsv.fix	EVAL/$GENOME.CanuH.p1/report.tsv.fix	EVAL/$GENOME.MiniH.p1/report.tsv.fix	EVAL/$GENOME.MiniH.p2/report.tsv.fix	EVAL/$GENOME.MiniH.p3/report.tsv.fix	EVAL/$GENOME.Metasm/report.tsv.fix	EVAL/$GENOME.CanuH.cr/report.tsv.fix	EVAL/$GENOME.CanuL.cr/report.tsv.fix	EVAL/$GENOME.MiniCH.cr/report.tsv.fix	EVAL/$GENOME.MiniCL.cr/report.tsv.fix	EVAL/$GENOME.Colormap.cr/report.tsv.fix"

#only genome assembly
#LIST="EVAL/$GENOME.CanuH/report.tsv EVAL/$GENOME.CanuL/report.tsv EVAL/$GENOME.MiniCH/report.tsv EVAL/$GENOME.MiniCL/report.tsv EVAL/$GENOME.MiniH/report.tsv EVAL/$GENOME.MiniL/report.tsv EVAL/$GENOME.SGAH/report.tsv EVAL/$GENOME.SGAL/report.tsv EVAL/$GENOME.SoDe2H/report.tsv EVAL/$GENOME.SoDe2L/report.tsv EVAL/$GENOME.SpadesH/report.tsv EVAL/$GENOME.SpadesL/report.tsv EVAL/$GENOME.SpadesLRL/report.tsv EVAL/$GENOME.Colormap/report.tsv EVAL/$GENOME.CanuH.p1/report.tsv EVAL/$GENOME.MiniH.p1/report.tsv EVAL/$GENOME.MiniH.p2/report.tsv EVAL/$GENOME.MiniH.p3/report.tsv EVAL/$GENOME.Metasm/report.tsv"
#LIST2="EVAL/$GENOME.CanuH/report.tsv.fix EVAL/$GENOME.CanuL/report.tsv.fix EVAL/$GENOME.MiniCH/report.tsv.fix EVAL/$GENOME.MiniCL/report.tsv.fix EVAL/$GENOME.MiniH/report.tsv.fix EVAL/$GENOME.MiniL/report.tsv.fix EVAL/$GENOME.SGAH/report.tsv.fix EVAL/$GENOME.SGAL/report.tsv.fix EVAL/$GENOME.SoDe2H/report.tsv.fix EVAL/$GENOME.SoDe2L/report.tsv.fix EVAL/$GENOME.SpadesH/report.tsv.fix EVAL/$GENOME.SpadesL/report.tsv.fix EVAL/$GENOME.SpadesLRL/report.tsv.fix EVAL/$GENOME.Colormap/report.tsv.fix EVAL/$GENOME.CanuH.p1/report.tsv.fix EVAL/$GENOME.MiniH.p1/report.tsv.fix EVAL/$GENOME.MiniH.p2/report.tsv.fix EVAL/$GENOME.MiniH.p3/report.tsv.fix EVAL/$GENOME.Metasm/report.tsv.fix"

#only long read correction
#LIST="EVAL/$GENOME.CanuH.cr/report.tsv	EVAL/$GENOME.CanuL.cr/report.tsv	EVAL/$GENOME.MiniCH.cr/report.tsv	EVAL/$GENOME.MiniCL.cr/report.tsv	EVAL/$GENOME.Colormap.cr/report.tsv"
#LIST2="EVAL/$GENOME.CanuH.cr/report.tsv.fix	EVAL/$GENOME.CanuL.cr/report.tsv.fix	EVAL/$GENOME.MiniCH.cr/report.tsv.fix	EVAL/$GENOME.MiniCL.cr/report.tsv.fix	EVAL/$GENOME.Colormap.cr/report.tsv.fix"


for element in $LIST
do 
    test -e $element && LISTX=$LISTX" "$element; 
    
done;



for var in $LISTX
do
    echo "$var"
    tr ' ' '_' < "$var" > "$var".fix
    sed "s/#/No_of/g" "$var".fix > "$var".fix2
    ( grep -w '^Assembly' "$var".fix2 ;grep -w '^Genome_fraction_(%)' "$var".fix2 ;grep -w '^Duplication_ratio' "$var".fix2 ;grep -w '^Largest_alignment' "$var".fix2 ;grep -w '^Total_aligned_length' "$var".fix2 ;grep -w '^NG50' "$var".fix2 ;grep -w '^NG75' "$var".fix2 ;grep -w '^NA50' "$var".fix2 ;grep -w '^NA75' "$var".fix2 ;grep -w '^NGA50' "$var".fix2 ;grep -w '^NGA75' "$var".fix2 ;grep -w '^LG50' "$var".fix2 ;grep -w '^LG75' "$var".fix2 ;grep -w '^LA50' "$var".fix2 ;grep -w '^LA75' "$var".fix2 ;grep -w '^LGA50' "$var".fix2 ;grep -w '^LGA75' "$var".fix2 ;grep -w '^No_of_local_misassemblies' "$var".fix2 ;grep -w '^No_of_unaligned_mis._contigs' "$var".fix2 ;grep -w '^No_of_mismatches_per_100_kbp' "$var".fix2 ;grep -w '^No_of_indels_per_100_kbp' "$var".fix2 ;grep -w '^No_of_N' "$var".fix2 ;grep -w '^No_of_contigs' "$var".fix2 ;grep -w '^Largest_contig' "$var".fix2 ;grep -w '^Total_length' "$var".fix2 ;grep -w '^N50' "$var".fix2 ;grep -w '^N75' "$var".fix2 ;grep -w '^L50' "$var".fix2 ;grep -w '^L75' "$var".fix2 ;grep -w '^GC_(%)' "$var".fix2 ) > "$var".fix
    
done

for element in $LIST2
do 
    test -e $element && LIST2X=$LIST2X" "$element; 
done;


./join.pl -k -e -v $LIST2X | sed 's/-v/NA/g'| tee report.$GENOME.NA.tsv | sed 's/NA/0/g' > report.$GENOME.0.tsv


grep '(wall' LOGS/$GENOME.* > all.$GENOME.time
cat all.$GENOME.time | cut -d ' ' -f 8 | tr ':' \\t | awk '{if(NF==1) print; else{ if(NF==2) print(($1*60)+$2); else print(($1*3600)+($2*60)+$3)}}' | paste all.$GENOME.time - | awk 'BEGIN{last=0} {if($1==last) {printf "%s ",$NF} else{ if(NR>1) {print "";}; printf "%s %s ",$1,$NF; }; last=$1;} END{print "";}' > all.$GENOME.timex
#cat all.$GENOME.timex

grep 'Maximum res' LOGS/$GENOME.* | awk 'BEGIN{last=0} {if($1==last) {printf "%s ",$NF} else{ if(NR>1) {print "";}; printf "%s %s ",$1,$NF; }; last=$1;} END{print "";}' > all.$GENOME.mem
