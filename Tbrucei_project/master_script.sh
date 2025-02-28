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

#extracting user input filename and output directory
defs_filename=grep -v "^Filename:" ./defs
defs_directory=grep -v "^Output Location:" ./defs

#test if filename exists
if ! [ -f ./$defs_filename]; 
then
	echo "Filename does not exist"
	end
else
	filename=./defs_filename
	
#test if output directory exists
if ! [ -d ./$defs_directory]; then
	echo "Warning: Directory does not exist. Outputting to default"

conda activate python

