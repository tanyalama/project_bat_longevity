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
    url = f"http://www.disease-ontology.org/api/metadata/DOID:14566/genes/{gene_symbol}"
    try:
        response = requests.get(url)
        response.raise_for_status()  # Check for any HTTP errors
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
    except (requests.exceptions.RequestException, ValueError) as e:
        print(f"Error retrieving disease ontology terms for gene symbol {gene_symbol}: {str(e)}")
        return []

def main():
    genes = []
    with open("ten.txt", "r") as file:
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

    with open("cancer_DO.csv", "w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["geneSymbol", "disease_name"])
        writer.writerows(results)

if __name__ == "__main__":
    main()
