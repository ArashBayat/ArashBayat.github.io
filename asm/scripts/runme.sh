#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Arguments: OutputPIPE"
	exit
fi

GENOME=$1			# working directory

pilon="java -Xmx60g -jar /home/arash/tools/pilon-1.22.jar"

PROF="/usr/bin/time -v"

ROOT=$(pwd)

THR=16

PEH1=$ROOT/$GENOME/srh1.fq
PEH2=$ROOT/$GENOME/srh2.fq
PEL1=$ROOT/$GENOME/srl1.fq
PEL2=$ROOT/$GENOME/srl2.fq
LRH=$ROOT/$GENOME/lrh.fq
LRL=$ROOT/$GENOME/lrl.fq
REF=$ROOT/$GENOME/ref.fa

function RUN ()
{
time $@ 2>&1 | tee LOGS/$GENOME.$1.log
}

function RemoveIntermediateData ()
{
rm -rf $@
}

function SpadesL()
{
PIPE=SpadesL
rm -rf $GENOME/$PIPE
$PROF spades.py -1 $PEL1 -2 $PEL2 -t $THR -o $GENOME/$PIPE
cp $GENOME/$PIPE/scaffolds.fasta ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function SpadesH()
{
PIPE=SpadesH
rm -rf $GENOME/$PIPE
$PROF spades.py -1 $PEH1 -2 $PEH2 -t $THR -o $GENOME/$PIPE
cp $GENOME/$PIPE/scaffolds.fasta ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function SpadesLRL()
{
PIPE=SpadesLRL
rm -rf $GENOME/$PIPE
$PROF spades.py -1 $PEH1 -2 $PEH2 --pacbio $LRL -t $THR -o $GENOME/$PIPE
cp $GENOME/$PIPE/scaffolds.fasta ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function SoDe2H ()
{
PIPE=SoDe2H
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE
mkdir $GENOME/$PIPE/OUT
echo "max_rd_len=150      " >  $GENOME/$PIPE/run.config
echo "[LIB]               " >> $GENOME/$PIPE/run.config
echo "avg_ins=200         " >> $GENOME/$PIPE/run.config
echo "reverse_seq=0       " >> $GENOME/$PIPE/run.config
echo "asm_flags=3         " >> $GENOME/$PIPE/run.config
echo "rd_len_cutoff=150   " >> $GENOME/$PIPE/run.config
echo "rank=1              " >> $GENOME/$PIPE/run.config
echo "pair_num_cutoff=3   " >> $GENOME/$PIPE/run.config
echo "map_len=50          " >> $GENOME/$PIPE/run.config
echo "q1=$PEH1            " >> $GENOME/$PIPE/run.config
echo "q2=$PEH2            " >> $GENOME/$PIPE/run.config
$PROF soapdenovo2-63mer all -s $GENOME/$PIPE/run.config -p $THR -o $GENOME/$PIPE/OUT/SD
cp $GENOME/$PIPE/OUT/SD.scafSeq ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function SoDe2L ()
{
PIPE=SoDe2L
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE
mkdir $GENOME/$PIPE/OUT
echo "max_rd_len=150      " >  $GENOME/$PIPE/run.config
echo "[LIB]               " >> $GENOME/$PIPE/run.config
echo "avg_ins=200         " >> $GENOME/$PIPE/run.config
echo "reverse_seq=0       " >> $GENOME/$PIPE/run.config
echo "asm_flags=3         " >> $GENOME/$PIPE/run.config
echo "rd_len_cutoff=150   " >> $GENOME/$PIPE/run.config
echo "rank=1              " >> $GENOME/$PIPE/run.config
echo "pair_num_cutoff=3   " >> $GENOME/$PIPE/run.config
echo "map_len=50          " >> $GENOME/$PIPE/run.config
echo "q1=$PEL1            " >> $GENOME/$PIPE/run.config
echo "q2=$PEL2            " >> $GENOME/$PIPE/run.config
$PROF soapdenovo2-63mer all -s $GENOME/$PIPE/run.config -p $THR -o $GENOME/$PIPE/OUT/SD
cp $GENOME/$PIPE/OUT/SD.scafSeq ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function SGAH()
{
PIPE=SGAH
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE
mkdir $GENOME/$PIPE/OUT
cd $GENOME/$PIPE/OUT
$PROF sga-pipe $PEH1 $PEH2 $THR
cd $ROOT
cp $GENOME/$PIPE/OUT/sga-scaffolds.fa ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function SGAL()
{
PIPE=SGAL
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE
mkdir $GENOME/$PIPE/OUT
cd $GENOME/$PIPE/OUT
$PROF sga-pipe $PEL1 $PEL2 $THR
cd $ROOT
cp $GENOME/$PIPE/OUT/sga-scaffolds.fa ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function MiniH ()
{
PIPE=MiniH
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

LR=$LRH
$PROF minimap2 -t $THR -K 10M -x ava-pb $LR $LR > $GENOME/$PIPE/mm2.paf
$PROF miniasm -f $LR $GENOME/$PIPE/mm2.paf | awk '{if($1=="S") print(">"$2"\n"$3)}' > $GENOME/$PIPE/masm.fa
$PROF minimap2 -t $THR -K 10M -x map-pb $GENOME/$PIPE/masm.fa $LR > $GENOME/$PIPE/mm22.paf
$PROF racon -t $THR $LR $GENOME/$PIPE/mm22.paf $GENOME/$PIPE/masm.fa $GENOME/$PIPE/racon.fa

cp $GENOME/$PIPE/racon.fa ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function MiniL ()
{
PIPE=MiniL
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

LR=$LRL
$PROF minimap2 -t $THR -K 10M -x ava-pb $LR $LR > $GENOME/$PIPE/mm2.paf
$PROF miniasm -f $LR $GENOME/$PIPE/mm2.paf | awk '{if($1=="S") print(">"$2"\n"$3)}' > $GENOME/$PIPE/masm.fa
$PROF minimap2 -t $THR -K 10M -x map-pb $GENOME/$PIPE/masm.fa $LR > $GENOME/$PIPE/mm22.paf
$PROF racon -t $THR $LR $GENOME/$PIPE/mm22.paf $GENOME/$PIPE/masm.fa $GENOME/$PIPE/racon.fa

cp $GENOME/$PIPE/racon.fa ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function MiniCH ()
{
PIPE=MiniCH
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

LR=$LRH
$PROF minimap2 -t $THR -K 10M -x ava-pb $LR $LR > $GENOME/$PIPE/mm2.paf
$PROF racon --erc -t $THR $LR $GENOME/$PIPE/mm2.paf $LR $GENOME/$PIPE/lrCorrect.fa
LR2=$GENOME/$PIPE/lrCorrect.fa
head -n 4000 $GENOME/$PIPE/lrCorrect.fa > ASM/$GENOME.$PIPE.cr.fa
$PROF minimap2 -t $THR -K 10M -x ava-pb $LR2 $LR2 > $GENOME/$PIPE/mm2.paf
$PROF miniasm -f $LR2 $GENOME/$PIPE/mm2.paf | awk '{if($1=="S") print(">"$2"\n"$3)}' > $GENOME/$PIPE/masm.fa
$PROF minimap2 -t $THR -K 10M -x map-pb $GENOME/$PIPE/masm.fa $LR > $GENOME/$PIPE/mm22.paf
$PROF racon -t $THR $LR $GENOME/$PIPE/mm22.paf $GENOME/$PIPE/masm.fa $GENOME/$PIPE/racon.fa

cp $GENOME/$PIPE/racon.fa ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE    -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
quast.py -o EVAL/$GENOME.$PIPE.cr -R $REF --threads $THR ASM/$GENOME.$PIPE.cr.fa
}

function MiniCL ()
{
PIPE=MiniCL
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

LR=$LRL
$PROF minimap2 -t $THR -K 10M -x ava-pb $LR $LR > $GENOME/$PIPE/mm2.paf
$PROF racon --erc -t $THR $LR $GENOME/$PIPE/mm2.paf $LR $GENOME/$PIPE/lrCorrect.fa
LR2=$GENOME/$PIPE/lrCorrect.fa
head -n 4000 $GENOME/$PIPE/lrCorrect.fa > ASM/$GENOME.$PIPE.cr.fa
$PROF minimap2 -t $THR -K 10M -x ava-pb $LR2 $LR2 > $GENOME/$PIPE/mm2.paf
$PROF miniasm -f $LR2 $GENOME/$PIPE/mm2.paf | awk '{if($1=="S") print(">"$2"\n"$3)}' > $GENOME/$PIPE/masm.fa
$PROF minimap2 -t $THR -K 10M -x map-pb $GENOME/$PIPE/masm.fa $LR > $GENOME/$PIPE/mm22.paf
$PROF racon -t $THR $LR $GENOME/$PIPE/mm22.paf $GENOME/$PIPE/masm.fa $GENOME/$PIPE/racon.fa

cp $GENOME/$PIPE/racon.fa ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE    -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
quast.py -o EVAL/$GENOME.$PIPE.cr -R $REF --threads $THR ASM/$GENOME.$PIPE.cr.fa
}

function CanuH ()
{
PIPE=CanuH
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

LR=$LRH
GS=$(tail -n +2 $REF | tr -d \\n | wc -c)
date
$PROF canu -p canu -d $GENOME/$PIPE/ genomeSize=$GS -pacbio-raw $LR saveReads=true
ls -l $GENOME/$PIPE/canu.correctedReads.fasta.gz

mv $GENOME/$PIPE/canu.unitigs.fasta ASM/$GENOME.$PIPE.fa
gzip -dc $GENOME/$PIPE/canu.correctedReads.fasta.gz | head -n 4000 > ASM/$GENOME.$PIPE.cr.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE    -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
quast.py -o EVAL/$GENOME.$PIPE.cr -R $REF --threads $THR ASM/$GENOME.$PIPE.cr.fa
}

function CanuL ()
{
PIPE=CanuL
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

LR=$LRL
GS=$(tail -n +2 $REF | tr -d \\n | wc -c)
date
$PROF canu correctedErrorRate=0.1 -p canu -d $GENOME/$PIPE/ genomeSize=$GS -pacbio-raw $LR saveReads=true
ls -l $GENOME/$PIPE/canu.correctedReads.fasta.gz

cp $GENOME/$PIPE/canu.unitigs.fasta ASM/$GENOME.$PIPE.fa
gzip -dc $GENOME/$PIPE/canu.correctedReads.fasta.gz | head -n 4000 > ASM/$GENOME.$PIPE.cr.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE    -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
quast.py -o EVAL/$GENOME.$PIPE.cr -R $REF --threads $THR ASM/$GENOME.$PIPE.cr.fa
}

function Metasm ()
{
PIPE=Metasm
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

echo -e "\
[global]\n\
bowtie2_threads=$THR\n\
bowtie2_read1=$PEH1\n\
bowtie2_read2=$PEH2\n\
bowtie2_maxins=250\n\
bowtie2_minins=150\n\
mateAn_A=250\n\
mateAn_B=150\n\
[1]\n\
fasta=$ROOT/ASM/$GENOME.CanuH.fa\n\
ID=A\n\
[2]\n\
fasta=$ROOT/ASM/$GENOME.SpadesLRL.fa\n\
ID=B\n\
[3]\n\
fasta=$ROOT/ASM/$GENOME.SGAH.fa\n\
ID=C\n\
" > $GENOME/$PIPE/run.config

$PROF metassemble --conf $GENOME/$PIPE/run.config --outd $GENOME/$PIPE
mv $GENOME/$PIPE/Metassembly/QC.B.A/M1/QC.B.A.fasta ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE
quast.py -o EVAL/$GENOME.$PIPE -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
}

function ColorMap ()
{
PIPE=Colormap
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

$PROF fastUtils shuffle -1 $PEH1 -2 $PEH2 -o $GENOME/$PIPE/PEH.fa
PEH="$GENOME/$PIPE/PEH.fa"
$PROF runCorr.sh $LRL $PEH $GENOME/$PIPE NORM $THR
$PROF runOEA.sh $GENOME/$PIPE/NORM_sp.fasta $PEH $GENOME/$PIPE NORM $THR
head -n 4000 $GENOME/$PIPE/NORM_oea.fasta > ASM/$GENOME.$PIPE.cr.fa

LR="$GENOME/$PIPE/NORM_oea.fasta"
GS=$(tail -n +2 $REF | tr -d \\n | wc -c)
$PROF canu -p canu -d $GENOME/$PIPE/ genomeSize=$GS -pacbio-corrected $LR
mv $GENOME/$PIPE/canu.unitigs.fasta ASM/$GENOME.$PIPE.fa
rm -rf $GENOME/$PIPE tmp*
quast.py -o EVAL/$GENOME.$PIPE    -R $REF --threads $THR ASM/$GENOME.$PIPE.fa
quast.py -o EVAL/$GENOME.$PIPE.cr -R $REF --threads $THR ASM/$GENOME.$PIPE.cr.fa
}

function PilonStep ()
{
$PROF bwa index $1
$PROF bwa mem -t $THR $1 $PEH1 $PEH2 | samtools view -Sbu - > $1.bam 
$PROF samtools sort -@$THR -O BAM -o $1.sorted.bam $1.bam 
$PROF samtools index $1.sorted.bam
$PROF $pilon --threads $THR --genome $1 --frags $1.sorted.bam --output $2  > $1.pilon.out
rm $1.*
}

function Pilon ()
{
PIPE=Pilon
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

cp ASM/$GENOME.MiniH.fa $GENOME/$PIPE/MiniH.fa
PilonStep $GENOME/$PIPE/MiniH.fa $GENOME/$PIPE/MiniH.p1
mv $GENOME/$PIPE/MiniH.p1.fasta $GENOME/$PIPE/MiniH.p1.fa
PilonStep $GENOME/$PIPE/MiniH.p1.fa $GENOME/$PIPE/MiniH.p2
mv $GENOME/$PIPE/MiniH.p2.fasta $GENOME/$PIPE/MiniH.p2.fa
PilonStep $GENOME/$PIPE/MiniH.p2.fa $GENOME/$PIPE/MiniH.p3
mv $GENOME/$PIPE/MiniH.p3.fasta $GENOME/$PIPE/MiniH.p3.fa

mv $GENOME/$PIPE/MiniH.p1.fa ASM/$GENOME.MiniH.p1.fa
mv $GENOME/$PIPE/MiniH.p2.fa ASM/$GENOME.MiniH.p2.fa
mv $GENOME/$PIPE/MiniH.p3.fa ASM/$GENOME.MiniH.p3.fa

cp ASM/$GENOME.CanuH.fa $GENOME/$PIPE/CanuH.fa
PilonStep $GENOME/$PIPE/CanuH.fa $GENOME/$PIPE/CanuH.p1
mv $GENOME/$PIPE/CanuH.p1.fasta ASM/$GENOME.CanuH.p1.fa

rm -rf $GENOME/$PIPE

quast.py -o EVAL/$GENOME.MiniH.p1 -R $REF --threads $THR ASM/$GENOME.MiniH.p1.fa
quast.py -o EVAL/$GENOME.MiniH.p2 -R $REF --threads $THR ASM/$GENOME.MiniH.p2.fa
quast.py -o EVAL/$GENOME.MiniH.p3 -R $REF --threads $THR ASM/$GENOME.MiniH.p3.fa
quast.py -o EVAL/$GENOME.CanuH.p1 -R $REF --threads $THR ASM/$GENOME.CanuH.p1.fa
}

function MiniKW ()
{
PIPE=MiniKW
rm -rf $GENOME/$PIPE
mkdir $GENOME/$PIPE

LR=$LRL
$PROF minimap2 -t $THR -K 10M -x ava-pb -k 10 -w 10 $LR $LR | gzip -1 > $GENOME/$PIPE/mm10_10.paf.gz
$PROF minimap2 -t $THR -K 10M -x ava-pb -k 15 -w 10 $LR $LR | gzip -1 > $GENOME/$PIPE/mm15_10.paf.gz
$PROF minimap2 -t $THR -K 10M -x ava-pb -k 20 -w 10 $LR $LR | gzip -1 > $GENOME/$PIPE/mm20_10.paf.gz
$PROF minimap2 -t $THR -K 10M -x ava-pb -k 25 -w 10 $LR $LR | gzip -1 > $GENOME/$PIPE/mm25_10.paf.gz
$PROF minimap2 -t $THR -K 10M -x ava-pb -k 20 -w 20 $LR $LR | gzip -1 > $GENOME/$PIPE/mm20_20.paf.gz
$PROF minimap2 -t $THR -K 10M -x ava-pb -k 20 -w 30 $LR $LR | gzip -1 > $GENOME/$PIPE/mm20_30.paf.gz

echo "Num Overlap"
zcat $GENOME/$PIPE/mm10_10.paf.gz | wc -l
zcat $GENOME/$PIPE/mm15_10.paf.gz | wc -l
zcat $GENOME/$PIPE/mm20_10.paf.gz | wc -l
zcat $GENOME/$PIPE/mm25_10.paf.gz | wc -l
zcat $GENOME/$PIPE/mm20_20.paf.gz | wc -l
zcat $GENOME/$PIPE/mm20_30.paf.gz | wc -l

rm -rf $GENOME/$PIPE
}

set -x

RUN SpadesL
RUN SpadesH
RUN SpadesLRL
RUN SoDe2H
RUN SoDe2L
RUN SGAH
RUN SGAL
RUN MiniH
RUN MiniL
RUN MiniCH
RUN MiniCL
RUN CanuH
RUN CanuL
RUN Pilon
RUN Metasm

# RUN MiniKW
# RUN ColorMap

exit
