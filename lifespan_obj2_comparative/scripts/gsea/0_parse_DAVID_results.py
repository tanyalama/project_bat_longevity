import pandas as pd

# Read geneSymbol table
geneSymbol_df = pd.read_csv('geneloss_geneSymbol.csv')

# Read david table
david_df = pd.read_csv('geneloss_david.csv')

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
                                     'Gene Name': 'NA',
                                     'ENTREZ_GENE_SUMMARY': 'NA',
                                     'DISGENET': 'NA',
                                     'GOTERM_BP_DIRECT': 'NA',
                                     'GOTERM_CC_DIRECT': 'NA',
                                     'GOTERM_MF_DIRECT': 'NA',
                                     'KEGG_PATHWAY': 'NA',
                                     'KEGG_REACTOME_PATHWAY': 'NA'}

# Create a new DataFrame with merged data
merged_df = pd.DataFrame.from_dict(gene_mapping, orient='index')

# Reorder the columns
merged_df = merged_df[['Gene Name', 'ENTREZ_GENE_SUMMARY', 'GOTERM_BP_DIRECT', 'GOTERM_CC_DIRECT', 'GOTERM_MF_DIRECT', 'KEGG_PATHWAY', 'KEGG_REACTOME_PATHWAY', 'DISGENET']]

# Combine geneSymbol table with merged data
final_df = pd.merge(geneSymbol_df, merged_df, left_on='geneSymbol', right_index=True, how='left')

# Save the final result to a new CSV file
final_df.to_csv('david_parsed_table.csv', index=False)

