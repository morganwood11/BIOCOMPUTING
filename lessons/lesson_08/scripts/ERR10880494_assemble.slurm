#!/bin/bash
#SBATCH --job-name=ERR10880494_Assembly
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=mrwood01@wm.edu               # change this!
#SBATCH -o /sciclone/home/mrwood01/BIOCOMPUTING/lessons/lesson_08/logs/ERR10880494_03assemble_%j.out # change this!
#SBATCH -e /sciclone/home/mrwood01/BIOCOMPUTING/lessons/lesson_08/logs/ERR10880494_03assemble_%j.err # change this!

set -euo pipefail

SCR_DIR="${HOME}/scr10"
PROJECT_DIR="${SCR_DIR}/BIOCOMPUTING/lessons/lesson_08"
DB_DIR="${SCR_DIR}/database"
DL_DIR="${PROJECT_DIR}/data/raw"
SRA_DIR="${SCR_DIR}/SRA"
CONTIG_DIR="${PROJECT_DIR}/contigs"

mkdir -p $CONTIG_DIR

for fwd in ${DL_DIR}/*ERR10880494*1_qc.fastq.gz
do

#derive input and output variables
rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
filename=$(basename $fwd)
samplename=$(echo ${filename%%_*})
outdir=$(echo ${CONTIG_DIR}/${samplename})

#run spades with mostly default options
spades.py -1 $fwd -2 $rev -o $outdir -t 20 --meta

done
