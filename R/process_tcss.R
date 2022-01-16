process_tcss <- function(ont, IC, cellonto)
{
  if (length(IC) == 0) {
    stop("IC data not found, please re-generate your `semData` with `computeIC = TRUE`...")
  }
  #all coids considered
  COids <- names(IC[!is.infinite(IC)])

  offspring <- cellonto$offspring
  #meta_terms are decided on the root node of the ID with different prefix
  meta_terms <- c("BFO:0000003", "MOD:00764", "NCBITaxon:1", "OBI:0100026"," PATO:0000001", "RO:0002577", "UBERON:0001062", "GO:0008150", "GO:0005575", "GO:0003674", "CHEBI:36342", "CHEBI:24431", "CHEBI:50906", "SO:0000110", "CL:0000000")

  meta_graph <- GOSemSim:::create_sub_terms(meta_terms, offspring = offspring)

  # get the altered IC value for each graph
  ica <- GOSemSim:::calc_ica(meta_graph, IC = IC)

  aa <- utils::stack(meta_graph)
  bb <- split(as.character(aa$ind), aa$values)
  clusid <- bb[COids]
  res <- list(meta_graph = meta_graph, ica = ica, clusid = clusid)
  return(res)
}
