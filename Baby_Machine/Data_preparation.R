library(TCGAbiolinks)
library(SummarizedExperiment)
library(dplyr)

gdcprojects <- getGDCprojects()
# Define the project (Bladder)
project <- "TCGA-BLCA"

# Define the data type and workflow for RNA-Seq gene expression data
query_exp <- GDCquery(
  project = project,
  data.category = 'Transcriptome Profiling',
  experimental.strategy = 'RNA-Seq',
  #workflow.type = 'STAR - Counts',
  data.type = 'Gene Expression Quantification',
  sample.type = 'Primary Tumor',
  access = 'open',
)
# Prepare expression data
GDCdownload(query_exp)

exp_data <- GDCprepare(query_exp)

# Extract count matrix
counts <- assay(exp_data)  # genes × samples

# Filter low-expression genes (e.g., keep genes with counts > 10 in at least 10 samples)
keep_genes <- rowSums(counts > 10) >= 10
filtered_counts <- counts[keep_genes, ]

# Normalize counts to CPM (counts per million)
cpm <- sweep(filtered_counts, 2, colSums(filtered_counts), FUN = "/") * 1e6

# Log-transform CPM (+1 to avoid log(0))
log_cpm <- log2(cpm + 1)

# Transpose so samples are rows, genes are columns
df <- as.data.frame(t(log_cpm))

# Add sample IDs as row names (optional)
rownames(df) <- colData(exp_data)$barcode

# Write to CSV
write.csv(df, file = "TCGA_BLCA_logCPM.csv", row.names = TRUE)


query_suppl <- GDCquery(
  project = project,
  data.category = 'Biospecimen',
  data.type = 'Biospecimen Supplement',
  access = 'open',
)

GDCdownload(query_suppl)
suppl_data <- GDCprepare(query_suppl) 
