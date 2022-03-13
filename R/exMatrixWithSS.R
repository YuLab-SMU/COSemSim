#' multiplication for expression matrix and semantic similarity matrix
#'
#' @param expression_matrix matrix. Rows are genes and columns are cells.
#' @param ss_matrix matrix. Rows and columns are same cells, and consistent with cell in expression_matrix. Cell names of expression_matrix and ss_matrix can be different but follow the same order.
#' @param diag_num numeric. Default value is 1, represents weight for original expression value.
#' @param nondiag_num numeric. represents weight about strength of association with different cells annotated the same cell type.
#' @param rim_num numeric. represents weight about strength of association with different cells annotated different cell type.
#' @param overall_sqrt logical. Whether to perform root operation on matrix.
#'
#' @return matrix
#' @export
#'
exMatrixWithSS <- function(expression_matrix, ss_matrix,
                           diag_num = 1, nondiag_num = 0.01, rim_num = 0.01,
                           overall_sqrt = FALSE) {
  #rows of expression_matrix are genes, and columns are cells
  #cell names of expression_matrix and ss_matrix can be different but follow same order
  if (dim(expression_matrix)[2] != dim(ss_matrix)[1]) {
    stop("dim number isn't match")
  }

  #original cell order in expression matrix
  first_order <- colnames(expression_matrix)

  #new order for cells, same cell types stay together
  second_order <- order(rownames(ss_matrix))
  #cells in new order
  second_cells <- rownames(ss_matrix)[second_order]

  #reordered ss_matrix
  ss_matrix <- ss_matrix[second_order, second_order]
  #reordered expression_matrix
  expression_matrix <- expression_matrix[, second_order]

  #同一类细胞在一块，len是这些细胞分区的坐标
  #cells annotated with same cell type stay together, "len" seperates those cells.
  len <- match(unique(second_cells), second_cells)
  len <- c(len, length(second_cells) + 1)

  #control semantic similayity influence on expression data within different regions
  for (i in 1:(length(len) - 1)) {
    for (j in 1:(length(len) - 1)) {

      region_row <- len[i]:(len[i + 1] - 1)
      region_col <- len[j]:(len[j + 1] - 1)

      ss_matrix[region_row, region_col] <- if (i == j) {
        #ss values in non-diag region should multiply by nondiag_num weight
        ss_matrix[region_row, region_col] * nondiag_num
      } else {
        #ss values in rim region should multiply by rim_num weight
        ss_matrix[region_row, region_col] * rim_num
      }
    }
  }

  #values on diagonal in ss_matrix
  diag(ss_matrix) <- diag_num

  #multiplication for expression matrix and semantic similarity matrix
  if (overall_sqrt) {
    ex_matrix_ss <- sqrt(expression_matrix %*% ss_matrix)
  } else {
    ex_matrix_ss <- expression_matrix %*% ss_matrix
  }

  colnames(ex_matrix_ss) <- colnames(expression_matrix)
  #back to original cells' order
  ex_matrix_ss <- ex_matrix_ss[, first_order]
}
