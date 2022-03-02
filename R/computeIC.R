#' compute information content value for CO terms based on annotation data
#'
#' @param anno annotation about gene symbol or protein by cell terms
#' @param COids all cell ontology ids
#' @param offspring offspring nodes for each node
#'
#' @return named numeric vector
#' @noRd
#'
computeICanno <- function(anno, COids, offspring) {

  COcount <- table(anno$tag)
  #CO ids with annotations
  COterms <- names(COcount)
  #assign 0 to excluded CO ids
  CO.diff <- setdiff(COids, COterms)
  m <- double(length(CO.diff))
  names(m) <- CO.diff
  #frequency for all CO ids
  COcount <- c(COcount, m)
  #offspring do not include itself
  #calculate the cumulative frequency
  cnt <- COcount[COids] + unlist(lapply(COids, function(id) {
    sum(COcount[offspring[[id]]], na.rm = TRUE)
  }))
  names(cnt) <- COids
  #normalization
  p <- cnt / sum(COcount)
  IC <- -log(p)

  return(IC)
}

#' compute information content value for CO terms based on offspring data
#'
#' @param COids all cell ontology ids
#' @param offspring offspring nodes for each node
#'
#' @return
#' @noRd
#'
computeIChyponym <- function(COids, offspring) {

  num <- length(COids)

  IC <- lapply(COids, function(id) {
    1 - (log(length(offspring[[id]]) + 1) / log(num))
  })
  unlist(IC)
}
