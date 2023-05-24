#! /bin/bash
  
#
#SBATCH --job-name=fasconcat
#SBATCH -o slurm-%j.out  # %j = job ID
#SBATCH --ntasks-per-node=40
#SBATCH --nodes=1
#SBATCH --time=1:00:00
#SBATCH -p gpu-long

perl ./FASconCAT-G_v1.05.pl -s #this only ran for 1718.25 seconds or 30 minutes. This needs to be run from within your /fasta and FASconCAT folder. 
