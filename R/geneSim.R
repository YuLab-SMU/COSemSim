#' calculate semantic similarity for one or two gene vectors
#'
#' @param gene1 vector
#' @param gene2 vector
#' @param semData GOSemSim data
#' @param measure one of "Wang", "Resnik", "Rel", "TCSS", "Jiang", "Lin"
#' @param combine one of "BMA", "avg", "max", "rcmax"
#' @importFrom GOSemSim combineScores
#'
#' @return numeric
#' @export
#'
#' @examples
#' semdata <- COdata(keytype = "Symbol",
#' computeIC = TRUE, processTCSS = TRUE, cutoff = NULL)
#' geneSim("ACP5", "FOS", semdata, measure = "Resnik", combine = "BMA")
#' geneSim(c("CD19", "CD3E"), c("CD14", "CD19"), semdata)
#' geneSim(c("CD19", "CD3E"), NULL, semdata)
#'
geneSim <- function(gene1, gene2 = NULL,
                    semData,
                    measure = "Wang",
                    combine = "BMA") {

  geneAnno <- semData@geneAnno
  #gene2 is null, then calculate similarity for one single gene vector
  if (is.null(gene2)) {
    gene2 <- gene1
  }
  #combine together
  all_genes <- unique(c(gene1, gene2))
  #all cell types annotated
  coids <- lapply(all_genes, symbol2CO, geneAnno = geneAnno)
  names(coids) <- all_genes
  #all genes have no annotations
  if (length(unlist(coids)) == 0) {
    return(NA)
  }
  #return a matrix
  scores <- mCOSim(coids,
                   semData = semData,
                   measure = measure,
                   combine = combine)

  scores <- scores[gene1, gene2]

  return(scores)
}


#faster than ==
symbol2CO <- function(symbol, geneAnno) {
 unique(geneAnno[geneAnno[, "SYMBOL"] %in% symbol, ][, "tag"])
}
