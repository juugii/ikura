#! /usr/bin/bash

#Jules GILET <jules.gilet@curie.fr>

#custom pipeline for the analysis of single cell 10x experiments
#alignment done with salmon

#requires a salmon-indexed transcriptome and its tx2gene
#requires python-3.6.5 or above
#requires umi_tools 0.5.4 or above
#requires R-3.5.0 or above


if [[ $1 == "--help" || $1 == "-h" || $# != 6 ]]; then

	echo "The script requires the following 6 arguments (in proper order):

	scPipelineSalmon10x.sh <read1> <read2> <expectedCellNb> <samplePrefix> <salmonIndex> <txp2gene>

	Paths to directories and files should be provided as absolute addresses

	Additional requirements:
	requires python, R, salmon, awk
	requires a samon-indexed transcriptome
	requires umi_tools 0.5.4 or above
	"

	exit 0

fi


#aliases and dependences
UMITOOLS='/storage1/local/python/python-3.6.5/bin/umi_tools'
SALMON='/storage1/downloads/salmon-0.11.1-linux_x86_64/bin/salmon'
CREATEMATRIX='/storage1/scripts/scRNAseq/scCustomPipeline02_salmon/10x/createMatrix.rscript'

#VARS
READ1=$1
READ2=$2
MAXCELLS=$3
PREFIX=$4
SALMONINDEX=$5
TXP2GENE=$6

#exec
if [ ! -d "$PREFIX" ]; then

	mkdir $PREFIX

fi
cd ${PREFIX}

if [ ! -d "logs" ]; then

	mkdir logs

fi

if [ ! -d "plots" ]; then

        mkdir plots

fi

echo "identifying valid cell barcodes..."

${UMITOOLS} whitelist --stdin ${READ1} --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --expect-cells=${MAXCELLS} -L logs/umiWhitelist${PREFIX}.log --verbose=2 --plot-prefix=plots/filteringPlot_${PREFIX} > whitelist_${PREFIX}.txt

awk '{print $1}' whitelist_${PREFIX}.txt > whitelist_${PREFIX}_alevinReady.txt
mv whitelist_${PREFIX}.txt logs/

echo "starting alignment..."

${SALMON} --no-version-check alevin -lISR -1 ${READ1} -2 ${READ2} --chromium --whitelist whitelist_${PREFIX}_alevinReady.txt -i ${SALMONINDEX} -p 10 --dumpCsvCounts -o alevinOut --tgMap ${TXP2GENE}

echo "exporting matrix..."

${CREATEMATRIX} alevinOut/

echo "cleaning directories..."

mv alevinOut/logs/* logs/
mv alevinOut/libParams/* logs/
mv alevinOut/*.json logs/
mv alevinOut/outs/* alevinOut/
rm -r alevinOut/alevin/ alevinOut/aux_info/ alevinOut/libParams/ alevinOut/logs/ alevinOut/outs/
mv whitelist_${PREFIX}_alevinReady.txt logs/goodCellBarcodes_${PREFIX}.txt
mv alevinOut/ outs/

echo "done."

exit 0
