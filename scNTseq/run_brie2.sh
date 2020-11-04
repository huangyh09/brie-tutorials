#!/bin/bash

### Notes for data set
# See how to fetech the data: ./scNTseq_data_combine.ipynb

## Data set
# wget http://ufpr.dl.sourceforge.net/project/brie-rna/examples/scNTseq/brie2_scNTseq.zip
# unzip -j brie2_scNTseq.zip -d ./data


## GPU or CPU server (symbolic link)
DATA_DIR=./data
cd $DATA_DIR

## Notes
# For GPU, you can use CUDA_VISIBLE_DEVICES to specify the specific GPU card,
# for example we using the No.2 out of four. For CPU server, please comment
# the first line: CUDA_VISIBLE_DEVICES=2 \

CUDA_VISIBLE_DEVICES=2 \
brie-quant -i $DATA_DIR/neuron_splicing_totalRNA.h5ad \
    -c $DATA_DIR/neuron_splicing_time.tsv \
    -o $DATA_DIR/brie_neuron_splicing_time.h5ad \
    --layers=spliced,unspliced --batchSize 1000000 \
    --minCell 300 --interceptMode gene --LRTindex All
