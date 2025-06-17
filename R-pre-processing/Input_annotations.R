library(org.Mm.eg.db)
library(AnnotationDbi)
library(dplyr)
library(GO.db)

#counts and colData
counts <- read.csv("/home/ethan/RNA-Project/Data/pc_counts_5-20.csv")

# Map gene symbols to full gene names (e.g., full descriptions)
gene_info <- AnnotationDbi::select(org.Mm.eg.db,
                    keys = counts$X,
                    columns = c("SYMBOL", "GENENAME"),
                    keytype = "SYMBOL")

GO_ids <- AnnotationDbi::select(org.Mm.eg.db,
                                keys = counts$X,
                                columns = c("SYMBOL", "ONTOLOGY", "GO"),
                                keytype = "SYMBOL")

GO_info <- AnnotationDbi::select(GO.db,
                    keys = GO_ids$GO,
                    columns = c("TERM", "ONTOLOGY"),
                    keytype = "GOID" )

# Join the result with your res table
counts_annotated <- left_join(counts, gene_info, by = c("X" = "SYMBOL"))
counts_annotated <- counts_annotated %>%
  dplyr::select(X, everything())

# Save
write.csv(counts_annotated, file = "/home/ethan/RNA-Project/Data/Counts_Annotated.csv", row.names = FALSE)
write.csv(GO_info, file = "/home/ethan/RNA-Project/Data/GO_info.csv")

