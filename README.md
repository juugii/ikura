## Ikura:

A pipeline for primary analysis of single cell experiments: quality controls and trimming, demultiplexing, cell calling and transcript quantification. This version support experiments from 10x 3' libraries.

Ikura creates outputs reports and expression matrices in convenient formats. Particularly expression outputs are similar to cellranger v2, and integrate well with existing pipelines and popular downstream analysis tools (eg. Seurat).

Analyses can be performed on any laptop or desktop, and are typically achieved within 3-4 hours (3k-8k cells, with 4 Gb of RAM and 8 CPU cores), and  takes only 1 hour without any quality trimming.

For an exact reproductibility with the article (under review), see the corresponding git branch.


## Key interests

* fast and resource-efficient, no need of hi-performence computing cluster
* detailed quality controls and reports
* quality-trimming of fastq files
* performant cell calling
* sensitive transcript quantification:

In our datasets, Ikura shows improved sensitivity in transcript quantification, particularly with highly-conserved genes (eg. chemokines or chemokine receptors). It also performs an efficient cell calling by identifying cells with uniform sequencing depth, excluding cells with low number of UMI that could be hardly classified in downstream analyses.

<img src="img/comp01.png" height="500" align="center">
<img src="img/comp02.png" height="500" align="center">

## Getting Started

```bash
$ ./ikura --help

Ikura v1.0
Index: 	./ikura --warmup
		[-t|--transcripts] <transcripts.fa>
		[-a|--annotation] <annotation.gtf>
		[-i|--index] <ikuraIndex>

Quantif:./ikura	[-q|--no-fastq-check] (optional)
		[-1|--read1] <read1>
		[-2|--read2] <read2>
		[-n|--expectedCells] <expectedCellNb>
		[-o|--output] <samplePrefix>
		[-i|--index] <ikuraIndex>
		[-t|--threads] <coresNb> (optional, default is 10)

	NOTE: files should be specified as absolute paths.
	Ikura creates an output directory where the command is executed.

```

First, we need to build an index for the transcript quantification. To build it, Ikura needs transcripts sequences provided in fasta format, and a genome annotation file in gtf format. There are several sources for gene annotation, but as Ikura has been developped with [genecode](https://www.gencodegenes.org/) sources, it will work out-of-the box with them. After download and archive extraction, the index can be build with the command:

```bash
$ ./ikura --warmup --transcripts transcripts.fa --annotation annotation.gtf --index customNameOfTheIndex
```

Then you can start the QC assesment and the transcript quantification with:

```bash
$ ./ikura --read1 sample_R1.fastq.gz --read2 sample_R2.fastq.gz --expectedCells 6000 --output nameOfSample --index customNameOfTheIndex

```

By default, Ikura will use 10 cores, which has been found to be the best CPU/memory tradeoff. In the case of a smaller configuration, Ikura's resources can be limitated (eg. with the option --threads 4).

The expected cell number will help identifying the true cellular barcodes (the default value is 8000). It is an upper limit, so in case of any doubt, using the effective number of cells that have been loaded in the chromium is a good choice.


## Sample QC report output

<img src="img/smplOut.png" height="700" align="center">


## And after?

A html report has been generated in the output folder. Details on the cell calling are inside the "plots" folder. You can now import the transcript quantification with Seurat (ie. Read10x("/path/to/folder/nameOfSample/outs")) or any other tools. An R object is also avilable in this output directory.

If work on T-cells or B-cells, you might be interested by Ikura's companion tool: [Tobiko](https://github.com/juugii/Tobiko).

## Prerequisites

Ikura has been developped on Linux and tested on several 64-bits distribution (CentOS 7, Debian 9, Ubuntu 18.04 LTS), and should be compatible with MacOSX (Posix compliant).
It has the following dependencies: python>=3.6.5, R>=3.5.0 (preferred, not a mandatory), salmon>=0.11, awk, umi_tools>=0.5.4; fastq QC and precleaning require fastqc>=0.11.7, multiqc>=1.5 & cutadapt>=1.18.


## Installing

First, manually install [salmon](https://github.com/COMBINE-lab/salmon) >= 0.11 and [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc) >= 0.11.7 on your system. You will also need to have R (>=3.5.0 preferred) and python>=3.6.5 installed.

For Ikura to work out-of-the-box, all of these softwares should be directly callable, so add them to your environment path. *Alternatively*, you can edit manualy the 'dependencies.txt' file to specify custom paths and integrate Ikura to your system. In case of any bad configuration, Ikura will warn you.

Download and extract the latest release of [Ikura](), enter the directory and type:

```bash
$ make install

```

You will need administrative rights for this. You can also install Ikura localy with:

```bash
$ make install PREFIX=/path/to/your/local/folder

```

You can then add the install folder in the path of your bashrc.


## Citation

Ikura's article is under reviewing.
Ikura relies on external tools, so please also cite:

[Salmon](https://github.com/COMBINE-lab/salmon): Patro, R., Duggal, G., Love, M. I., Irizarry, R. A., & Kingsford, C. (2017). Salmon provides fast and bias-aware quantification of transcript expression. Nature Methods.

[UMItools](https://github.com/CGATOxford/UMI-tools): Smith, T., Heger, A., Sudbery, I., UMI-tools: modeling sequencing errors in Unique Molecular Identifiers to improve quantification accuracy. Genome Research.

[Cutadapt](https://github.com/marcelm/cutadapt): Martin, M., Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet journal.
