import pandas as pd
import sys, os

path = sys.argv[1]
dirname = os.path.dirname(os.path.abspath(path))

vsum = pd.read_table(path, 
                     sep='\t', 
                     low_memory=False, 
                     na_values='-')\
        .rename(columns={
            '#AlleleID': 'AlleleID', 
            'ReferenceAlleleVCF': 'Ref',
            'AlternateAlleleVCF': 'Alt'
        }).drop(columns=['ReferenceAllele', 'AlternateAllele'])\
        .astype({
            'Type': 'category',
            'GeneID': 'category',
            'GeneSymbol': 'category',
            'HGNC_ID': 'category',
            'ClinicalSignificance': 'category',
            'ClinSigSimple': 'byte',
            'Origin': 'category',
            'OriginSimple': 'category',
            'Assembly': 'category',
            'ChromosomeAccession': 'category',
            'Chromosome': 'category',
            'Cytogenetic': 'category',
            'ReviewStatus': 'category',
            'NumberSubmitters': 'byte',
            'Guidelines': 'category',
            'SubmitterCategories': 'byte',
            'Ref': 'category',
            'Alt': 'category'
        })
vsum['TestedInGTR'] = vsum['TestedInGTR'].replace({'Y':1, 'N':0}).astype('byte')
vsum['LastEvaluated'] = pd.to_datetime(vsum['LastEvaluated'])

vsum[vsum['Assembly']=='GRCh38'].to_parquet(os.path.join(dirname, 'variant_summary_GRCh38.parquet'))
vsum[vsum['Assembly']=='GRCh37'].to_parquet(os.path.join(dirname, 'variant_summary_GRCh37.parquet'))

