#!/bin/bash

vcfs_dir=$1
info_tags_list=$2
out_file=$3

module load bcftools gcc/9.2.0

# usage example:
# bash vcfs_to_table.sh data/gnomad/genome_vcfs gnomad.genome.fields data/gnomad/gnomad.genomes.annotations.tab

# rename INFO tags in case they contain any forbidden characters
new_info_tags_list=$info_tags_list.new
sed 's/[-_]//g' $info_tags_list > $new_info_tags_list
paste -d " " $info_tags_list $new_info_tags_list > $info_tags_list.rename
sed -i 's/^/INFO\//' $info_tags_list.rename
for vcf in $vcfs_dir/*.vcf.gz
do
    echo "Retagging $vcf"
    bcftools annotate -o "${vcf%.gz}.retagged.gz" --rename-annots $info_tags_list.rename $vcf
done

# make annotations table
ls -d $vcfs_dir/*.vcf.retagged.gz > $vcfs_dir/vcfs.list
info_tags_str=$(sed -e 's/^/\\t%/' ${info_tags_list}.new | paste -sd "")
echo $info_tags_str
bcftools query -o $out_file -f "%CHROM\t%POS\t%REF\t%ALT${info_tags_str}\n" --vcf-list $vcfs_dir/vcfs.list

# add header (column names)
header_tags=$(sed -e 's/^/\\t/' ${info_tags_list} | paste -sd "")
header_str="CHROM\tPOS\tREF\tALT${header_tags}"
sed -i "1s/^/${header_str}\n/" $out_file