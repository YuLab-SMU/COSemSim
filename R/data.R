#' annotation about gene symbol or protein by cell terms
#'
#' A dataset containing the cell types and corresponding gene symbol
#' and protein id, and annotation relation types.
#' https://r-pkgs.org/data.html
#'
#' @format A data frame with 1191 rows and 6 variables:
#' \describe{
#'   \item{tag}{cell types}
#'   \item{prtag}{protein id}
#'   \item{cond}{relation type}
#'   \item{entity}{gene name}
#'   \item{SYMBOL}{gene symbol id}
#'   \item{name}{cell type name}
#'   ...
#' }
#' @source \url{https://bioportal.bioontology.org/ontologies/CL/}
"anno"


#' child-parent relationship within cell terms
#'
#' A dataset containing the cell types and its name, relationships.
#' https://r-pkgs.org/data.html
#'
#' @format A data frame with 35349 rows and 5 variables:
#' \describe{
#'   \item{id}{cell types}
#'   \item{Term}{full name for cell types}
#'   \item{Ontology}{CO:cell ontology}
#'   \item{parent}{parent term}
#'   \item{relationship}{relationship with parent term}
#'   ...
#' }
#' @source \url{https://bioportal.bioontology.org/ontologies/CL/}
"cotbl"


#' all relationship within cell terms
#'
#' A dataset containing the cell types and its name, parents,
#' chidlren, ancestors, offspring
#' https://r-pkgs.org/data.html
#'
#' @format A list with 6 variables:
#' \describe{
#'   \item{id}{cell types}
#'   \item{name}{full name for cell types}
#'   \item{parents}{parent terms}
#'   \item{ancestors}{ancestor terms}
#'   \item{children}{child terms}
#'   \item{offspring}{offspring terms}
#'   ...
#' }
#' @source \url{https://bioportal.bioontology.org/ontologies/CL/}
"cellonto"


#' HumanPrimaryCellAtlasData for cell type annotation
#'
#' A SummarizedExperiment as reference dataset
#' celldex::HumanPrimaryCellAtlasData()
#' 2021-05-18 version
#'
#' @format S4 object
#'
#' @source celldex::HumanPrimaryCellAtlasData()
"hpca"

#' example expression data
#'
#' A matrix with rows are genes, columns are cells.
#' Human lung tissue with 59 cells and 3491 genes.
#' Already pre-processed, and expression follows log-normal distribution.
#' GSE52583
#'
#' @format matrix
#' @source GSE52583
"counts"

#' Mouse lung tissue cell types markers from cellmarker database
#' A list containing 97 cell types and their marker genes
#' process: \dontrun{
#' # download from cellmarker database http://bio-bigdata.hrbmu.edu.cn/CellMarker/
#' markers <- read.table("cellmarker_database/Mouse_cell_markers.txt", header = T, sep = "\t", fileEncoding = "utf-8")
#'
#' markers_lung <- na.omit(markers[markers$tissueType == "Lung" & markers$speciesType == "Mouse", c("CellOntologyID", "cellMarker")])
#'
#' markers_lung$CellOntologyID <- sub("_", ":", markers_lung$CellOntologyID)
#'
#' marker_genes <- strsplit(as.vector(markers_lung$cellMarker), ", ")
#' names(marker_genes) <- markers_lung$CellOntologyID
#' }
#'
#'
#' @format A list with 97 items
#' @source \url{http://bio-bigdata.hrbmu.edu.cn/CellMarker/}
"marker_genes"
