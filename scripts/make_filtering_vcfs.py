import pandas as pd
import sys, os
import argparse

def create_parser():
    parser = argparse.ArgumentParser(
        description="Make the per-chromosome filtering VCFs based on a set of ClinVar variant tables."
    )
    parser.add_argument(
        "--mapping_table",
        type=str,
        help= "Path to the table mapping diseases to the location of its variants table"
    )
    parser.add_argument(
        "--vcfs_dir",
        type=str,
        help= "Path to the output VCFs directory"
    )
    parser.add_argument(
        "--regions_dir",
        type=str,
        help= "Path to the output regions directory"
    )
    return parser

chromosomes = [str(c) for c in range(1,23)] + ['X', 'Y', 'M']

def make_filtering_vcf(variants, vcf_file, regions_file):
    df = variants.loc[:, ['Chromosome', 'PositionVCF', 'Ref', 'Alt']]
    df['#CHROM'] = 'chr' + df['Chromosome'].astype(str)
    df['ID'], df['QUAL'], df['FILTER'], df['INFO'] = '.','.','.','.'
    df = (df.rename(columns={'Ref': 'REF', 'Alt': 'ALT', 'PositionVCF': 'POS'})
          .sort_values('POS'))
    
    # make filtering regions
    df[['#CHROM', 'POS']].to_csv(
        regions_file, 
        sep='\t', 
        header=False, 
        index=False
    )
    
    # make filtering vcf
    with open(vcf_file, 'w') as file:
        # write header
        file.writelines("##fileformat=VCFv4.3\n")
        for chrom in chromosomes:
            file.writelines(f"##contig=<ID=chr{chrom}>\n")
        # write table
        df.to_csv(
            file, 
            header=True, 
            index=False, 
            sep='\t', 
            mode='a', 
            columns=[
                '#CHROM', 
                'POS', 
                'ID', 
                'REF', 
                'ALT', 
                'QUAL', 
                'FILTER', 
                'INFO']
        )
    
if __name__ == '__main__':
    parser = create_parser()
    args = parser.parse_args()
    
    table_list = pd.read_csv(args.mapping_table, header=None)[1].tolist()
    all_dis_table = (pd.concat([pd.read_csv(table, low_memory=False, dtype={'Chromosome':'str'}) 
                               for table in table_list])
                     .drop_duplicates())
    all_dis_table = all_dis_table[all_dis_table['PositionVCF'] > 0]
    print(f"Found {len(all_dis_table)} unique variants across all conditions:")
    
    for chrom in chromosomes:
        df = all_dis_table[all_dis_table.Chromosome == chrom]
        print(f"\t{len(df)} variants in chromosome {chrom}")
        if len(df) > 0:
            make_filtering_vcf(
                df, 
                os.path.join(args.vcfs_dir, f"chr{chrom}.variants.vcf"), 
                os.path.join(args.regions_dir, f"chr{chrom}.regions.tab")
            )