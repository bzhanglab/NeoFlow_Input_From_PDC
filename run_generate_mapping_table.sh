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
Rscript prepare_mapping.R /data/kail/2020_11_neoflow2/neoflow2/PGET_data/experiment_design_pdc/PDC_study_experimental_BRCA.csv /data/kail/2020_11_neoflow2/neoflow2/PGET_data/wxs_gdc_manifest/CPTAC2-WXS_bam-gdc_manifest.2020-12-18.metadata.files_breast.txt /data/PGET_data_freeze_v1.0/data_freeze_v1.0/BRCA/CPTAC2_BRCA_Tumor_CaseList.txt ./BRCA_pre_mapping_table.txt

###Input:
###1. Mzml link file downloaded from PDC website
###Output
###1. Processed MZml link files
Rscript process_gdc_table.R ./PDC_file_manifest_03262021_130720.csv ./PDC_file_manifest_processed_table.txt

###Input
###1. Processed MZml link files from second step
###2. Pre-mapping table from first step
###3. Fusion results link
###4. Data avalible table
###5. Add "_" or not
###Output
###1. Final mapping table
Rscript generate_mapping_table.R ./PDC_file_manifest_processed_table.txt ./BRCA_pre_mapping_table.txt fusion/ /data/PGET_data_freeze_v1.0/data_available_table_v1.0/BRCA_confirmatory-data-availability.txt ./BRCA_mapping_table.txt F
