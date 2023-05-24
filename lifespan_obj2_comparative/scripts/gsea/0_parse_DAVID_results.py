import pandas as pd

# Read geneSymbol table
geneSymbol_df = pd.read_csv('geneSymbol.csv')

# Read david table
david_df = pd.read_csv('david.csv')

# Create a dictionary to store the longest matching gene for each gene in geneSymbol
gene_mapping = {}

# Iterate over geneSymbol table
for gene_symbol in geneSymbol_df['geneSymbol']:
    # Find matching genes in david table
    matching_genes = david_df[david_df['GeneSymbol'] == gene_symbol]

    if len(matching_genes) > 0:
        # Find the longest matching gene
        longest_gene = matching_genes.loc[matching_genes['GeneSymbol'].str.len().idxmax(), :'KEGG_REACTOME_PATHWAY'].to_dict()
        gene_mapping[gene_symbol] = longest_gene
    else:
        # If no match found, set 'Not Available' for all columns
        gene_mapping[gene_symbol] = {'GeneSymbol': gene_symbol,
                                     'Gene Name': 'Not Available',
                                     'GOTERM_BP_DIRECT': 'Not Available',
                                     'GOTERM_CC_DIRECT': 'Not Available',
                                     'GOTERM_MF_DIRECT': 'Not Available',
                                     'KEGG_PATHWAY': 'Not Available',
                                     'KEGG_REACTOME_PATHWAY': 'Not Available'}

# Create a new DataFrame with merged data
merged_df = pd.DataFrame.from_dict(gene_mapping, orient='index')

# Reorder the columns
merged_df = merged_df[['Gene Name', 'GOTERM_BP_DIRECT', 'GOTERM_CC_DIRECT', 'GOTERM_MF_DIRECT', 'KEGG_PATHWAY', 'KEGG_REACTOME_PATHWAY']]

# Combine geneSymbol table with merged data
final_df = pd.merge(geneSymbol_df, merged_df, left_on='geneSymbol', right_index=True, how='left')

# Save the final result to a new CSV file
final_df.to_csv('merged_table.csv', index=False)

