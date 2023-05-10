#!/bin/bash

datadir="/n/groups/marks/users/ralph/ClinVar/data"

curl "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/ConceptID_history.txt" -o "${datadir}/ConceptID_history.txt"
curl "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/disease_names" -o "${datadir}/disease_names.txt"
curl "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/gene_condition_source_id" -o "${datadir}/gene_condition_source_id.txt"
curl "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz" -o "${datadir}/variant_summary.txt.gz"
curl "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/submission_summary.txt.gz" -o "${datadir}/submission_summary.txt.gz"
curl "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/organization_summary.txt" -o "${datadir}/organization_summary.txt"
curl "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/gene_specific_summary.txt" -o "${datadir}/gene_specific_summary.txt"
curl "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variation_allele.txt.gz" -o "${datadir}/variation_allele.txt.gz"
curl "https://stringdb-static.org/download/protein.links.full.v11.5/9606.protein.links.full.v11.5.txt.gz" -o "${datadir}/STRING.protein.links.full.txt.gz"
curl "https://stringdb-static.org/download/protein.physical.links.full.v11.5/9606.protein.physical.links.full.v11.5.txt.gz" -o "${datadir}/STRING.protein.physical.full.txt.gz"
curl "https://stringdb-static.org/download/protein.info.v11.5/9606.protein.info.v11.5.txt.gz" -o "${datadir}/9606.protein.info.v11.5.txt.gz"

# unzip
gunzip ${datadir}/submission_summary.txt.gz
gunzip ${datadir}/variant_summary.txt.gz
gunzip ${datadir}/variation_allele.txt.gz
gunzip ${datadir}/STRING.protein.links.full.txt.gz
gunzip ${datadir}/STRING.protein.physical.full.txt.gz
gunzip ${datadir}/9606.protein.info.v11.5.txt.gz