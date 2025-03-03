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
#SBATCH --mail-user=mbxsh12@nottingham.ac.uk

source $HOME/.bash_profile

conda activate python

echoerr() { cat <<< "$@" 1>&2; }
outputdir=./output/

#export variables
export echoerr

#extracting user input filename and output directory
defs_fileloc=$(grep "^File Location:" ./defs | cut -d ":" -f 2-)
defs_directory=$(grep "^Output Location:" ./defs | cut -d ":" -f 2-)

#if file location in defs file does not exist, check if INSERT_YOUR_FILES_HERE is empty. 
#If no, set file location to INSERT_YOUR_FILES_HERE. If yes, end

if find ./INSERT_YOUR_FILES_HERE -mindepth 1 -maxdepth 1 | read; then
	filelocation=./INSERT_YOUR_FILES_HERE
	echo "INSERT_YOUR_FILES_HERE folder selected as input"
	else
		if ! [ -f ./$defs_fileloc]; then
			filelocation=./$defs_fileloc
			echo "Input file location obtained from defs"
		else 
			echoerr("Error: No directory entered in defs doc and INSERT_YOUR_FILES_HERE directory empty. Ending the process")
			exit 1
		fi
fi

	
#test if output directory exists
if ! [ -d ./$defs_directory]; then
	echo "Warning: Output directory from defs document does not exist. Outputting to default."
	mkdir -p ./outputs
else
	outputdir=$defs_directory
fi

#QC on files


#Trimming files


conda deactivate python

exit