#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=10:00:00
#SBATCH --job-name=Tbrucei_MasterScript
#SBATCH --output=./logs/out/master-%x-%j.out
#SBATCH --error=./logs/err/master-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxsh12@nottingham.ac.uk

source $HOME/.bash_profile

conda activate python

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR

echoerr() { cat <<< "$@" 1>&2; }

#export variables
export -f echoerr

#extracting user input filename and output directory
defs_fileloc=$(grep "^Fastq.gz File Location:" ./defs.txt | cut -d ":" -f 2-)
defs_directory=$(grep "^Output Location:" ./defs.txt | cut -d ":" -f 2-)

echo $defs_fileloc

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

export -f filelocation
	
#If output directory in defs file exists, set as outputdir
#If output directory in defs file does not exist, make output directory and set as output.
if [ -d ./$defs_directory]; then
	outputdir=$defs_directory
else
	echo "Warning: Output directory from defs document does not exist. Outputting to default."
	mkdir -p ./outputs
	outputdir=./outputs
fi

export -f outputdir

#QC on files


#Trimming files


conda deactivate python

exit