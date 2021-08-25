#' calculate similarity value between two sets of genes
#'
#' @param cluster1 vector
#' @param cluster2 vector
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
#'
#' cluster1 <- c("CD5", "CD14", "Ly6g", "mLy76")
#' cluster2 <- c("GATA1", "GATA2")
#'
#' clusterSim(cluster1, cluster2, semdata)
#'
clusterSim <- function(cluster1, cluster2, semData,
                       measure = "Wang",
                       combine = "BMA") {
  geneAnno <- semData@geneAnno
  #corresponding CO terms
  coid1 <- symbol2CO(cluster1, geneAnno)
  coid2 <- symbol2CO(cluster2, geneAnno)

  res <- COSim(coid1, coid2, semData, measure = measure)
  #combineScores already specifies the digits of value
  GOSemSim::combineScores(res, combine)
}
