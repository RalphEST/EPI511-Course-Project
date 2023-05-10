#!/bin/bash
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --mem=16G
#SBATCH -p short
#SBATCH -t 0-10:00
#SBATCH -o /n/groups/marks/users/ralph/popgen/slurm/%j.out
#SBATCH -e /n/groups/marks/users/ralph/popgen/slurm/%j.err

module load gcc/9.2.0 bcftools

# inputs 
chr_regions=$1
chr_vcf=$2
gnomad_vcf=$3
out_vcf=$4

bcftools isec -n=2 -w1 -o $out_vcf -R $chr_regions $gnomad_vcf $chr_vcf



