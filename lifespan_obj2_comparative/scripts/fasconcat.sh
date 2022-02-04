#! /bin/bash
  
#
#SBATCH --job-name=fasconcat
#SBATCH -o slurm-%j.out  # %j = job ID
#SBATCH --ntasks-per-node=40
#SBATCH --nodes=1
#SBATCH --time=96:00:00
#SBATCH -p gpu-long

perl ./FASconCAT-G_v1.05.pl -s ##this will produce a supermatrix and all info; you can add -n or -p if you need other inputs
