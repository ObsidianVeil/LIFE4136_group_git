#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=02:00:00
#SBATCH --job-name=fastqc_analysis 
#SBATCH --output=/share/BioinfMSc/Bill_resources/Tbrucei/fastq/Group1/QC/analysis.out
#SBATCH --error=/share/BioinfMSc/Bill_resources/Tbrucei/fastq/Group1/QC/analysis.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxbk2@nottingham.ac.uk

source $HOME/.bash_profile

conda activate python #fastqc package was installed in the environment python 

# Define input and output directories
INPUT_DIR="/share/BioinfMSc/Bill_resources/Tbrucei/fastq/Group1/rawdata"
OUTPUT_DIR="/share/BioinfMSc/Bill_resources/Tbrucei/fastq/Group1/QC"

# Create output directory if it does not exist
mkdir -p $OUTPUT_DIR

# Run FastQC on all FASTQ files
fastqc ${INPUT_DIR}/*.fastq.gz --outdir=${OUTPUT_DIR} --threads 4

conda deactivate 

