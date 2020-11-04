#!/bin/bash

### Notes for data set
## paper: Disease-specific oligodendrocyte lineage cells arise in multiple sclerosis
## https://www.nature.com/articles/s41591-018-0236-y

anno_file=./data/SE.lenient.gff3.gz

DATA_DIR=./data/
cd $DATA_DIR


### BRIE2 count
samList=$DATA_DIR/cell_bams.tsv

## Make cell list
rm $DATA_DIR/cell_bams.tsv
for sample in `ls $DATA_DIR/bam/*sorted.bam`
do
    NAME=$(basename $sample .sorted.bam)
    echo $sample$'\t'$NAME >> $DATA_DIR/cell_bams.tsv
done

### run brie-count
brie-count -a $anno_file -S $samList -o $DATA_DIR/cntBRIE -p 15


### run brie-quant
## Notes
# For GPU, you can use CUDA_VISIBLE_DEVICES to specify the specific GPU card,
# for example we using the No.2 out of four. For CPU server, please comment
# the first line: CUDA_VISIBLE_DEVICES=2 \

CUDA_VISIBLE_DEVICES=0 \
brie-quant -i $DATA_DIR/brie_count.h5ad \
    -o $DATA_DIR/cntBRIE/brie_quant_aggr.h5ad \
    --interceptMode gene --batchSize 300000

CUDA_VISIBLE_DEVICES=0 \
brie-quant -i $DATA_DIR/brie_count.h5ad -c $DATA_DIR/cell_anno.tsv \
    -o $DATA_DIR/brie_quant_cell.h5ad \
    --interceptMode gene --LRTindex 0 --batchSize 300000
