#! /bin/bash

#
#SBATCH --job-name=drop_rhiSin
#SBATCH --output=drop_rhiSin.txt
#SBATCH --ntasks-per-node=40
#SBATCH --nodes=1
#SBATCH --time=2:00:00
#SBATCH -p gpu

for i in $(cat ./identical_genes.txt) 
do
sed -e '/>HLrhiSin2/,+1d' ./data/${i}/${i}.cleanLb_hmm_manual.fasta > ./final_fastas/${i}.final.fasta
done
