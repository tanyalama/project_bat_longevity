import csv
import requests

def fetch_disease_associations(gene_symbol):
    # Set your DisGeNET account credentials
    email = "tlama@smith.edu"
    password = "JX4MN5d7@QctwHr"

    # Authenticate and obtain an API key
    auth_params = {"email": email, "password": password}
    api_host = "https://www.disgenet.org/api"

    api_key = None
    session = requests.Session()
    try:
        response = session.post(api_host + '/auth/', data=auth_params)
        if response.status_code == 200:
            json_response = response.json()
            api_key = json_response.get("token")
        else:
            print("Authentication failed.")
    except requests.exceptions.RequestException as req_ex:
        print(req_ex)
        print("Something went wrong with the request.")

    if api_key:
        session.headers.update({"Authorization": "Bearer %s" % api_key})

        # Retrieve disease associations for the gene symbol
        response = session.get(api_host + f'/gda/gene/{gene_symbol}')
        if response.status_code == 200:
            associations_list = response.json()
            if associations_list and isinstance(associations_list, list):
                # Extract only the 'geneid' and 'disease_name' fields
                gene_diseases = [{'geneid': assoc['geneid'], 'disease_name': assoc['disease_name']} for assoc in associations_list]
                return gene_diseases
        else:
            print("Failed to retrieve disease associations.")

    if session:
        session.close()

    return []

def main():
    gene_symbols = []

    with open('genes.txt', 'r') as file:
        gene_symbols = [line.strip() for line in file]

    gene_disease_table = []

    for symbol in gene_symbols:
        diseases = fetch_disease_associations(symbol)
        gene_disease_table.append({'Symbol': symbol, 'Diseases': diseases})

    # Write the gene-disease table to a CSV file
    with open('gene_disease_associations.csv', 'w', newline='') as csvfile:
        fieldnames = ['Symbol', 'Diseases']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for gene in gene_disease_table:
            writer.writerow(gene)

    print("Gene-disease associations have been written to gene_disease_associations.csv.")


if __name__ == '__main__':
    main()
