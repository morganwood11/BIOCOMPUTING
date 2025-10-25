#!/bin/bash
set -ueo pipefail

#download sra accession files and move to ./data/raw
for ACC in $(cat ./data/A7_SRAruntable.csv | cut -d',' -f 1 | head -n 11 | tail -n +2);do fasterq-dump "$ACC" -O /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/raw;done

#download dog reference genome and move to reference directory
datasets download genome taxon "Canis lupus familiaris" --reference --filename /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/dog_reference/dog.zip
unzip /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/dog_reference/dog.zip -d /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/dog_reference

