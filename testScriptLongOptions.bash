#! /usr/bin/bash

./ikura_10x --read1 /storage1/scripts/scRNAseq/ikura/10x/testFiles/test_R1.fastq.gz --read2 /storage1/scripts/scRNAseq/ikura/10x/testFiles/test_R2.fastq.gz --expectedCells 8000 --output testOut --index /storage1/annotations/alevin/human/alevinIndex_huGencodeGRCh38p12/ --txp2gene /storage1/annotations/alevin/human/txp2gene_hu_gencodev28.tsv --threads 16

exit 0
