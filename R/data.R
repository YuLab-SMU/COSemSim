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
