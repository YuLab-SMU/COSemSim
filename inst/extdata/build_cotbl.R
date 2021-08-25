load("cellonto.rda")
load("all_relation.RData")


#####cotbl######
#Build a data.frame like gotbl in GOSemSim

cotbl <- all_relation[, c("id","chain_id")]
names(cotbl) <- c("id", "parent")


#relationship between id and parent, may has multi types
cotbl$relationship <- mapply(function(id, p) {

  pos1 <- which(id == all_relation$id)
  pos2 <- which(p == all_relation$chain_id)

  pos <- intersect(pos1, pos2)

  all <- all_relation$chain_relation[pos]

  len <- length(pos)

  if (len == 0) {
    return(NA)
  }

  if (len == 1) {
    return(all)
  }
  #the priority is: is_a > part_of > other
  if ("is_a" %in% all) {
    "is_a"
  }else if ("part_of" %in% all) {
    "part_of"
  }else {
    all[1]
    #so be it
  }

}, cotbl$id, cotbl$parent)


cotbl$Term <- cellonto$name[cotbl$id]
cotbl$Ontology <- "CO"

save(cotbl, file = "cotbl.rda", compress = "xz")
