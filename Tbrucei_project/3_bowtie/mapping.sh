#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=20:00:00
#SBATCH --job-name=alignment_bowtie2
#SBATCH --output=./logs/bowtie_%j-%x.out
#SBATCH --error=./logs/bowtie_%j-%x.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxsh12@nottingham.ac.uk

source $HOME/.bash_profile
conda activate python

mkdir -p logs

# Define directories
DATA_DIR="/share/BioinfMSc/rotation2/Group1/LIFE4136_group_git/Tbrucei_project/Rat/2_trim"
REF_DIR="/share/BioinfMSc/rotation2/Group1/references/v68"
OUT_DIR="/share/BioinfMSc/rotation2/Group1/LIFE4136_group_git/Tbrucei_project/Rat/3_bowtie/bowtie_output"

# Create output directory if it doesn't exist
mkdir -p $OUT_DIR

# Align each trimmed FASTQ file to the Trypanosoma brucei genome and output gzipped SAM
for fq in $DATA_DIR/*_trimmed.fq.gz; do
    base=$(basename $fq _trimmed.fq.gz)

    echo "Aligning $base to T. brucei genome..."
    bowtie2 -x $REF_DIR/Tbrucei_index -U $fq --threads 8 \
            -S $OUT_DIR/${base}_aligned.sam
	gzip $OUT_DIR/${base}_aligned.sam

done

echo "Mapping completed successfully!"

for sam in $OUT_DIR/*.sam.gz; do
    base=$(basename $sam _aligned.sam.gz)
    gunzip -c $sam | samtools view -bS - | samtools sort -o $OUT_DIR/${base}_aligned_sorted.bam
    samtools index $OUT_DIR/${base}_aligned_sorted.bam
done

echo "Converted sam files to bam files successfully!"

conda deactivate

