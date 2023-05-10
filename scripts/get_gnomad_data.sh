#!/bin/bash

module load gcc/9.2.0 bcftools

# inputs
diseases_table=$1
output_dir=$2

# making directories
filter_vcfs=$output_dir/filter_vcfs
filter_regions=$output_dir/filter_regions
genomes_vcfs=$output_dir/genomes_vcfs
exomes_vcfs=$output_dir/exomes_vcfs

mkdir -p $output_dir
mkdir -p $filter_vcfs
mkdir -p $filter_regions
mkdir -p $genomes_vcfs
mkdir -p $exomes_vcfs

# # create filtering VCFs
# echo "Creating per-chromosome filter VCFs"
# make_filtering_vcfs=/n/groups/marks/users/ralph/popgen/scripts/make_filtering_vcfs.py
# python $make_filtering_vcfs --mapping_table $diseases_table\
#                                 --vcfs_dir $filter_vcfs\
#                                 --regions_dir $filter_regions

# echo "Bgzipping and indexing the filter VCFs"
# for vcf in $filter_vcfs/*
# do
#     bcftools convert --threads 12 -o $vcf.gz -O z $vcf
#     bcftools index --threads 12 $vcf.gz
# done

# filter gnomad genomes and exomes VCFs
intersect_vcfs=/n/groups/marks/users/ralph/popgen/scripts/intersect_vcfs.sh

for chr in {1..22} X Y
do
    echo "Filtering chromosome $chr ..."
    chr_regions=$filter_regions/chr$chr.regions.tab
    chr_vcf=$filter_vcfs/chr$chr.variants.vcf.gz
    gnomad_genomes=/n/shared_db/gnomad/3.1/genomes/gnomad.genomes.v3.1.sites.chr$chr.vcf.bgz
    gnomad_exomes=/n/shared_db/gnomad/2.1.1_liftover_grch38/exomes/gnomad.exomes.r2.1.1.sites.$chr.liftover_grch38.vcf.bgz
    out_genomes_vcf=$genomes_vcfs/gnomad.genomes.search.chr$chr.vcf.gz
    out_exomes_vcf=$exomes_vcfs/gnomad.exomes.search.chr$chr.vcf.gz

    # if chromosome file exists, find the VCF intersections
    if [ -f $chr_vcf ]; then
        sbatch $intersect_vcfs $chr_regions $chr_vcf $gnomad_genomes $out_genomes_vcf
        sbatch $intersect_vcfs $chr_regions $chr_vcf $gnomad_exomes $out_exomes_vcf
    fi
done




