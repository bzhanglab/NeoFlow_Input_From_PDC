library(tidyverse)

args <- commandArgs(T)
pdc_table_file <- args[1]
mapping_table_file <- args[2]
fusion_link <- args[3]
output_file <- args[4]

pdc_table <- read.delim(pdc_table_file)
colnames(pdc_table) <- c("experiment_id", "mzml_files", "mzml_links")
mapping_table <- read.delim(mapping_table_file)

output_data <- left_join(mapping_table, pdc_table, by="experiment_id")
output_data$experiment_id <- NULL
output_data$fusion <- paste(fusion_link, output_data$sample, "_T/fusions.tsv", sep="")
output_data$sample <- paste(output_data$experiment, output_data$sample, sep="_")

write.table(output_data, output_file, quote = F, row.names = F, sep="\t")
