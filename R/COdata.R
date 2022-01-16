#' build annoData for semantic measurement
#'
#' @param keytype "Symbol" or "PRO"
#' @param computeIC logical, TRUE/FALSE
#' @param processTCSS logical, TRUE/FALSE, only necessary when TCSS method used
#' @importClassesFrom GOSemSim GOSemSimDATA
#' @importFrom methods new
#' @importFrom stats na.omit
#'
#' @return GOSemSimDATA data
#' @export
#'
#' @examples
#' semdata <- COdata(keytype = "Symbol",
#' computeIC = TRUE, processTCSS = TRUE)
#'
COdata <- function(keytype = "Symbol",
                   computeIC=TRUE, processTCSS = TRUE) {

  if (!exists(".COSemSimEnv")) .initial()
  .COSemSimEnv <- get(".COSemSimEnv", envir = .GlobalEnv)
  cellonto <- get("cellonto", envir = .COSemSimEnv)
  anno <- get("anno", envir = .COSemSimEnv)

  keytype <- match.arg(keytype, c("Symbol", "PRO"))

  if (keytype == "Symbol") {
    anno <- anno[, c("SYMBOL", "tag", "cond")]
  } else {
    anno <- anno[, c("prtag", "tag", "cond")]
  }

  anno <- na.omit(anno)
  anno <- unique(anno)

  ont <- "CO"

  if (computeIC) {
    message("preparing IC data...")
    IC <- computeIC(anno, cellonto)
    if (processTCSS) {
      tcssdata <- process_tcss(ont, IC = IC, cellonto = cellonto)
    }
  }

  res <- new("GOSemSimDATA",
             keys = cellonto$id,
             ont = "CO",
             geneAnno = anno,
             metadata = as.data.frame(ontoProc::recognizedPredicates())
  )

  if (computeIC) {
    res@IC <- IC
    if (processTCSS) {
      res@tcssdata <- tcssdata
    }
  }

  return(res)
}
