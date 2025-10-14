#!/bin/bash
set -ueo pipefail

source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

conda activate flye-env

mkdir -p ./assemblies/assembly_conda

flye \
  --nano-hq ./data/SRR33939694.fastq \
  --genome-size 200k \
  --out-dir ./assemblies/assembly_conda \
  --threads 6 | tee ./assemblies/assembly_conda/flye.log

mv ./assemblies/assembly_conda/assembly.fasta ./assemblies/assembly_conda/conda_assembly.fasta
mv ./assemblies/assembly_conda/flye.log ./assemblies/assembly_conda/conda_flye.log

mkdir -p ./tmp_keep
mv ./assemblies/assembly_conda/conda_assembly.fasta ./tmp_keep/
mv ./assemblies/assembly_conda/conda_flye.log ./tmp_keep/
rm -rf ./assemblies/assembly_conda/*
mv ./tmp_keep/* ./assemblies/assembly_conda/
rmdir ./tmp_keep

conda deactivate

