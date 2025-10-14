#!/bin/bash
set -ueo pipefail

module purge
module load Flye/gcc-11.4.1/2.9.6

mkdir -p ./assemblies/assembly_module

flye \
  --nano-hq ./data/SRR33939694.fastq \
  --genome-size 200k \
  --out-dir ./assemblies/assembly_module \
  --threads 6 | tee ./assemblies/assembly_module/flye.log

mv ./assemblies/assembly_module/assembly.fasta ./assemblies/assembly_module/module_assembly.fasta
mv ./assemblies/assembly_module/flye.log ./assemblies/assembly_module/module_flye.log

mkdir -p ./tmp_keep
mv ./assemblies/assembly_module/module_assembly.fasta ./tmp_keep/
mv ./assemblies/assembly_module/module_flye.log ./tmp_keep/
rm -rf ./assemblies/assembly_module/*
mv ./tmp_keep/* ./assemblies/assembly_module/
rmdir ./tmp_keep
