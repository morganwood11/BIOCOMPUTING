#!/bin/bash
#SBATCH --job-name=assignment_07
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00
#SBATCH --mem=120G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=mrwood01@wm.edu
#SBATCH -o /sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/assignment_07_%j.out
#SBATCH -e /sciclone/home/mrwood01/BIOCOMPUTING/assignments/assignment_07/output/assignment_07_%j.err

################SETUP##################
set -euo pipefail

#locate directory where job was submitted from
cd $SLURM_SUBMIT_DIR

#load programs needed
export PATH=$PATH:/sciclone/home/mrwood01/programs
export PATH=$PATH:/sciclone/home/mrwood01/programs/fastp
export PATH=$PATH:/sciclone/home/mrwood01/programs/datasets
export PATH=$PATH:/sciclone/home/mrwood01/programs/sratoolkit.3.2.1-ubuntu64/bin
module load miniforge3
source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"
conda activate bbmap-env

#run scripts
bash ./scripts/01_download_data.sh
bash ./scripts/02_clean_reads.sh
bash ./scripts/03_map_reads.sh

conda deactivate
