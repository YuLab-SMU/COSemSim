#' assign environment in which all data is stored
#'
#' @return environment
#' @noRd
#'
.initial <- function() {
  pos <- 1
  envir <- as.environment(pos)

  assign(".COSemSimEnv", new.env(), envir = envir)
  .COSemSimEnv <- get(".COSemSimEnv", envir = .GlobalEnv)


  tryCatch(utils::data(list = "cellonto",
                       package = "COSemSim"))
  cellonto <- get("cellonto")
  assign("cellonto", cellonto, envir = .COSemSimEnv)
  rm(cellonto, envir = .GlobalEnv)


  tryCatch(utils::data(list = "anno",
                       package = "COSemSim"))
  anno <- get("anno")
  assign("anno", anno, envir = .COSemSimEnv)
  rm(anno, envir = .GlobalEnv)

  tryCatch(utils::data(list = "cotbl",
                       package = "COSemSim"))
  cotbl <- get("cotbl")
  assign("cotbl", cotbl, envir = .COSemSimEnv)
  rm(cotbl, envir = .GlobalEnv)
}
