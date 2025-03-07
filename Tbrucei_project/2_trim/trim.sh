#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50G
#SBATCH --time=04:00:00
#SBATCH --job-name=trimming 
#SBATCH --output=./logs/trim/%j-%x.out
#SBATCH --error=./logs/trim/%j-%x.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxsh12@nottingham.ac.uk

source $HOME/.bash_profile

echo "Running trim"

# List of files to process 
#FILES=(
#    "Human1.fastq.gz"
#    "Human2.fastq.gz"
#    "Human3.fastq.gz"
#    "Human4.fastq.gz"
#    "Human5.fastq.gz"
#    "Rat1.fastq.gz"
#    "Rat2.fastq.gz"
#    "Rat3.fastq.gz"
#    "Rat4.fastq.gz"  
#    "Rat5.fastq.gz"
#)

FILES=ls *.fastq.gz

mkdir -p $outputdir/trim

# Run Trim Galore on all samples i have used for so we can keep the code clean  
for FILE in "$filelocation"/*.fastq.gz; do
    trim_galore --fastqc --quality 28  --output_dir $outputdir/trim "$FILE"
done

#for FILE in "${FILES[@]}"; do
#    trim_galore --fastqc --quality 28  --output_dir $OUTPUT_DIR "$filelocation/$FILE"
#done


