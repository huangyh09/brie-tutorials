#!/bin/bash

### Notes for data set
## paper: Disease-specific oligodendrocyte lineage cells arise in multiple sclerosis
## https://www.nature.com/articles/s41591-018-0236-y
## full data set: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE113973
## meta (export): https://www.ncbi.nlm.nih.gov/geo/browse/?view=samples&series=113973
## RunInfo (Metadata): https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP144462


DATA_DIR=./data/
cd $DATA_DIR

### Download data
SRA=/storage/yhhuang/tools/sratoolkit.2.10.2-ubuntu64/bin

samp_file=$DATA_DIR/GSE113973_SraRun.csv

while IFS=$',' read -r -a myArray
do
    samp=${myArray[0]}
    echo $samp
    if [ "$samp" != "Run" ]
    then
        $SRA/fastq-dump $samp -O $DATA_DIR/fastq/
    fi
done < $samp_file



### Align reads with HISAT2
hisatDir=/storage/yhhuang/tools/hisat2-2.2.0
hisatRef=/storage/yhhuang/research/annotation/mouse/hisatRef/GRCm38.p6
fastaRef=/storage/yhhuang/research/annotation/mouse/GRCm38.p6.genome.fa

## build HISAT reference (only need to run once)
# $hisatDir/hisat2-build -p 32 $fastaRef $hisatRef


## Align each cell
for sample in `ls $DATA_DIR/fastq`
do
    NAME=$(basename $sample .fastq)
    echo $sample $NAME
    
    ($hisatDir/hisat2 -x $hisatRef -U $DATA_DIR/fastq/$sample --no-unal -p 20 | samtools view -bS -> $DATA_DIR/bam/$NAME.bam) 2> $DATA_DIR/bam/$NAME.err
    samtools sort $DATA_DIR/bam/$NAME.bam -o $DATA_DIR/bam/$NAME.sorted.bam
    samtools index $DATA_DIR/bam/$NAME.sorted.bam
done
