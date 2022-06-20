#' plot terms in cell ontology
#'
#' @param ontology ontology_index object
#' @param terms character, nodes to plot
#' @param term_text character, the displayed text, defalut will display the name and IDs
#' @param fillcolor the fill color for the nodes
#' @param edge_attributes list, color and lty for all arrows. lty has seven types: "black", "solid", "dotted", "dashed", "dotdashed", "longdashed" and "twodashed".
#' @param border_color the border color for the nodes
#' @param width numeric, the relative width of the nodes, the size of nodes and text will change together.
#' @param fontsize font size of term_text
#' @param shape character, one of "circle", "ellipse", "plaintext" and "box".
#' @param fixedsize character, "true" indicating whether nodes should be fixed size; "false" indicating nodes adjusted to fit around the contained text
#'
#' @export
#' @importFrom ontologyPlot onto_plot
#'
#' @examples
#' notrun{
#'   load("cellonto.rda")
#'   ontology <- cellonto
#'   terms <- head(cellonto$id)
#'
#'   plot_ontology(ontology = ontology,  terms = terms)
#'
#'   group <- 1:6
#'   names(group) <- terms
#'
#'   plot_ontology(ontology = ontology, terms = terms, fillcolor = group)
#'   plot_ontology(ontology = ontology, terms = terms, border_color = group)
#'   plot_ontology(ontology = ontology,  terms = terms, width = group, shape = "circle",fontsize = 60)
#'
#'   plot_ontology(ontology = ontology, terms = terms, fillcolor = ontologyPlot::colour_by_population_frequency(ontology = ontology, terms = terms, frequencies = group, colour_palette = colorRampPalette(c("White", "#11659a"))(10)))
#'
#' }
#'
#'
plot_ontology <- function(ontology = ontology,
                          terms=terms,
                          term_text = NULL,
                          fillcolor = "#5698c3",
                          edge_attributes = list(color = "black", lty = "solid"),
                          border_color = "black",
                          width = 0.75,
                          fontsize = 30,
                          shape="ellipse",
                          fixedsize = "true") {

  #check ontology
  if (!all(c("id", "ancestors") %in% names(ontology))) {
    stop("ontology doesn't have ancestors information")
  }

  #ancestors must have term itself
  ontology$ancestors <- mapply(c, ontology$id, ontology$ancestors)

  if (is.null(term_text) && "name" %in% names(ontology)) {
    term_text <- paste(terms,"\n", ontology[["name"]][terms])
  }
  #to show the entir plot
  par(mar = c(0, 0, 0, 0))

  # set term_sets and frequencies to NULL to dysfunction
  # set style = "filled", other possible options are not known for now
  ontologyPlot::onto_plot(ontology = ontology,
                          term_sets = NULL,
                          frequencies = NULL,
                          terms = terms,
                          edge_attributes = edge_attributes,
                          fillcolor = fillcolor,
                          label = term_text,
                          color = border_color,
                          width = width,
                          fontsize = fontsize,
                          style = "filled",
                          fixedsize = fixedsize,
                          shape = shape)
  #reset to the default value
  par(mar = c(5.1, 4.1, 4.1, 2.1))

  print(p)

}
