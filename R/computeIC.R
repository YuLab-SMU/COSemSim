#' compute information content value for CO terms
#'
#' @param anno annotation about gene symbol or protein by cell terms
#' @param cellonto child-parent relationship within cell terms
#'
#' @return named numeric vector
#' @noRd
#'
computeIC <- function(anno, cellonto) {
  #all CO ids
  COids <- cellonto$id

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
  offspring <- cellonto$offspring

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
