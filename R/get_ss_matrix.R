#' compute semantic similarity matrix for one set nodes
#'
#' @param nodes character. Cell Ontology ID.
#' @param semData semantic data.
#' @param measure compute method. one of "Wang", "Resnik", "Rel", "TCSS", "Jiang", "Lin".
#' @param simplify logical. Whether to deduplicate the set of nodes.
#'
#' @return matrix
#' @export
#'
get_ss_matrix <- function(nodes, semData = semData, measure = "Wang", simplify = FALSE) {
  if (simplify) {
    nodes <- unique(nodes)
  }

  len <- length(nodes)

  ss_matrix <- COSemSim::COSim(nodes, nodes, semData = semData, measure = measure)

  if (dim(ss_matrix)[1] != len || dim(ss_matrix)[2] != len) {
    stop("wrong with dim numbers")
  }
  # nodes may contain NA
  if (any(is.na(ss_matrix))) {
    ss_matrix[is.na(ss_matrix)] <- 0
    diag(ss_matrix) <- 1
  }
  return(ss_matrix)
}
