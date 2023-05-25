#!/usr/bin/env python

#3_format_disease_ontology_disgenet.py reduces this repetitive data in gene_disease_associations.csv and parses a usable and simplified format.

import csv
import ast
import sys

# Increase the field size limit
csv.field_size_limit(sys.maxsize)

def main():
    gene_disease_dict = {}
    with open('gene_disease_associations.csv', 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            gene_symbol = row['Symbol']
            diseases_str = row['Diseases']

            diseases_list = ast.literal_eval(diseases_str)
            disease_names = [disease['disease_name'] for disease in diseases_list]
            gene_id = diseases_list[0]['geneid'] if diseases_list else ''

            if gene_symbol in gene_disease_dict:
                gene_disease_dict[gene_symbol]['disease_names'].extend(disease_names)
            else:
                gene_disease_dict[gene_symbol] = {'gene_id': gene_id, 'disease_names': disease_names}

    # Write the transformed data to a new CSV file
    with open('disgenet_transformed.csv', 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['geneSymbol', 'geneid', 'disease_name'])  # Write the header
        for gene_symbol, data in gene_disease_dict.items():
            gene_id = data['gene_id']
            disease_names = '; '.join(data['disease_names'])
            writer.writerow([gene_symbol, gene_id, disease_names])

if __name__ == '__main__':
    main()
