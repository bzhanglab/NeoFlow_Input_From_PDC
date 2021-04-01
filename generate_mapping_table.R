library(tidyverse)

args <- commandArgs(T)
pdc_table_file <- args[1]
mapping_table_file <- args[2]
fusion_link <- args[3]
data_ava <- read.delim(args[4], check.names = FALSE)
output_file <- args[5]
add_or <- args[6]

data_ava_ga <- gather(data_ava, sample, value, 2: ncol(data_ava))
data_ava_sp <- spread(data_ava_ga, idx, value) %>%
        filter(WES == "Y", Proteomics == "Y")

data_ava_sp_no_fu <- data_ava_sp %>%
        filter(Gene_fusion == "N")

pdc_table <- read.delim(pdc_table_file)
colnames(pdc_table) <- c("experiment_id", "mzml_files", "mzml_links")
mapping_table <- read.delim(mapping_table_file)

output_data <- left_join(mapping_table, pdc_table, by="experiment_id")
output_data$experiment_id <- NULL
if (add_or == "T"){
	output_data$fusion <- paste(fusion_link, output_data$sample, "_T/fusions.tsv", sep="")
} else {
	output_data$fusion <- paste(fusion_link, output_data$sample, "/fusions.tsv", sep="")
}
output_data <- output_data %>% filter(sample %in% data_ava_sp$sample)
output_data$fusion <- ifelse(output_data$sample %in% data_ava_sp_no_fu$sample, "NA", output_data$fusion)
output_data$sample <- paste(output_data$experiment, output_data$sample, sep="_")

write.table(output_data, output_file, quote = F, row.names = F, sep="\t")
