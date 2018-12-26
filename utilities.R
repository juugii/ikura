#! /storage/local/R/R-3.5.0/bin/R
#for interactive session only

#Jules GILET <jules.gilet@curie.fr>
#
#some useful functions companion of ikura
#

readIkura <- function(path){

	require(Matrix)

	message("reading data...")
	mat <- readMM(paste0(path, '/matrix.mtx'))
	genes <- read.delim(paste0(path, '/genes.tsv'), sep="\t", header=FALSE, stringsAsFactors=FALSE)$V2
	cells <- read.delim(paste0(path, '/barcodes.tsv'), sep="\t", header=FALSE, stringsAsFactors=FALSE)$V1

	colnames(mat) <- cells
	rownames(mat) <- genes

	return(mat)

}


filterProtcod <- function(mat, protcodFile){

	protcod <- readLines(protcodFile)
	mat <- mat[ rownames(mat) %in% protcod, ]
	return(mat)

}


filterMinGenesCells <- function(mat, minGenes=500, minCells=3){

	mat <- mat[ (rowSums(mat > 0) > 3) ,(colSums(mat > 0) > 500) ]
	return(mat)

}


filterIkura <- function(mat, protcodFile=NULL, minGenes=500, minCells=3){

	if( !(is.null(protcodFile)) ) {
		mat <- filterProtcod(mat, protcodFile)
	} else {print("Warning: matrice mights also contain non-protein coding genes.")}

	mat <- filterMinGenesCells(mat, minGenes, minCells)

	return(mat)

}


joinEmat <- function(mat1, mat2){

	a <- mat1
	b <- mat2
	genesa <- rownames(a)
	genesb <- rownames(b)

	genes <- c(genesa, genesb)

	a <- as.data.frame(as.matrix(a))
	b <- as.data.frame(as.matrix(b))
	colnames(a) <- paste0(colnames(a), "-1")
	colnames(b) <- paste0(colnames(b), "-2")
	a$genes <- rownames(a)
	b$genes <- rownames(b)
	c <- merge(a, b, by="genes", all=TRUE)
	rownames(c) <- c$genes
	c <- c[,-1]
	c[is.na(c)] <- 0

	mat <- Matrix(as.matrix(c), sparse=TRUE)
	colnames(mat) <- colnames(c)
	rownames(mat) <- rownames(c)

	return(mat)

}


exportIkura <- function(mat, path){

        require(Matrix)

        cells <- colnames(mat)
        genes <- rownames(mat)

        message("exporting matrix...")
        write.table(x=data.frame(cell=cells), file=paste0(path,"/barcodes.tsv"), row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")
        write.table(x=data.frame(gene=genes, gene=genes), file=paste0(path,"/genes.tsv"), row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")
        writeMM(mat, file=paste0(path,"/matrix.mtx"))

        return("Done.")

}
