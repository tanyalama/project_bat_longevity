#!/usr/bin/env python

##1_fetch_gene_info.py retrieves gene descriptions and summaries using the Entrez API

from Bio import Entrez
import csv
import xml.etree.ElementTree as ET


def fetch_gene_info(symbol):
    Entrez.email = 'tlama@smith.edu'  # Enter your email address

    handle = Entrez.esearch(db='gene', term=symbol)
    record = Entrez.read(handle)

    if record['IdList']:
        gene_id = record['IdList'][0]
        handle = Entrez.esummary(db='gene', id=gene_id)
        xml_data = handle.read()
        root = ET.fromstring(xml_data)

        summary = root.find(".//Summary")
        gene_description = root.find(".//Description")
        gene_summary = summary.text if summary is not None else 'Not available'

        if gene_description is not None:
            gene_description = gene_description.text
        else:
            gene_description = 'Not available'
    else:
        gene_description = 'Not available'
        gene_summary = 'Not available'

    return gene_description, gene_summary


def main():
    gene_symbols = []

    with open('geneSymbol.csv', 'r') as file:
        gene_symbols = [line.strip() for line in file]

    gene_info_table = []

    for symbol in gene_symbols:
        description, summary = fetch_gene_info(symbol)
        gene_info_table.append({'Symbol': symbol, 'Description': description, 'Summary': summary})

    # Write the gene info table to a CSV file
    with open('gene_info.csv', 'w', newline='') as csvfile:
        fieldnames = ['Symbol', 'Description', 'Summary']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for gene in gene_info_table:
            writer.writerow(gene)

    print("Gene info table has been written to gene_info.csv.")


if __name__ == '__main__':
    main()
