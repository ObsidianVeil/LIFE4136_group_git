#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --job-name=star_alignment
#SBATCH --output=/share/BioinfMSc/rotation2/Group1/alignment_star/alignment.out
#SBATCH --error=/share/BioinfMSc/rotation2/Group1/alignment_star/alignment.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxbk2@nottingham.ac.uk

source $HOME/.bash_profile
conda activate python

# Define directories
DATA_DIR="/share/BioinfMSc/rotation2/Group1/data_trim"
OUT_DIR="/share/BioinfMSc/rotation2/Group1/alignment_star"
HUMAN_INDEX="/share/BioinfMSc/rotation2/Group1/references/human_index"
RAT_INDEX="/share/BioinfMSc/rotation2/Group1/references/rat_index"
TRYPANOSOMA_INDEX="/share/BioinfMSc/rotation2/Group1/references/trypanosoma_index"

# Create output directory if it doesn't exist
mkdir -p $OUT_DIR

# Function to run STAR alignment
run_star_alignment() {
    local sample_name=$1
    local index_dir=$2
    local input_file=$3
    local output_prefix=$4

    STAR --genomeDir $index_dir \
         --readFilesIn $input_file \
         --readFilesCommand zcat \
         --runThreadN 16 \
         --outFileNamePrefix $output_prefix \
         --outSAMtype BAM SortedByCoordinate \
         --quantMode TranscriptomeSAM GeneCounts
}


# Align Human samples
for sample in Human1 Human2 Human3 Human4 Human5; do
    input_file="${DATA_DIR}/${sample}_trimmed.fq.gz"
    output_prefix="${OUT_DIR}/${sample}_"
    run_star_alignment $sample $HUMAN_INDEX $input_file $output_prefix
done

# Align Rat samples
for sample in Rat1 Rat2 Rat3 Rat4 Rat5; do
    input_file="${DATA_DIR}/${sample}_trimmed.fq.gz"
    output_prefix="${OUT_DIR}/${sample}_"
    run_star_alignment $sample $RAT_INDEX $input_file $output_prefix
done

# Align Trypanosoma brucei samples
for sample in Tryp1 Tryp2 Tryp3; do
    input_file="${DATA_DIR}/${sample}_trimmed.fq.gz"
    output_prefix="${OUT_DIR}/${sample}_"
    run_star_alignment $sample $TRYPANOSOMA_INDEX $input_file $output_prefix
done

conda deactivate

