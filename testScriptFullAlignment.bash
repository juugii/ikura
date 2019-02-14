#! /usr/bin/bash

./ikura_10x --no-fastq-check --read1 /storage1/analyses/francois/singleCell/huThy/analyses/ikura02_withCD45Risoforms/huThy_MAIT_ikura02_CD45R/fastq/huThy_MAIT_ikura02_CD45R_trimmed_R1.fastq.gz --read2 /storage1/analyses/francois/singleCell/huThy/analyses/ikura02_withCD45Risoforms/huThy_MAIT_ikura02_CD45R/fastq/huThy_MAIT_ikura02_CD45R_trimmed_R2.fastq.gz --expectedCells 8000 --output testOut --index /storage1/annotations/alevin/human/alevinIndex_huGencodeGRCh38p12/ --txp2gene /storage1/annotations/alevin/human/txp2gene_hu_gencodev28.tsv --threads 16

exit 0
