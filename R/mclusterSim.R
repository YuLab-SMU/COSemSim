#' calculate multiple clusters of genes
#'
#' @param clusters list of vectors
#' @param semData GOSemSim data
#' @param measure one of "Wang", "Resnik", "Rel", "TCSS", "Jiang", "Lin"
#' @param combine one of "BMA", "avg", "max", "rcmax"
#' @importFrom GOSemSim combineScores
#'
#' @return numeric matrix
#' @export
#'
#' @examples
#' semdata <- COdata(keytype = "Symbol",
#' computeIC = TRUE, processTCSS = TRUE, cutoff = NULL)
#'
#' cluster1 <- c("CD5", "CD14", "Ly6g", "mLy76")
#' cluster2 <- c("GATA1", "GATA2")
#' cluster3 <- c("CD19", "CD4", "ITGAM", "CD3E")
#'
#' clusters <- list(cluster1, cluster2, cluster3)
#' names(clusters) <- c("cluster1", "cluster2", "cluster3")
#'
#' mclusterSim(clusters, semdata, measure = "Wang", combine = "BMA")
#'
mclusterSim <- function(clusters, semData, measure = "Wang", combine = "BMA") {
  #get corresponding co ids
  cluster_coids <- lapply(clusters, symbol2CO, semData@geneAnno)

  len <- length(clusters)
  name <- names(clusters)
  #calculate similarity for all coids
  coids <-  unique(unlist(cluster_coids))
  co_matrix <- COSim(coids, coids, semData, measure = measure)
  #scores represent similarity between clusters
  scores <- matrix(NA, nrow = len, ncol = len, dimnames = list(name, name))

  for (i in seq_len(len)) {
    for (j in seq_len(i)) {
      coid1 <- cluster_coids[[i]]
      coid2 <- cluster_coids[[j]]

      scores[i, j] <- GOSemSim::combineScores(co_matrix[coid1, coid2],
                                              combine = combine)
      #diagonal filling
      scores[j, i] <- scores[i, j]
    }
  }

  return(scores)
}
