#' cell type annotation by SCINA
#'
#' @param counts expression matrix, rows are genes and columns are cells
#' @param marker_genes list, contains marker genes for each cell type, all cell types represent as name.
#' @param max_iter see details in help(SCINA)
#' @param convergence_n
#' @param convergence_rate
#' @param sensitivity_cutoff
#' @param rm_overlap
#' @param allow_unknown
#' @param log_file
#'
#' @return data.frame, three columns "cell_ids", "cellType", "cellname" means original cell-ids in expression counts, annotated cell types and cell names in cell ontology respectively.
#' @export
#'
#' @examples
#' library(COSemSim)
#' data(counts)
#' data(marker_genes)
#'
#' results <- cellTypeAnnoSCINA(counts, marker_genes)
#'
cellTypeAnnoSCINA <- function(counts, marker_genes,
                              max_iter = 100, convergence_n = 10,
                              convergence_rate = 0.999,
                              sensitivity_cutoff = 0.9,
                              rm_overlap = FALSE,
                              allow_unknown = FALSE,
                              log_file='SCINA.log') {

  #first filter
  marker_filter1 <- lapply(marker_genes, function(e) intersect(e, rownames(counts)))
  marker_filter1 <- marker_filter1[lengths(marker_filter1) > 0]

  #second filter
  #same records may corrsponding to more than one cell type
  #here only keep the first one
  marker_filter2 <- unique(marker_filter1)
  names(marker_filter2) <- names(marker_filter1)[match(marker_filter2, marker_filter1)]

  #use SCINA to annotate cell types for counts
  result <- SCINA::SCINA(counts, marker_filter2,
                         max_iter = max_iter, convergence_n = convergence_n,
                         convergence_rate = convergence_rate,
                         sensitivity_cutoff = sensitivity_cutoff,
                         rm_overlap = rm_overlap,
                         allow_unknown = allow_unknown,
                         log_file = log_file)
  #cell types
  cellType <- result$cell_labels
  #cellonto stores cell ontology information
  tryCatch(utils::data(list = "cellonto", package = "COSemSim"))
  cellonto <- get("cellonto")
  #cell id in counts
  cell_ids <- colnames(counts)

  res <- data.frame(cell_ids = cell_ids,
                    cellType = cellType,
                    cellname = cellonto$name[cellType])
  rownames(res) <- cell_ids
  return(res)
}
