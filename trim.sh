#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50G
#SBATCH --time=04:00:00
#SBATCH --job-name=trimming 
#SBATCH --output=/share/BioinfMSc/Bill_resources/Tbrucei/fastq/Group1/data_trim/trim.out
#SBATCH --error=/share/BioinfMSc/Bill_resources/Tbrucei/fastq/Group1/data_trim/trim.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxbk2@nottingham.ac.uk

source $HOME/.bash_profile

conda activate python 

# Define directories
INPUT_DIR="/share/BioinfMSc/Bill_resources/Tbrucei/fastq/Group1/rawdata"
OUTPUT_DIR="/share/BioinfMSc/Bill_resources/Tbrucei/fastq/Group1/data_trim"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# List of files to process 
FILES=(
    "Human1.fastq.gz"
    "Human2.fastq.gz"
    "Human3.fastq.gz"
    "Human4.fastq.gz"
    "Human5.fastq.gz"
    "Rat1.fastq.gz"
    "Rat2.fastq.gz"
    "Rat3.fastq.gz"
    "Rat4.fastq.gz"  
    "Rat5.fastq.gz"
)

# Run Trim Galore on all samples i have used for so we can keep the code clean  
for FILE in "${FILES[@]}"; do
    trim_galore --fastqc --quality 28  --output_dir $OUTPUT_DIR "$INPUT_DIR/$FILE"
done

conda deactivate

