#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=23:00:00
#SBATCH --job-name=htseq_analysis
#SBATCH --output=/share/BioinfMSc/rotation2/Group1/htseq/htseq_analysis.out
#SBATCH --error=/share/BioinfMSc/rotation2/Group1/htseq/htseq_analysis.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxbk2@nottingham.ac.uk


source $HOME/.bash_profile
conda activate python 

# Define paths
DATA_DIR="/share/BioinfMSc/rotation2/Group1/alignment/bowtie"
REF_DIR="/share/BioinfMSc/rotation2/Group1/references/v68"
OUT_DIR="/share/BioinfMSc/rotation2/Group1/htseq"

# Create output directory if not exists
mkdir -p $OUT_DIR

# Reference files
GFF_FILE="$REF_DIR/Tbrucei_TREU927_annotation.gff"
GENOME_FA="$REF_DIR/Tbrucei_TREU927_reference.fa"

# Loop over BAM files for analysis
for BAM_FILE in $DATA_DIR/*_aligned_sorted.bam; do
    SAMPLE_NAME=$(basename $BAM_FILE _aligned_sorted.bam)

    echo "Processing $SAMPLE_NAME..."

    # 1:Check for gDNA Contamination (Exonic vs. Intronic Reads)
    htseq-count -f bam --order=pos --stranded=no --type=exon --idattr=gene_id $BAM_FILE $GFF_FILE > $OUT_DIR/${SAMPLE_NAME}_exon_counts.txt

    htseq-count -f bam --order=pos --stranded=no --type=intron --idattr=gene_id $BAM_FILE $GFF_FILE > $OUT_DIR/${SAMPLE_NAME}_intron_counts.txt

    # 2:Determine Strandedness (Stranded vs. Non-Stranded)
    htseq-count -f bam --order=pos --stranded=yes --type=exon --idattr=gene_id $BAM_FILE $GFF_FILE > $OUT_DIR/${SAMPLE_NAME}_stranded_counts.txt

    htseq-count -f bam --order=pos --stranded=reverse --type=exon --idattr=gene_id $BAM_FILE $GFF_FILE > $OUT_DIR/${SAMPLE_NAME}_reverse_stranded_counts.txt

    # 3:Generate Read Counts for Differential Expression Analysis
    htseq-count -f bam --order=pos --stranded=no --type=exon --idattr=gene_id $BAM_FILE $GFF_FILE > $OUT_DIR/${SAMPLE_NAME}_gene_counts.txt

    # 4:Assess Sequencing Depth per Gene
    awk '{sum+=$2} END {print "Total Reads:", sum, "Genes Counted:", NR, "Average Reads per Gene:", sum/NR}' $OUT_DIR/${SAMPLE_NAME}_gene_counts.txt > $OUT_DIR/${SAMPLE_NAME}_depth_summary.txt

    echo "Finished processing $SAMPLE_NAME"
done

conda deactivate


