#!/usr/bin/env python

#4_fetch_cancer_DO.py uses the Disease Ontology API to search for gene-disease associations specific to a disease ontology ID (e.g., DOID:162 which is "cancer"). Outputs a table called doid_cancer.csv

import csv
import requests
from pydantic import BaseModel

class Gene:
    def __init__(self, symbol):
        self.symbol = symbol

class DiseaseOntologyTerm(BaseModel):
    id: str
    name: str
    definition: str

def get_cancer_disease_ontology_terms(gene_symbol):
    url = f"http://www.disease-ontology.org/api/metadata/DOID:162/genes/{gene_symbol}"
    response = requests.get(url)
    data = response.json()
    disease_terms = []
    for term_data in data["terms"]:
        disease_term = DiseaseOntologyTerm(
            id=term_data["id"],
            name=term_data["name"],
            definition=term_data["definition"],
        )
        disease_terms.append(disease_term)
    return disease_terms

def main():
    genes = []
    with open("geneSymbol.csv", "r") as file:
        for line in file:
            symbol = line.strip()
            gene = Gene(symbol)
            genes.append(gene)

    results = []
    for gene in genes:
        disease_terms = get_cancer_disease_ontology_terms(gene.symbol)
        disease_names = "; ".join(term.name for term in disease_terms)
        result = [gene.symbol, disease_names]
        results.append(result)

    with open("doid_cancer.csv", "w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["geneSymbol", "disease_name"])
        writer.writerows(results)

if __name__ == "__main__":
    main()
