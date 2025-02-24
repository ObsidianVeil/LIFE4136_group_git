#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --job-name=samtobam
#SBATCH --output=/share/BioinfMSc/rotation2/Group1/alignment/bowtie/samtobam.out
#SBATCH --error=/share/BioinfMSc/rotation2/Group1/alignment/bowtie/samtobam.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxbk2@nottingham.ac.uk

source $HOME/.bash_profile
conda activate python

for sam in /share/BioinfMSc/rotation2/Group1/alignment/bowtie/*.sam.gz; do
    base=$(basename $sam _aligned.sam.gz)
    gunzip -c $sam | samtools view -bS - | samtools sort -o /share/BioinfMSc/rotation2/Group1/alignment/bowtie/${base}_aligned_sorted.bam
    samtools index /share/BioinfMSc/rotation2/Group1/alignment/bowtie/${base}_aligned_sorted.bam
done

conda deactivate

