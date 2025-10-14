#!/bin/bash
set -ueo pipefail


export PATH=$PATH:/sciclone/home/mrwood01/programs/Flye/bin

mkdir -p ./assemblies/assembly_local

flye \
  --nano-hq ./data/SRR33939694.fastq \
  --genome-size 200k \
  --out-dir ./assemblies/assembly_local \
  --threads 6 | tee ./assemblies/assembly_local/flye.log

mv ./assemblies/assembly_local/assembly.fasta ./assemblies/assembly_local/local_assembly.fasta
mv ./assemblies/assembly_local/flye.log ./assemblies/assembly_local/local_flye.log

mkdir -p ./tmp_keep
mv ./assemblies/assembly_local/local_assembly.fasta ./tmp_keep/
mv ./assemblies/assembly_local/local_flye.log ./tmp_keep/
rm -rf ./assemblies/assembly_local/*
mv ./tmp_keep/* ./assemblies/assembly_local/
rmdir ./tmp_keep
