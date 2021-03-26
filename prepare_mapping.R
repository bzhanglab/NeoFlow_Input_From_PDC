library(tidyverse)

args <- commandArgs(T)
exp_table_file <- args[1]
bam_file <- args[2]
case_list <- read.delim(args[3], header = F)
output_file <- args[4]

exp_table <- read.delim(exp_table_file, sep=",")
bam_ids <- read.delim(bam_file)

exp_table <- exp_table %>%
  gather("chanel", "sample", 4:ncol(exp_table)) %>%
  filter(str_detect(sample, "Primary Tumor")) %>%
  select(Study.Run.Metadata.Submitter.ID, Plex.Dataset.Name, sample)
colnames(exp_table)[1] <- "experiment_id"
colnames(exp_table)[2] <- "experiment"
exp_table$sample <- str_replace_all(exp_table$sample, "\nPrimary Tumor", "")

bam_ids <- bam_ids %>%
  filter(str_detect(sample_type, "tumor")) %>%
  select(case, UUID)
colnames(bam_ids)[1] <- "sample"

mapping_data <- inner_join(exp_table, bam_ids, by="sample")
colnames(mapping_data)[4] <- "wxs_file_uuid"
#mapping_data$sample <- str_replace_all(mapping_data$sample, "-", ".") 
mapping_data$wxs_file_name <- paste(mapping_data$sample, ".bam", sep="")
mapping_data <- mapping_data[,c(3,2,5,4,1)]
mapping_data <- mapping_data %>% filter(sample %in% case_list$V1)

write.table(mapping_data, output_file, row.names = F, quote=F, sep="\t")
