#!/bin/bash
set -euo pipefail

mkdir -p /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/clean

# clean up reads, put them in the clean directory
for FWD in /sciclone/home/mrwood01/scr10/BIOCOMPUTING/assignments/assignment_07/data/raw/*_1.fastq;do echo $FWD;REV=${FWD/_1.fastq/_2.fastq}; echo $REV; OUTFWD=${FWD/raw/clean};OUTREV=${REV/raw/clean}; fastp --in1 "$FWD" --in2 "$REV" --out1 "$OUTFWD" --out2 "$OUTREV" --json /dev/null --html /dev/null --average_qual 20; done
