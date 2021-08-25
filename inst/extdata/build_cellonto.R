load("cl.RData")

#########cl_intersection########
#In cl, "intersection_of" has complicated elements, it combines several relationships,
#it needs to be split up.
cl_inter <- cl$intersection_of

#trans to data.frame
cl_inter_df <- stack(cl_inter)
names(cl_inter_df) <- c("chain_id", "id")


cl_inter_split <- lapply(cl_inter_df$chain_id, function(e) strsplit(e, " ")[[1]])

#relationship between id and chain_id
chain_relation <- unlist(lapply(cl_inter_split, function(e) {
  if (length(e) == 1) {
    #here no description, fill in "intersection_of"
    "intersection_of"
  } else {
    e[1]
  }
}))

#chain_id
chain_id <- unlist(lapply(cl_inter_split, function(e) {
  if (length(e) == 1) {
    e
  } else {
    e[2]
  }
}))

#result
cl_intersection <- data.frame(
  id = as.character(cl_inter_df$id),
  chain_relation = chain_relation,
  chain_id = chain_id
)

# table(cl_intersection$chain_relation)
# length(table(cl_intersection$chain_relation))

dim(cl_intersection)
#[1] 13661     3



########all_relation########
#all relationship between cl terms

all_name <- names(cl)

b <- cl
b <- lapply(b, function(e) e[sapply(e,function(e.e) length(e.e) != 0)])


#four reasons to be remove_name:
#1. parents, children, ancestors
#2. in the corresponding list is descriptive character, not cl term
#3. clearly not defining relationships between terms
#never_in_taxon??
remove_name <- c("id", "name", "parents", "children", "ancestors", "obsolete", "alt_id", "comment", "created_by", "creation_date", "data-version", "dc-contributor", "dc-creator", "def", "domain", "format-version", "namespace", "never_in_taxon", "ontology", "property_value", "range", "remark", "seeAlso", "subset", "subsetdef", "synonym", "synonymtypedef", "xref")

#left_name means all relationships
left_name <- setdiff(all_name, remove_name)

all_relation <- lapply(left_name, function(e) {
  content <- cl[[e]]

  len <- lengths(content)

  content <- content[len != 0]

  if (length(content) != 0) {
    #transform into data.frame
    #three columns:"id", "chain_relation", "chain_id"
    df <- stack(content)
    names(df) <- c("chain_id", "id")
    df$id <- as.character(df$id)

    df$"chain_relation" <- e

    df <- df[, c("id", "chain_relation", "chain_id")]

    return(df)

  } else {
    NULL
  }
})

all_relation <- Reduce(rbind, all_relation)
all_relation <- unique(all_relation)

dim(all_relation)
#[1] 41445     3

#1. replace relationships from intersection_of
all_relation <- all_relation[all_relation$chain_relation != "intersection_of", ]

all_relation <- rbind(all_relation, cl_intersection)

all_relation <- unique(all_relation)
dim(all_relation)
#[1] 35423     3


#2. delete where id and chain_id is same
pos1 <- which(unlist(mapply(identical,
                            all_relation$id,
                            all_relation$chain_id)) == TRUE)

all_relation <- all_relation[-pos1, ]

dim(all_relation)
#[1] 35416    3


#3. remove id not in cl
pos2 <- all_relation$id %in% id

pos3 <- all_relation$chain_id %in% id

all_relation <- all_relation[pos2 & pos3, ]

dim(all_relation)
#[1] 35349     3

save(all_relation, file = "all_relation.RData")


######cellonto#######
#all parents..offspring information about cell ontolgoy

#parent
#consider all kinds of relationship
parents <- split(all_relation$chain_id, all_relation$id)
#do not contain itself

#children
children <- split(all_relation$id,all_relation$chain_id)

#ancestors and offspring


#assign .ancestorsEnvir to store the ancestor terms
pos <- 1
envir <- as.environment(pos)
assign(".ancestorsEnvir", new.env(), envir = envir)
.ancestorsEnvir <- get(".ancestorsEnvir", envir = envir)

#depth_search helps get the ancestor terms for each input term from pool
depth_search <- function(term, pool) {
  #term's parents
  #to enter the loop
  items <- pool[[term]]
  #store ids that already included in .ancestorsEnvir
  names_result <- term

  while (length(items) != 0) {
    #Remove what already got
    items <- setdiff(items, names_result)

    #term's parents' parents
    new_items <- unname(unlist(mget(items,
                                    envir = .ancestorsEnvir,
                                    ifnotfound = pool[items])))
    #items have been queried, so items is recorded
    names_result <- c(names_result, items)

    items <- new_items
    #if items is empty, then quit the loop
  }
  #final result is parents of recorded terms
  result <- unique(unname(unlist(pool[names_result])))

  #store result into envir
  assign(term, result, envir = .ancestorsEnvir)
}

#ancestors
ancestors <- lapply(id, function(id) depth_search(id, parents))
#2-3 minutes

#View(.ancestorsEnvir)
rm(.ancestorsEnvir)

#offspring
offspring <- split(rep(names(ancestors), lengths(ancestors)), unlist(ancestors))


#togather
cellonto <- cl[c("id", "name")]
cellonto$parents <- parents
cellonto$children <- children
cellonto$ancestors <- ancestors
cellonto$offspring <- offspring



save(cellonto, file = "cellonto.rda", compress = "xz")
#11.5MB, 1.1MB
