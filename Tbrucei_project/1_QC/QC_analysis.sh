#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=02:00:00
#SBATCH --job-name=fastqc_analysis 
#SBATCH --output=./FASTQC/logs/%j-%x.out
#SBATCH --error=./FASTQC/logs/%j-%n.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxsh12@nottingham.ac.uk

source $HOME/.bash_profile

conda activate Python #Change Python to the name of the relevant conda environment

filelocation="/share/BioinfMSc/rotation2/Group1/LIFE4136_group_git/Tbrucei_project/Rat/INSERT_FILES_HERE" #set to wherever your input .fastq.gz files are
outputdir="/share/BioinfMSc/rotation2/Group1/LIFE4136_group_git/Tbrucei_project/Rat/1_QC" #set to output location

echo "Running QC analysis"

#Make output directory
mkdir -p $outputdir/FastQC

# Run FastQC on all FASTQ files
fastqc $filelocation/*.fastq.gz --outdir=$outputdir/FastQC --threads 4

