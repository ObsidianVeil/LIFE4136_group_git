#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=02:00:00
#SBATCH --job-name=fastqc_analysis 
#SBATCH --output=./logs/FastQC/%j-%x.out
#SBATCH --error=./logs/FastQC/%j-%n.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxsh12@nottingham.ac.uk

source $HOME/.bash_profile

#Make 
mkdir -p $outputdir/FastQC

# Run FastQC on all FASTQ files
fastqc $filelocation/*.fastq.gz --outdir=$outputdir/FastQC --threads 4

