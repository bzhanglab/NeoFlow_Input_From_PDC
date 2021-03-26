library(tidyverse)

args <- commandArgs(T)

origianl_gdc_file <- args[1]
processed_file <- args[2]
origianl_gdc_table <- read.delim(origianl_gdc_file, sep=",") %>% select(File.Name, File.Download.Link, Run.Metadata.ID)
colnames(origianl_gdc_table) <- c("File_name", "Link", "experiment_id")
origianl_gdc_table_con <- origianl_gdc_table %>%
  group_by(experiment_id) %>%
  dplyr::summarize(Filenames = stringr::str_c(File_name, collapse = ";"), Links = stringr::str_c(Link, collapse = ";"))

write.table(origianl_gdc_table_con, processed_file, quote=F, row.names = F, sep="\t")

