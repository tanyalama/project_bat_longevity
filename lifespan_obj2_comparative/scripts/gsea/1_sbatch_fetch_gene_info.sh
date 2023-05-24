#!/bin/bash
#SBATCH --job-name=fetch_gene_info
#SBATCH --output=grep_%j.out
#SBATCH --error=grep_%j.err
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=1
#SBATCH --time=23:00:00
#SBATCH -p cpu

# This script submits fetch_gene_info.py. To execute this script you need to run sbatch sbatch_fetch_gene_info.sh

#Load any necessary modules 
#source activate gsea # make sure you have activated this conda environment before submitting

#Run the Python script with no command line arguments
python fetch_gene_info.py
