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

#SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SLURM_SUBMIT_DIR

#echoerr() { cat <<< "$@" 1>&2; }
echoerr() { printf "%s\n" "$*" >&2; }


#export variables
export -f echoerr

#extracting user input filename and output directory
#defs_fastqloc=$(grep "^Fastq.gz File Location:" ./defs.txt | cut -d ":" -f 2- | xargs)
defs_fastqloc=$(awk -F': ' '/^Fastq.gz File Location:/ {print $2}' defs.txt | xargs)
defs_output=$(awk -F': ' '/^Output Location:/ {print $2}' defs.txt | xargs)

#if file location in defs file does not exist, check if INSERT_YOUR_FILES_HERE is empty. 
#If no, set file location to INSERT_YOUR_FILES_HERE. If yes, end

if find ./INSERT_YOUR_FILES_HERE -mindepth 1 -maxdepth 1 | read; then
	filelocation="./INSERT_YOUR_FILES_HERE"
	echo "INSERT_YOUR_FILES_HERE folder selected as input"
	else
		if [ -d "$defs_fastqloc" ]; then
			filelocation="$defs_fastqloc"
			echo "Input file location obtained from defs"
		else 
			echoerr "Error: Invalid directory entered in defs doc and INSERT_YOUR_FILES_HERE directory empty. Ending the process"
			exit 1
		fi
fi
echo "fast.gz files obtained from $filelocation"
export filelocation
	
#If output directory in defs file exists, set as outputdir
#If output directory in defs file does not exist, make output directory and set as output.
if [ -d "$defs_output" ]; then
	outputdir=$defs_output
else
	echo "Warning: error in Output directory from defs document. Outputting to default."
	mkdir -p ./outputs
	outputdir=$(realpath ./outputs)
fi

echo "Output files to $outputdir"
export outputdir

#QC on files


#Trimming files


conda deactivate

exit