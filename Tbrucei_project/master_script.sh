#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --job-name=MasterScript
#SBATCH --output=./logs/out/master-%x-%j.out
#SBATCH --error=./logs/err/master-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxbk2@nottingham.ac.uk

source $HOME/.bash_profile

conda activate python

outputdir=./output/

#extracting user input filename and output directory
defs_fileloc=grep -v "^File Location:" ./defs
defs_directory=grep -v "^Output Location:" ./defs

#if file location in defs file does not exist, check if INSERT_YOUR_FILES_HERE is empty. 
#If no, set file location to INSERT_YOUR_FILES_HERE. If yes, end
if ! [ -f ./$defs_fileloc]; then
	echo "File location does not exist"
	if find ./INSERT_YOUR_FILES_HERE -mindepth 1 -maxdepth 1 | read; then
		filelocation=./INSERT_YOUR_FILES_HERE
		echo "INSERT_YOUR_FILES_HERE input folder selected"
	else
		echo "Error: No directory entered and INSERT_YOUR_FILES_HERE directory empty. Ending the process"
		end
	fi
else
	echo "File location does exist"
	filelocation=./defs_fileloc
fi
	
#test if output directory exists
if ! [ -d ./$defs_directory]; then
	echo "Warning: Directory does not exist. Outputting to default"
	mkdir -p ./outputs
else
	outputdir=$defs_directory
fi

#QC on files


#Trimming files


conda deactivate python

exit