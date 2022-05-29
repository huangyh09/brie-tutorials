#!/bin/bash

# Part 0: prepare for Smart-Seq2 (only run once)
## 0.1 make bam index files
SAM_DIR=./bams_SS2
for bam in `ls $SAM_DIR/*bam`
do
    echo indexing $bam
    samtools index $bam
done

## 0.2 make cell list table
rm cell_table.tsv
SAM_DIR=./bams_SS2
for SAM in $SAM_DIR/*sorted.bam
do
    cellID=`basename $SAM | awk -F".sorted.bam" '{print $1}'`
    echo -e "$SAM\t$cellID" >> cell_table.tsv
done


# Part 1: brie-count on Smart-Seq2 and 10x Genomics
## 1.1 count for smart-seq
brie-count -S cell_table.tsv -a mouse_SE.lenient_50events.gff3 \
    -o outs_SS2 -p 10 #--verbose


## 1.2 count for  10x Genomics data
bam=10xData/neuron_1k_v3_possorted_genome_bam.50events.bam
barcodes=10xData/barcodes.tsv.gz

brie-count -a mouse_SE.lenient_50events.gff3 -s $bam \
   -b $barcodes -o outs_10x -p 10 #--verbose



# Part 2: brie-quant on Smart-Seq2 and 10x Genomics
## 2.1 quant for smart-seq
brie-quant -i outs_SS2/brie_count.h5ad -o outs_SS2/brie_quant_aggr.h5ad \
    --interceptMode gene


## 2.2 quant for smart-seq
brie-quant -i outs_10x/brie_count.h5ad -o outs_10x/brie_quant_aggr.h5ad \
    --interceptMode gene
