#'  calculate similarity value between two sets of coids
##' @param COsets list of one or more character vectors
##'
##' @param semData GOSemSim data
##' @param measure one of "Wang", "Resnik", "Rel", "TCSS", "Jiang", "Lin"
##' @param combine one of "BMA", "avg", "max", "rcmax"
##' @importFrom GOSemSim combineScores
##'
##' @export
##' @return numeric matrix
##' @examples
##'
##' semdata <- COdata(keytype = "Symbol",
##' computeIC = TRUE, processTCSS = TRUE, cutoff = NULL)
##' COset1 <- c("CL:0000013", "CL:0000014", "CL:0000015")
##' COset2 <- c("CHEBI:72695", "CHEBI:78295", "CL:0000000")
##' COset3 <- c("BFO:0000141", "CARO:0000000")
##'
##' COsets <- list(COset1, COset2, COset3)
##' names(COsets) <- c("COset1", "COset2", "COset3")
##'
##' mCOSim(COsets, semdata)
##'
mCOSim <- function(COsets, semData, measure = "Wang", combine = "BMA") {

  len <- length(COsets)
  name <- names(COsets)
  #calculate similarity for all coids
  coids <-  unique(unlist(COsets))
  co_matrix <- COSim(coids, coids, semData, measure = measure)
  #scores represent similarity between clusters
  scores <- matrix(NA, nrow = len, ncol = len, dimnames = list(name, name))

  for (i in seq_len(len)) {
    for (j in seq_len(i)) {
      coid1 <- COsets[[i]]
      coid2 <- COsets[[j]]

      scores[i, j] <- GOSemSim::combineScores(co_matrix[coid1, coid2],
                                              combine = combine)
      #diagonal filling
      scores[j, i] <- scores[i, j]
    }
  }

  return(scores)
}
