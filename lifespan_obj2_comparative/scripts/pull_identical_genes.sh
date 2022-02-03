#! /bin/bash
  
#
#SBATCH --job-name=identical_genes
#SBATCH --output=out_identical_genes.txt
#SBATCH --ntasks-per-node=40
#SBATCH --nodes=1
#SBATCH --time=8:00:00
#SBATCH -p gpu

#individuals_array=(ENST00000229135.IFNG   ENST00000297439.DEFB1   ENST00000367739.IFNGR1  ENST00000683941.IFNAR2)

for i in $(cat ./identical_genes.txt) #"${individuals_array[@]}"
do
cp -r ~/project_bat1k_longevity/data/alignments/bat_alignment_2021.12.07/rhiSin_hipLar_comparison/${i} ./${i}

done
