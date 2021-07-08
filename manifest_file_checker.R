library(dplyr)
library(stringr)

para <- commandArgs(TRUE)
print(para)

a <- read.delim(para[1],stringsAsFactors = FALSE,check.names = FALSE)
b <- read.delim(para[2],,stringsAsFactors = FALSE,check.names = FALSE)
fusion_gz <- para[3]
#a <- read.delim("manifest_file_checker_test_data/LUAD_mapping_table.txt",stringsAsFactors = FALSE,check.names = FALSE)
#b <- read.delim("manifest_file_checker_test_data/LUAD-somatic-mutation.maf",stringsAsFactors = FALSE,check.names = FALSE)
#fusion_gz <- "manifest_file_checker_test_data/luad_gene_fusion_2020_12_17.tgz"
cat("Rows in manifest file:",nrow(a),"\n")
sample_names_in_manifest_file <- a$sample
for(i in 1:length(sample_names_in_manifest_file)){
    sample_names_in_manifest_file[i] <- str_replace(a$sample[i],pattern = paste(a$experiment[i],"_",sep = ""),replacement = "")
}
cat("Samples in manifest file:",a$sample %>% unique() %>% length,"\n")
cat("Samples (unique) in manifest file:",unique(sample_names_in_manifest_file) %>% length,"\n")

### check somatic mutation
sample_names_with_somatic_mutations <- b$Tumor_Sample_Barcode %>% unique()
cat("Samples with somatic mutations:",length(sample_names_with_somatic_mutations),"\n")

samples_no_somatic_mutations <- setdiff(sample_names_in_manifest_file,sample_names_with_somatic_mutations)

if(length(samples_no_somatic_mutations) >= 1){
    cat("samples without somatic mutations:",paste(samples_no_somatic_mutations,collapse = ", "))
}else{
    cat("All samples in manifest file have somatic mutations in MAF file!\n")
}

### check gene fusion
if(str_detect(fusion_gz,pattern = "gz$")){
    dir.create("tmp_fusion",recursive = TRUE)
    system(paste("tar xzf ",fusion_gz," -C tmp_fusion"))
    fusion_files <- list.files(path = "tmp_fusion",full.names = TRUE,recursive = TRUE)
    fusion_file_names <- fusion_files %>% sapply(function(x){ 
        y <- str_split(x,pattern = "/") %>% unlist
        res <- y[(length(y)-1):length(y)] %>% paste(collapse = "/")
        return(res)
        })
    
    fusion_file_names_in_manifest <- a$fusion %>% sapply(function(x){ 
        y <- str_split(x,pattern = "/") %>% unlist
        res <- y[(length(y)-1):length(y)] %>% paste(collapse = "/")
        return(res)
    })
    
    samples_no_fusion <- setdiff(fusion_file_names_in_manifest,fusion_file_names)
    if(length(samples_no_fusion) >= 1){
        cat("samples without fusion:",paste(samples_no_fusion,collapse = ", "))
    }else{
        cat("All samples in manifest file have valid fusion files!\n")
    }
    
}else{
    cat("Fusion format is not supported!\n")
}

