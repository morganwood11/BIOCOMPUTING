#!/bin/bash
set -ueo pipefail

module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh
mamba create -yn flye-env -c bioconda -c conda-forge flye=2.9.6
conda activate flye-env
flye -v
conda env export --no-builds > flye-env.yml
deactivate flye-env
