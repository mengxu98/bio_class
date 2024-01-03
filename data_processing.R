# load libraries
library(cowplot)
library(data.table)
library(dplyr)
library(ggExtra)
library(ggplot2)
library(gridExtra)
library(grid)
library(GSVA)
library(harmony)
library(knitr)
library(magrittr)
library(markdown)
library(Matrix)
library(NNLM)
library(patchwork)
library(pheatmap)
library(progeny)
library(reshape2)
library(reticulate)
library(readr)
library(readxl)
library(stringr)
library(scds)
library(sctransform)
library(Seurat)
library(SingleCellExperiment)
library(SoupX)
library(tidyverse)
library(tidyr)
library(viridis)

path <- "/media/mengxu/backup/bio_class/"
source(paste0(path, "R/cnvFunction.R"))
source(paste0(path, "R/scAnnotation.R"))
source(paste0(path, "R/scCombination.R"))
source(paste0(path, "R/scStatistics.R"))
source(paste0(path, "R/utils.R"))

samples <- list.dirs(
  paste0(
    path, "bio_class_data/cellranger"
  ),
  full.names = FALSE,
  recursive = FALSE
)

for (i in seq_along(samples)) {
  data_path <- paste0(path, "bio_class_data/cellranger/", samples[i])
  save_path <- paste(path, "results/", samples[i], sep = "")
  if (!dir.exists(save_path)) {
    dir.create(save_path)
  }

  # Run scStatistics
  stat_results <- runScStatistics(
    dataPath = data_path,
    savePath = save_path,
    sampleName = samples[i],
    authorName = "meng"
  )

  # Run scAnnotation
  anno_results <- runScAnnotation(
    dataPath = data_path,
    statPath = save_path,
    savePath = save_path,
    authorName = "mengxu",
    sampleName = samples[i],
    geneSet.method = "GSVA", #  "average" or "GSVA"
    bool.runMalignancy = FALSE
  )
}

# The paths of all sample's "runScAnnotation" results
single_save_paths <- c()
for (i in seq_along(samples)) {
  single_save_paths <- c(
    single_save_paths,
    paste0(path, "results/", samples[i])
  )
}

# Run scCombination
comb_results <- runScCombination(
  single.savePaths = single_save_paths,
  sampleNames = samples,
  savePath = paste0(path, "results/Combination"),
  combName = "brain",
  authorName = "mengxu",
  comb.method = "SeuratMNN", # Integration methods ("NormalMNN", "SeuratMNN", "Harmony", "Raw", "Regression", "LIGER")
  bool.runMalignancy = FALSE
)

#
plot_list <- list()
clusters <- unique(markers$cluster)
for (i in seq_along(clusters)) {
  deg <- markers[markers$cluster == clusters[i], ]
  ## 获取上下调基因
  gene_up=rownames(deg[deg$avg_log2FC > 0,])
  gene_down=rownames(deg[deg$avg_log2FC < 0,])
  ## 把SYMBOL改为ENTREZID
  library(org.Hs.eg.db)
  gene_up=as.character(na.omit(AnnotationDbi::select(org.Hs.eg.db,
                                                     keys = gene_up,
                                                     columns = 'ENTREZID',
                                                     keytype = 'SYMBOL')[,2]))
  gene_down=as.character(na.omit(AnnotationDbi::select(org.Hs.eg.db,
                                                       keys = gene_down,
                                                       columns = 'ENTREZID',
                                                       keytype = 'SYMBOL')[,2]))
  library(clusterProfiler)
  ## 以上调基因为例，下调基因同理
  ## KEGG

  gene_up <- unique(gene_up)
  go <- enrichGO(gene_up,
           OrgDb = org.Hs.eg.db)
  plot_list[[i]] <- dotplot(go,title = clusters[i])
}
plot_list[[1]]
plot_list[[2]]
plot_list[[3]]
plot_list[[4]]
plot_list[[5]]
plot_list[[6]]
