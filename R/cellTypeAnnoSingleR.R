#' cell type annotation by SingleR
#'
#' @param counts expression matrix data, rows are genes, columns are cells.
#' @param ref reference expression data, acquired by SingleR or celldex package. See ??SingleR::SingleR for details. Default value is NULL, will use HPCA data as reference (celldex::HumanPrimaryCellAtlasData()), inputting appropriate ref data is suggested.
#'
#' @return data.frame containing all annotated labels for counts
#' @export
#'
#' @examples
cellTypeAnnoSingleR <- function(counts, ref = NULL) {
  #reference dataset
  if (is.null(ref)) {
    tryCatch(utils::data(list = "hpca", package = "COSemSim"))
    ref <- get("hpca")
    message("using HPCA as refrence dataset")
  }
  # cell type annotation by SingleR
  pred <- SingleR::SingleR(test = counts, ref = ref, labels = ref$label.ont)
  # all annotated labels for cells
  #got_ont <- pred$pruned.labels
  got_ont <- pred$labels
  #all labels in ref data, including label.main, label.fine, label.ont
  ref_label <- as.data.frame(SummarizedExperiment::colData(ref))
  ref_label <- unique(ref_label)
  #corresponding information for annotated labels
  label_cell <- ref_label[match(got_ont, ref_label$label.ont), ]

  rownames(label_cell) <- colnames(counts)

  # add column "cell_ids"
  label_cell$cell_ids <- colnames(counts)

  return(label_cell)
}
