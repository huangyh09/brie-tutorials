#!/bin/bash

## Data set
# wget http://ufpr.dl.sourceforge.net/project/brie-rna/examples/dentateGyrus/brie2_dentateGyrus.zip
# unzip -j brie2_dentateGyrus.zip -d ./data

## GPU or CPU server
DATA_DIR=./data
cd $DATA_DIR


## Notes
# For GPU, you can use CUDA_VISIBLE_DEVICES to specify the specific GPU card,
# for example we using the No.2 out of four. For CPU server, please comment
# the first line: CUDA_VISIBLE_DEVICES=2 \


### Differential momentum genes: OPC vs OL
CUDA_VISIBLE_DEVICES=0 \
brie-quant -i $DATA_DIR/dentategyrus_raw_filtered.h5ad \
    -c $DATA_DIR/dentategyrus_cluster_OL.tsv \
    -o $DATA_DIR/brie_dentategyrus_cluster_subOL.h5ad \
    --layers=spliced,unspliced --batchSize 1000000 \
    --minCell 10 --minCount 10 --minUniqCount 10 \
    --interceptMode gene --LRTindex All


### Differential momentum genes: one cell type vs the rest
CUDA_VISIBLE_DEVICES=0 \
brie-quant -i $DATA_DIR/dentategyrus_raw_filtered.h5ad \
    -c $DATA_DIR/dentategyrus_cdr_cluster.tsv \
    -o $DATA_DIR/brie_dentategyrus_cluster.h5ad \
    --layers=spliced,unspliced --batchSize 1000000 \
    --minCell 10 --interceptMode gene --testBase null \
    --LRTindex 1,2,3,4,5,6,7,8,9,10,11,12,13,14
