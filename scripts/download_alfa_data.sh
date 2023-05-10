#!/bin/bash

datadir="/n/groups/marks/users/ralph/ClinVar/data"

curl "https://ftp.ncbi.nih.gov/snp/population_frequency/latest_release/supplement/ALFA_20200909020902_clinical.vcf.gz" -o "${datadir}/ALFA_20200909020902_clinical.vcf.gz"
curl "https://ftp.ncbi.nih.gov/snp/population_frequency/latest_release/supplement/ALFA_20200909020902_gwas.vcf.gz" -o "${datadir}/ALFA_20200909020902_gwas.vcf.gz"

gunzip ${datadir}/ALFA_20200909020902_clinical.vcf.gz
gunzip ${datadir}/ALFA_20200909020902_gwas.vcf.gz