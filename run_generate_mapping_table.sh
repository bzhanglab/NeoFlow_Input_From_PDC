#!/bin/sh

############
###ReadMe
###This is the test script for generating mapping table.
############


set -e -x

###Input:
###1. Experiment design file downloaed from PDC website
###2. WXS gdc information got from Yongchao
###3. Case list used in PGET project
###Output:
###1. Pre-mapping table
Rscript prepare_mapping.R /data/kail/2020_11_neoflow2/neoflow2/PGET_data/experiment_design_pdc/PDC_study_experimental_HNSCC.csv /data/kail/2020_11_neoflow2/neoflow2/PGET_data/wxs_gdc_manifest/CPTAC3-WXS_bam-gdc_manifest.2020-10-27.metadata.files_HNSCC.txt /data/PGET_data_freeze_v1.0/data_freeze_v1.0/HNSCC/CPTAC3_HNSCC_Tumor_CaseList.txt ./HNSCC_pre_mapping_table.txt

###Input:
###1. Mzml link file downloaded from PDC website
###Output
###1. Processed MZml link files
Rscript process_gdc_table.R ./PDC_file_manifest_03022021_153834.csv ./PDC_file_manifest_processed_table.txt

###Input
###1. Processed MZml link files from second step
###2. Pre-mapping table from first step
###3. Fusion results link
###Output
###1. Final mapping table
Rscript generate_mapping_table.R ./PDC_file_manifest_processed_table.txt ./HNSCC_pre_mapping_table.txt fusion/ ./HNSCC_mapping_table.txt
