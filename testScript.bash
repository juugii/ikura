#! /usr/bin/bash

./ikura_10x -1 /storage1/scripts/scRNAseq/ikura/10x/testFiles/test_R1.fastq.gz -2 /storage1/scripts/scRNAseq/ikura/10x/testFiles/test_R2.fastq.gz -n 8000 -o testOut -i /storage1/annotations/alevin/human/alevinIndex_huGencodeGRCh38p12/ -g /storage1/annotations/alevin/human/txp2gene_hu_gencodev28.tsv

exit 0
