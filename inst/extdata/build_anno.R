#######cell ontology data######

#download newest owl file from https://bioportal.bioontology.org/ontologies/CL/
#robot(java tool) transform owl to obo
#https://github.com/ontodev/robot/releases/tag/v1.8.1
#iconv(linux command) converts file from ASCII to UTF-8

cl <- ontologyIndex::get_OBO("2021-06-29_by_robot_and_iconv.obo",
                             extract_tags = "everything")

id <- cl$id
#length : 10267

#from 10014 to 10267, obo file starts with [Typedef] rather than [Term], those
#describe relationship but cl ID.

pos <- 1:10013

cl <- lapply(cl, function(e) e[pos])

id <- cl$id
#length : 10013

#attention:id[5466], "RO:0002577" represents cl term.
#attention2:the parents..offspring in cl is not correct

save(cl, file = "cl.RData")

#########anno######
#represents relationship between cl id and gene symbol or protein id
library(ontoProc)
anno <- lapply(id, function(e) ontoProc::CLfeats(cl, e))
anno <- Reduce(rbind, anno)
anno <- unique(anno)

dim(anno)
#[1]1187    6

save(anno, file = "anno.rda")
