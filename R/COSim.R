#' calculate semantic similarity value for two CO terms
#'
#' @param t1 term1
#' @param t2 term2
#' @param semData GOSemSim data
#' @param measure one of "Wang", "Resnik", "Rel", "TCSS", "Jiang", "Lin"
#' @importFrom GOSemSim termSim
#'
#' @return numeric
#' @export
#'
#' @examples
#' semdata <- COdata(keytype = "Symbol",
#' computeIC = TRUE, processTCSS = TRUE, cutoff = NULL)
#' COSim("CL:0002005","CL:0002006", semdata, measure = "TCSS")
#'
COSim <- function(t1, t2, semData, measure = "Wang") {
  GOSemSim::termSim(t1, t2, semData, measure)
}
