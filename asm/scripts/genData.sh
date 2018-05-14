#!/bin/bash

function SIM ()
{
source activate simlord &> temp.txt
simlord -rr $1/ref.fa -c 40 --no-sam $1/lrh
simlord -rr $1/ref.fa -c 20 --no-sam $1/lrl
mv $1/lrh.fastq $1/lrh.fq
mv $1/lrl.fastq $1/lrl.fq
source deactivate &> temp.txt
rm temp.txt
art_illumina -ss HS25 -na -i $1/ref.fa -p -l 150 -f 40 -m 200 -s 10 -o $1/srh
art_illumina -ss HS25 -na -i $1/ref.fa -p -l 150 -f 20 -m 200 -s 10 -o $1/srl
}

SIM $1

exit
