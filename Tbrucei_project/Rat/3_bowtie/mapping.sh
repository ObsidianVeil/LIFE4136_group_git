#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=20:00:00
#SBATCH --job-name=alignment_bowtie2
#SBATCH --output=/share/BioinfMSc/rotation2/Group1/alignment/bowtie/mapping.out
#SBATCH --error=/share/BioinfMSc/rotation2/Group1/alignment/bowtie/mapping.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxbk2@nottingham.ac.uk

source $HOME/.bash_profile
conda activate python

# Define directories
DATA_DIR="/share/BioinfMSc/rotation2/Group1/data_trim"
REF_DIR="/share/BioinfMSc/rotation2/Group1/references/v68"
OUT_DIR="/share/BioinfMSc/rotation2/Group1/alignment/bowtie"

# Create output directory if it doesn't exist
mkdir -p $OUT_DIR

# Align each trimmed FASTQ file to the Trypanosoma brucei genome and output gzipped SAM
for fq in $DATA_DIR/*_trimmed.fq.gz; do
    base=$(basename $fq _trimmed.fq.gz)

    echo "Aligning $base to T. brucei genome..."
    bowtie2 -x $REF_DIR/Tbrucei_index -U $fq --threads 8 \
            -S >(gzip > $OUT_DIR/${base}_aligned.sam.gz)

done

echo "Mapping completed successfully!"

conda deactivate

